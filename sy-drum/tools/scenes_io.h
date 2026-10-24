/* SY DRUM's setup scenes on the card (2.18): syscenNN.work / .strd, 4,128 bytes, the development
 * line's format (magic SYSCENE\0, version 1), so a project moves between that line and this module
 * with its scene assignments. Included by locks_io.c: the same engine-task jobs carry a second,
 * independent file kind. It shares sl_io_file / sl_io_path / sl_io_object and never touches a
 * sylock file. SC_FS(x) names the file call. A bank's pair is written only once it has been edited
 * (generation != 0): a project with no setup scene assignment gets no syscen file, and an absent
 * pair loads as "nothing assigned". sc_crc / sc_get32 / sc_put32 serve gjlocks_io.h too. */
enum { SC_BANK=4096, SC_FILE=4128 };
extern volatile u32 sc_ready_mask, sc_dirty_mask, sc_blocked_mask;
extern volatile u32 sc_generation[16];
extern u8 sc_table[];
extern const u32 sl_crc_table[256];
static u32 sc_crc(const u8 *p,u32 n) {
    u32 c=~0u;
    while(n--)c=sl_crc_table[(c^*p++)&255]^(c>>8);
    return ~c;
}
static u32 sc_get32(const u8 *p) { return ((u32)p[0]<<24)|((u32)p[1]<<16)|((u32)p[2]<<8)|p[3]; }
static void sc_put32(u8 *p,u32 v) { p[0]=(u8)(v>>24);p[1]=(u8)(v>>16);p[2]=(u8)(v>>8);p[3]=(u8)v; }
static s32 sc_path(char *dst,const char *base,u32 bank,u32 stored) {
    const char *s;u32 n=0;
    if(bank>=16)return PATH_ERROR;
    while(base[n]) {if(n>=PATH_BYTES-15)return PATH_ERROR;dst[n]=base[n];++n;}
    if(!n)return PATH_ERROR;
    dst[n++]='/';s="syscen";while(*s)dst[n++]=*s++;
    ++bank;dst[n++]=(char)('0'+(bank>=10));dst[n++]=(char)('0'+(bank>=10?bank-10:bank));
    s=stored?".strd":".work";while(*s)dst[n++]=*s++;
    dst[n]=0;return 0;
}
/* 0: the validated payload is at sl_io_file+32. ABSENT / FUTURE / CORRUPT / an I/O error. */
static s32 sc_read(const char *base,u32 bank,u32 stored,u32 *generation) {
    s32 r,c,size;u32 n=0,i;const char *magic="SYSCENE";const u8 *f=sl_io_file;
    r=sc_path(sl_io_path,base,bank,stored);if(r<0)return r;
    r=SC_FS(open)(&sl_io_object,sl_io_path,"r",sl_io_sector,512);
    if(r<0)return r==-12?ABSENT:r==-10?CORRUPT:r;
    size=SC_FS(size)(sl_io_object.word[0]);
    if(size<0)r=size;
    else {
        n=(u32)size<32?(u32)size:32;
        r=SC_FS(read)(&sl_io_object,sl_io_file,n);
        if(r!=1)r=r<0?r:CORRUPT;
        else {
            for(i=0;i<8 && f[i]==(u8)magic[i];++i){}
            if(n>=10 && i==8 && (f[8]!=0||f[9]!=1))r=FUTURE;
            else if(n>=16 && i==8 && (f[10]!=0||f[11]!=32||f[14]||f[15]))r=FUTURE;
            else if(i!=8||size!=SC_FILE)r=CORRUPT;
            else {r=SC_FS(read)(&sl_io_object,sl_io_file+n,SC_FILE-n);r=r==1?0:r<0?r:CORRUPT;}
        }
    }
    c=SC_FS(close)(&sl_io_object);if(r>=0 && c<0)r=c;
    if(r<0)return r;
    if(f[12]!=0||f[13]!=bank||sc_get32(f+16)!=SC_BANK)return CORRUPT;
    if(sc_crc(f,28)!=sc_get32(f+28)||sc_crc(f+32,SC_BANK)!=sc_get32(f+24))return CORRUPT;
    for(i=0;i<SC_BANK;++i)if(f[32+i]>127 && f[32+i]!=255)return CORRUPT;
    *generation=sc_get32(f+20);return 0;
}
static void sc_header(u32 bank,u32 generation) {
    u8 *f=sl_io_file;const char *magic="SYSCENE";u32 i;
    for(i=0;i<8;++i)f[i]=(u8)magic[i];
    f[8]=0;f[9]=1;f[10]=0;f[11]=32;f[12]=0;f[13]=(u8)bank;f[14]=0;f[15]=0;
    sc_put32(f+16,SC_BANK);sc_put32(f+20,generation);
    sc_put32(f+24,sc_crc(f+32,SC_BANK));sc_put32(f+28,sc_crc(f,28));
}
static s32 sc_snapshot(u32 bank,u32 *generation) {
    u32 tries=3,g,i;const u8 *p=sc_table+bank*SC_BANK;
    do {
        g=sc_generation[bank];
        for(i=0;i<SC_BANK;++i)sl_io_file[32+i]=p[i];
        if(g==sc_generation[bank]){sc_header(bank,g);*generation=g;return 0;}
    }while(--tries);
    return BUSY;
}
static s32 sc_write_file(const char *base,u32 bank,u32 stored) {
    s32 r,c;
    r=sc_path(sl_io_path,base,bank,stored);if(r<0)return r;
    r=SC_FS(open)(&sl_io_object,sl_io_path,"w",sl_io_sector,512);if(r<0)return r;
    r=SC_FS(write)(&sl_io_object,sl_io_file,SC_FILE);
    if(r!=1)r=r<0?r:CORRUPT;else r=0;
    c=SC_FS(close)(&sl_io_object);return r<0?r:c<0?c:0;
}
static void sc_clean(u32 bank,u32 generation) {
    u32 sr=sl_io_irq_lock();
    if(generation==sc_generation[bank])sc_dirty_mask&=~(1u<<bank);
    sl_io_irq_restore(sr);
}
/* payload = 0: no assignments. The morph skips an unready bank (sc_refresh). */
static void sc_publish(u32 bank,u32 generation,const u8 *payload) {
    u8 *p=sc_table+bank*SC_BANK;u32 i,sr,bit=1u<<bank;
    sc_ready_mask&=~bit;
    for(i=0;i<SC_BANK;++i)p[i]=payload?payload[i]:255;
    sr=sl_io_irq_lock();
    sc_generation[bank]=generation;sc_ready_mask|=bit;
    sc_dirty_mask&=~bit;sc_blocked_mask&=~bit;
    sl_io_irq_restore(sr);
}
static void sc_block(u32 bank) {
    u32 sr=sl_io_irq_lock();
    sc_blocked_mask|=1u<<bank;sc_ready_mask&=~(1u<<bank);
    sl_io_irq_restore(sr);
}
/* WORK; a WORK that fails its checks: STRD (WORK is then rewritten by the next flush). A file of a
 * later version is preserved and that bank's assignments are disabled. */
