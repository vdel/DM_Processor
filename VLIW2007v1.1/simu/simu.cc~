/*
  simu.cc du cours ASR1 2007
  Ce fichier est distrubué sous licence GPL
*/
#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <list>
#include <X11/Xlib.h>
#include <X11/keysym.h>

using namespace std;

int verbose;
// The screen will be updated every FRAMESKIP  str to the screen
#define FRAMESKIP 1

#define TOPSCREEN 0x5000
#define TOPRAM 0x8000

uint32_t video[640*512];
uint32_t r[2][16];
uint32_t pc[2];
bool p[2][8];
uint32_t mem[32768];

int skip_frame_counter;

void parse() {
  uint32_t adr = 0x5000;
  while (!cin.eof()) {
    // read a line
    char buf[256];
    cin.getline(buf, 256);
    string line(buf);
    istringstream sstr(line);
    sstr >> hex >> mem[adr];
    adr++;
  }
}



void render_all()
{
  for (int y = 0; y < 256; y++) {
    for (int x = 0; x < 320; x++) {
      unsigned char c = (mem[y*80+x/4] >> ((x%4)*8)) & 0xff;
      video[2*y*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
      video[2*y*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
      video[(2*y+1)*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
      video[(2*y+1)*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
    }
  }
}

void render_addr(uint32_t a)
{
  uint32_t y = a/80;
  uint32_t x = (a - y*80) << 2;
  unsigned char c;
  skip_frame_counter++;

  c= (mem[a] >> 0) & 0xff;
  video[2*y*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[2*y*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  x++;
  c= (mem[a] >> 8) & 0xff;
  video[2*y*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[2*y*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  x++;
  c= (mem[a] >> 16) & 0xff;
  video[2*y*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[2*y*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  x++;
  c= (mem[a] >> 24) & 0xff;
  video[2*y*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[2*y*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
  video[(2*y+1)*640+2*x+1] = ((c&0xe0)<<16) + ((c&0x18)<<11) + ((c&0x7)<<5);
}


int bank;

void step()
{
  uint32_t instr = mem[pc[bank]];
  uint32_t instr0 = instr & 0xFFFF;
  uint32_t instr1 = instr >> 16;

  uint32_t np0  = instr0 >> 13;
  uint32_t op0  = (instr0 >> 8) & 0x1f;
  uint32_t nrx0 = (instr0 >> 4) & 0xf;
  uint32_t nrp0 = (instr0 >> 4) & 0x7;
  uint32_t nry0 = instr0        & 0xf;
  uint32_t imm0 = instr0       & 0xff;

  uint32_t np1  = instr1 >> 13;
  uint32_t op1  = (instr1 >> 8) & 0x1f;
  uint32_t nrx1 = (instr1 >> 4) & 0xf;
  uint32_t nrp1  = (instr1 >> 4) & 0x7;
  uint32_t nry1  = instr1        & 0xf;
  uint32_t imm1 = instr1       & 0xff;
  uint32_t addr;

  if(verbose) {
    cout << setfill('0')  << "pc=" << setw(8) << hex << pc[bank]
	 << " instr=" << setw(8) << hex << instr;
  }


  // first increment the PC into its shadow.
  // jump instructions will override it
  pc[1-bank] = pc[bank] +1 ; 

  // way 0 before way 1 so that ldi0/ldi1 works as expected

  p[bank][0] = true; // if it has been set by mistake (TODO check ?) 
  if(p[bank][np0]) { // predicated execution
    switch (op0) {
    case 0x0:   // not
      r[1-bank][nrx0] = ~ r[bank][nry0];      
      break;
    case 0x1:   // and
      r[1-bank][nrx0] &= r[bank][nry0];
      break;
    case 0x2:   // or
      r[1-bank][nrx0] |= r[bank][nry0];
      break;
    case 0x3:   // xor
      r[1-bank][nrx0] ^= r[bank][nry0];
      break;
    case 0x4:   // lsl
      r[1-bank][nrx0] <<= r[bank][nry0];
      break;
    case 0x5:   // lsr 
      r[1-bank][nrx0] >>= r[bank][nry0];
      break;
    case 0x6:   // asl
      r[1-bank][nrx0] = ((r[bank][nrx0] << r[bank][nry0]) & 0x7fffffff) | (r[bank][nrx0] & 0x80000000); 
      break;
    case 0x7:   // asr
      r[1-bank][nrx0] = ((int32_t)r[bank][nrx0]) >> r[bank][nry0]; // TODO check that
      break;
    case 0x8:   // add
      r[1-bank][nrx0] += r[bank][nry0];
      break;
    case 0x9:   // sub
      r[1-bank][nrx0] -= r[bank][nry0];
      break;
    case 0xa:   // addc
      r[1-bank][nrx0] += r[bank][nry0];  // TODO quelle retenue ?
      break;
    case 0xb:   // subc 
      r[1-bank][nrx0] -= r[bank][nry0];
      break;
    case 0xc:   // inc
      r[1-bank][nrx0] = r[bank][nry0] + 1;
      break;
    case 0xd:   // dec
      r[1-bank][nrx0] = r[bank][nry0] - 1;
      break;
    case 0xe:   // ld 
      addr = r[bank][nry0];
      if (addr > TOPRAM)
	cerr << "Address out of RAM at pc="<<hex<<pc[bank]<<endl;
      else
	r[1-bank][nrx0] = mem[addr];
      break;
    case 0xf:   // str
      addr = r[bank][nry0];
      if (addr > TOPRAM)
	cerr << "Address out of RAM at pc="<<hex<<pc[bank]<<endl;
      else {
	mem[addr] = r[bank][nrx0];
	if(addr < TOPSCREEN) 
	  render_addr(addr);
      }
      break;
    case 0x10:   // ja 
      pc[1-bank] = r[bank][nry0];
      break;
    case 0x11:   // sra
      r[1-bank][nrx0] = pc[bank] + 2;
      break ;
    case 0x12:   // mov
      r[1-bank][nrx0] = r[bank][nry0];      
      break;
    case 0x13:   // 
      cerr << "Illegal instruction 0x13 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x14:   // gez/lsz
      p[1-bank][nrp0] = ((instr0 >> 7) & 1) ^ (((int32_t)r[bank][nry0]) >= 0);
      break;
    case 0x15:   // lez/gsz
      p[1-bank][nrp0] = ((instr0>> 7) & 1) ^ (((int32_t)r[bank][nry0]) <= 0);
      break;
    case 0x16:   // eqz/nez
      p[1-bank][nrp0] = ((instr0 >> 7) & 1) ^ (r[bank][nry0] == 0);
      break;
    case 0x17:   // 
      cerr << "Illegal instruction 0x17 at pc="<<hex<<pc[bank]<<endl;      
      break;
    case 0x18:   //
      cerr << "Illegal instruction 0x18 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x19:   // 
      cerr << "Illegal instruction 0x19 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1a:   // 
      cerr << "Illegal instruction 0x1a at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1b:   // 
      cerr << "Illegal instruction 0x1b at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1c:   // ldi0
      r[1-bank][0] = imm0;
      break;
    case 0x1d:   // ldi2
      r[1-bank][0] = (r[bank][0] & 0xff00ffff) | (imm0<<16);
      break;
    case 0x1e:   // jrf 
      pc[1-bank] = pc[bank] + imm0;
      break;
    case 0x1f:   // jrb
      pc[1-bank] = pc[bank] - imm0;
      break;
    default:   // 
      cerr << "A cosmic ray probably hit the simulator"<<endl;
      break;
    }
  }

  p[bank][0] = true; // if it has been set by mistake (TODO check ?) 
  if(p[bank][np1]) { // predicated execution
    switch (op1) {
    case 0x0:   // not
      r[1-bank][nrx1] = ~ r[bank][nry1];      
      break;
    case 0x1:   // and
      r[1-bank][nrx1] &= r[bank][nry1];
      break;
    case 0x2:   // or
      r[1-bank][nrx1] |= r[bank][nry1];
      break;
    case 0x3:   // xor
      r[1-bank][nrx1] ^= r[bank][nry1];
      break;
    case 0x4:   // lsl
      r[1-bank][nrx1] <<= r[bank][nry1];
      break;
    case 0x5:   // lsr 
      r[1-bank][nrx1] >>= r[bank][nry1];
      break;
    case 0x6:   // asl
      r[1-bank][nrx1] = ((r[bank][nrx1] << r[bank][nry1]) & 0x7fffffff) | (r[bank][nrx1] & 0x80000000); 
      break;
    case 0x7:   // asr
      r[1-bank][nrx1] = ((int32_t)r[bank][nrx1]) >> r[bank][nry1]; // TODO check that
      break;
    case 0x8:   // add
      r[1-bank][nrx1] += r[bank][nry1];
      break;
    case 0x9:   // sub
      r[1-bank][nrx1] -= r[bank][nry1];
      break;
    case 0xa:   // addc
      r[1-bank][nrx1] += r[bank][nry1];  // TODO quelle retenue ?
      break;
    case 0xb:   // subc 
      r[1-bank][nrx1] -= r[bank][nry1];
      break;
    case 0xc:   // inc
      r[1-bank][nrx1] = r[bank][nry1] + 1;
      break;
    case 0xd:   // dec
      r[1-bank][nrx1] = r[bank][nry1] - 1;
      break;
    case 0xe:   // ld 
      addr = r[bank][nry1];
      if (addr > TOPRAM)
	cerr << "Address out of RAM at pc="<<hex<<pc[bank]<<endl;
      else
	r[1-bank][nrx1] = mem[addr];
      break;
    case 0xf:   // str
      addr = r[bank][nry1];
      if (addr > TOPRAM)
	cerr << "Address out of RAM at pc="<<hex<<pc[bank]<<endl;
      else {
	mem[addr] = r[bank][nrx1];
	if(addr < TOPSCREEN) 
	  render_addr(addr);
      }
      break;
    case 0x10:   // ja 
      pc[1-bank] = r[bank][nry1] ;
      break;
    case 0x11:   // sra
      r[1-bank][nrx1] = pc[bank] + 2;
      break; 
    case 0x12:   // mov
      r[1-bank][nrx1] = r[bank][nry1];      
      break;
    case 0x13:   // 
      cerr << "Illegal instruction 0x13 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x14:   // gez/lsz
      p[1-bank][nrp1] = ((instr1 >> 7) & 1) ^ (((int32_t)r[bank][nry1]) >= 0);
      break;
    case 0x15:   // lez/gsz
      p[1-bank][nrp1] = ((instr1 >> 7) & 1) ^ (((int32_t)r[bank][nry1]) <= 0);
      break;
    case 0x16:   // eqz/nez
      p[1-bank][nrp1] = ((instr1 >> 7) & 1) ^ (r[bank][nry1] == 0);
      break;
    case 0x17:   // 
      cerr << "Illegal instruction 0x17 at pc="<<hex<<pc[bank]<<endl;      
      break;
    case 0x18:   //
      cerr << "Illegal instruction 0x18 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x19:   // 
      cerr << "Illegal instruction 0x19 at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1a:   // 
      cerr << "Illegal instruction 0x1a at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1b:   // 
      cerr << "Illegal instruction 0x1b at pc="<<hex<<pc[bank]<<endl;
      break;
    case 0x1c:   // ldi1
      if (op0==0x1c) // ldl16
	r[1-bank][0] = (r[1-bank][0] & 0x000000ff) | (imm1<<8);
      else
	r[1-bank][0] = (r[bank][0] & 0x000000ff) | (imm1<<8);
      break;
    case 0x1d:   // ldi3
      if (op0==0x1d)
	r[1-bank][0] = (r[1-bank][0] & 0x00ffffff) | (imm1<<24);
      else
	r[1-bank][0] = (r[bank][0] & 0x00ffffff) | (imm1<<24);
      break;
    case 0x1e:   // jrf 
      pc[1-bank] = pc[bank] + imm1;
      break;
    case 0x1f:   // jrb
      pc[1-bank] = pc[bank] - imm1;
      break;
    default:   // 
      cerr << "A cosmic ray probably hit the simulator"<<endl;
      break;
    }
  }
  // if we have two parallel jumps or two parallel affectations to the same registers,
  // we probably don't have the same behaviour as the hardware
  p[1-bank][0]=0;
  if(verbose) {
    for(int i=0; i<8; i++) 
      cout << " p" << dec << i << "=" << (p[1-bank][i] ? 1 : 0);
    cout << endl;
    for(int i=0; i<16; i++) 
      cout << " r" << dec << i << "=" << setw(8) << hex << r[1-bank][i];
    cout << endl;
  }

  // TODO add check that there has been no conflict here
  for(int i=0; i<16; i++) 
    r[bank][i] = r[1-bank][i];
  for(int i=0; i<8; i++) 
    p[bank][i] = p[1-bank][i];

  bank=1-bank;
  
  }



void keyPress(uint16_t x) {
  mem[mem[0x7fff]] = 0x00e0;
  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
  mem[mem[0xffff]] = 0x0072;
  if (++mem[0xffff] == 0xfffe) mem[0xffff] = 0xff00;
  mem[mem[0xffff]] = 0x00e0;
  if (++mem[0xffff] == 0xfffe) mem[0xffff] = 0xff00;
  mem[mem[0xffff]] = 0x00f0;
  if (++mem[0xffff] == 0xfffe) mem[0xffff] = 0xff00;
  mem[mem[0xffff]] = x;
  if (++mem[0xffff] == 0xfffe) mem[0xffff] = 0xff00;
}




int main(int argc, char* argv[])
{
  verbose = 0;
  if (argc>1) {
    string opt(argv[1]);
    if(opt=="-v")
      verbose=1;
  }

  parse();

  Display *dpy = XOpenDisplay(NULL);
  Window w = XCreateSimpleWindow(dpy, DefaultRootWindow(dpy), 
				 0, 0, 640, 512,
				 0, BlackPixel(dpy, DefaultScreen(dpy)), 
				 BlackPixel(dpy, DefaultScreen(dpy)));
  XMapWindow(dpy, w);
  XStoreName(dpy, w, "ASR1 2007 VLIW simulator");
  XSelectInput(dpy, w, ExposureMask | KeyPressMask);

  GC gc = XCreateGC(dpy, w, 0, NULL);

  XImage *img = XCreateImage(dpy, DefaultVisual(dpy, DefaultScreen(dpy)), 
			     24, ZPixmap, 0,
			     (char *)video, 640, 512, 32, 640*4);


  render_all();
  XPutImage(dpy, w, gc, img, 0, 0, 0, 0, 640, 512);
  XFlush(dpy);

  bank=0;
  pc[bank] = 0x5000;

  mem[0x7fff] = 0x7f00;

  while (true) {
    
    skip_frame_counter = 0;
    while (skip_frame_counter < FRAMESKIP) {
      
      for(int i=0; i<10; i++)
	step();

      XEvent event;
      if (XCheckMaskEvent(dpy, KeyPressMask, &event)) {
	XSelectInput(dpy, w, ExposureMask);
	//	cout << "****" << mem[0x7fff] <<  " " << (int)XLookupKeysym(&event.xkey, 0) << endl;
	if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 98) {
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0075;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0075;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 104) {
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0072;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0072;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 100) {
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x006b;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x006b;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 102) {
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0074;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00e0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0074;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 36) {
	  mem[mem[0x7fff]] = 0x005a;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x005a;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 10) {
	  mem[mem[0x7fff]] = 0x0016;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0016;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 11) {
	  mem[mem[0x7fff]] = 0x001e;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x001e;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 12) {
	  mem[mem[0x7fff]] = 0x0026;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0026;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 13) {
	  mem[mem[0x7fff]] = 0x0025;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0025;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 14) {
	  mem[mem[0x7fff]] = 0x002e;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x002e;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XKeysymToKeycode(dpy, XLookupKeysym(&event.xkey, 0)) == 15) {
	  mem[mem[0x7fff]] = 0x0036;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x00f0;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	  mem[mem[0x7fff]] = 0x0036;
	  if (++mem[0x7fff] == 0x7ffe) mem[0x7fff] = 0x7f00;
	}
	else if (XLookupKeysym(&event.xkey, 0) == XK_q)
	  return 0;
	XSelectInput(dpy, w, ExposureMask | KeyPressMask);
      }
    }
    if(verbose) {
      printf("Kbd buffer: ");
      for (int i=0x7f00; i<0x8000; i++) {
	printf ("%2x ", mem[i]);
      }
      printf( "\n");
    }

    XPutImage(dpy, w, gc, img, 0, 0, 0, 0, 640, 512);
    XFlush(dpy);
    
  }
  return 0;
}