static void sc_load_bank(u32 bank) {
    s32 w,s;u32 g=0,sr;
    w=sc_read(sl_io_base,bank,0,&g);
    if(w==0){sc_publish(bank,g,sl_io_file+32);return;}
    /* No WORK file: the bank was never edited (SAVE and RELOAD write WORK with STRD). The
     * STRD lookup is skipped -- 16 fewer directory searches at every project load. */
    if(w==ABSENT){sc_publish(bank,0,(const u8 *)0);return;}
    s=sc_read(sl_io_base,bank,1,&g);
    if(w==FUTURE||s==FUTURE){sc_block(bank);note(FUTURE,0);return;}
    if(s==0) {
        sc_publish(bank,g,sl_io_file+32);
        sr=sl_io_irq_lock();sc_dirty_mask|=1u<<bank;sl_io_irq_restore(sr);
        if(w!=ABSENT)note(w<0?w:CORRUPT,1);
        return;
    }
    sc_publish(bank,0,(const u8 *)0);
    if(w!=ABSENT||s!=ABSENT)note(w!=ABSENT?w:s,0);
}
static s32 sc_flush(u32 mask) {
    u32 bank,g;s32 r;
    mask&=sc_dirty_mask&sc_ready_mask&~sc_blocked_mask;
    for(bank=0;bank<16;++bank)if(mask&(1u<<bank)) {
        r=sc_snapshot(bank,&g);if(r<0)return r;
        r=sc_write_file(sl_io_base,bank,0);if(r<0)return r;
        sc_clean(bank,g);
    }
    return 0;
}
static s32 sc_store(u32 mask) {
    u32 bank,g;s32 r;
    mask&=sc_ready_mask&~sc_blocked_mask;
    for(bank=0;bank<16;++bank)if(mask&(1u<<bank)) {
        if(!sc_generation[bank] && !(sc_dirty_mask&(1u<<bank)))continue;
        r=sc_snapshot(bank,&g);if(r<0)return r;
        r=sc_write_file(sl_io_base,bank,0);if(r<0)return r;
        r=sc_write_file(sl_io_base,bank,1);if(r<0)return r;
        sc_clean(bank,g);
    }
    return 0;
}
/* RELOAD: STRD becomes WORK and RAM; no STRD = the saved project had no assignments. */
static void sc_restore(u32 mask) {
    u32 bank,g;s32 r;
    for(bank=0;bank<16;++bank)if((mask&(1u<<bank)) && !(sc_blocked_mask&(1u<<bank))) {
        r=sc_read(sl_io_base,bank,1,&g);
        if(r==0) {
            r=sc_write_file(sl_io_base,bank,0);
            sc_publish(bank,g,sl_io_file+32);
            if(r<0)note(r,0);
        } else if(r==ABSENT) {
            if(sc_path(sl_io_path,sl_io_base,bank,0)>=0)SC_FS(remove)(sl_io_path);
            sc_publish(bank,0,(const u8 *)0);
        } else if(r==FUTURE)sc_block(bank);
        else note(r,0);
    }
}
static s32 sc_delete(const char *base) {
    u32 bank,stored;s32 r;
    for(bank=0;bank<16;++bank)for(stored=0;stored<2;++stored) {
        r=sc_path(sl_io_path,base,bank,stored);
        if(r>=0)r=SC_FS(remove)(sl_io_path);
        if(r<0&&r!=-12)return r;
    }
    return 0;
}
static s32 sc_export(const char *source,const char *dest,char *from,char *to) {
    u32 bank,stored,g;s32 e;
    for(bank=0;bank<16;++bank)for(stored=0;stored<2;++stored) {
        e=sc_read(source,bank,stored,&g);if(e==ABSENT)continue;
        if(sc_path(from,source,bank,stored)<0||sc_path(to,dest,bank,stored)<0)return PATH_ERROR;
        e=SC_FS(copy)(to,from,0);if(e<0)return e;
    }
    return 0;
}
