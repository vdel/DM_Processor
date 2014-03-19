/*
  asm.cc du cours ASR1 2007
  Ce fichier est distrubué sous licence GPL
*/

#include <iostream>
#include <iomanip>
#include <sstream>
#include <string>
#include <list>
#include <map>
#include <vector>

using namespace std;

int verbose;

vector<uint32_t> hexcode; // the code is compiled into this vector

map<string, uint32_t> label;   // the labels 

// A structure set up in the first pass, and used in the second pass to resolve labels
enum atr_type {JR, LDL16, LDL32} ;

struct address_to_resolve {
  uint32_t hexcode_index; // index in the hexcode vector
  int way;
  atr_type type;
  string label;
} ;

vector<address_to_resolve> todo; 



uint32_t line_number; // in the input file

uint32_t base_address = 0x5000; // address at which the code will be compiled
uint32_t current_address; // 

int way; // global to save parameter passing


void read_sep(list<string> &slist) {
  if(slist.empty()) {
    cerr << "Error, line " << line_number << ": expecting instruction separator /" << endl;
    exit(-1);
  }
  string s = slist.front();
  if(s!="/") {
    cerr << "Error, line " << line_number << ": expecting instruction separator /, got " << s << "'." << endl;
    exit(-1);
  }
  slist.pop_front();
}


uint32_t read_condpred(list<string> &slist) {
  string s = slist.front();
  if (string(s, 0, 2) != "?p")  {  //implicit predicate p0
    return 0;
    }
  else {
    s.erase(0, 2);
    istringstream valstr(s);
    int val;
    valstr >> val;
    if (val < 0 || val > 7) {
      cerr << "Error, line " << line_number << ": invalid predicate register p" << s << "'." << endl;
      exit(-1);
    }
    slist.pop_front();
    return val;
  }
}

uint32_t read_pred(list<string> &slist) {
  string s = slist.front();
  if (s[0]!='p')  { 
    cerr << "Error, line " << line_number << ": expected predicate register, got " << s << "'." << endl;
    exit(-1);
    }
  else {
    s.erase(0, 1);
    istringstream valstr(s);
    int val;
    valstr >> val;
    if (val < 0 || val > 7) {
      cerr << "Error, line " << line_number << ": invalid predicate register p" << s << "'." << endl;
      exit(-1);
    }
    slist.pop_front();
    return val;
  }
}


uint32_t read_reg(list<string> &slist) {
  string s = slist.front();
  if (s[0] != 'r')  {
    cerr << "Error, line " << line_number << ": expected register, got " << s << "'." << endl;
    exit(-1);
    }
  else {
    s.erase(0, 1);
    istringstream valstr(s);
    int val;
    valstr >> val;
    if (val < 0 || val > 15) {
      cerr << "Error, line " << line_number << ": invalid register r" << s << "'." << endl;
      exit(-1);
    }
    slist.pop_front();
    return val;
  }
}

uint32_t read_rx_ry(list<string>  & slist) {
  uint32_t code, rx, ry;
  code = 0;
  rx = read_reg(slist);
  code += rx<<4;
  ry = read_reg(slist);
  code += ry<<0;
  return code;
}

uint32_t read_px_ry(list<string>  & slist) {
  uint32_t code, px, ry;
  code = 0;
  px = read_pred(slist);
  code += px<<4;
  ry = read_reg(slist);
  code += ry<<0;
  //DM2
  if(px==0)
    cerr << "Warning, line " << line_number << ": writing in p0." << endl;
  return code;
}

uint32_t read_int(string s) {
  uint32_t val;
  if(string(s, 0, 2) == "0x") {
    s.erase(0, 2);
    istringstream valstr(s);
    valstr >> hex >> val;
  }
  else {
    istringstream valstr(s);
    valstr >> val;
  }
  return val;
}

uint32_t read_imm8(list<string>  & slist){
  string s = slist.front();
  uint32_t val = read_int(s);
  if (val < 0 || val > 255) {
    cerr << "Error, line " << line_number << ": invalid 8-bit immediate constant " << s << "'." << endl;
    exit(-1);
  }
  slist.pop_front();
  return val;
}


uint32_t read_imm8_or_label(list<string>  & slist){
  string s = slist.front();
  if(s[0]<'0' || s[0]>'9') { //assume a label
    address_to_resolve atr;
    atr.hexcode_index = hexcode.size();
    atr.type = JR;
    atr.way = way;
    atr.label = s;
    todo.push_back(atr);
    slist.pop_front();
    return 0;
  }
  else { // assume a numeric constant
    uint32_t val = read_int(s);
    if (val < 0 || val > 255) {
      cerr << "Error, line " << line_number << ": invalid 8-bit immediate constant " << s << "'." << endl;
      exit(-1);
    }
    slist.pop_front();
    return val;
  }
}


uint32_t read_imm16_or_label(list<string>  & slist){
  string s = slist.front();
  if(s[0]<'0' || s[0]>'9') { //assume a label
    address_to_resolve atr;
    atr.hexcode_index = hexcode.size();
    atr.type = LDL16;
    atr.label = s;
    todo.push_back(atr);
    return 0;
  }
  else { // assume a numeric constant
    istringstream valstr(s);
    uint32_t val = read_int(s);
    if (val < 0 || val > (1<<16)) {
      cerr << "Error, line " << line_number << ": invalid 16-bit immediate constant " << s << "'." << endl;
      exit(-1);
    }
    slist.pop_front();
    return val;
  }
}

uint32_t read_imm32_or_label(list<string>  & slist){
  string s = slist.front();
  if(s[0]<'0' || s[0]>'9') { //assume a label
    address_to_resolve atr;
    atr.hexcode_index = hexcode.size();
    atr.type = LDL32;
    atr.label = s;
    todo.push_back(atr);
    return 0;
  }
  else { // assume a numeric constant
    istringstream valstr(s);
    uint32_t val = read_int(s);
    slist.pop_front();
    return val;
  }
}



// this function returns the 16-bit code of an instruction
uint32_t read_op(list<string>  & slist) {
  uint32_t code;
  code = 0;
  
  // read the predicate if there is one, and put its number in place
  uint32_t pred = read_condpred(slist);
  code += pred << 13;
  
  // now read the instruction itself

  if (slist.front() == "nop") { // implemented as eqz r0 p0
    slist.pop_front();
    code += (((0x16 << 1)+0)<<7); 
  }
  else if (slist.front() == "not") {
    slist.pop_front();
    code+=0;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "and") {
    slist.pop_front();
    code += 0x1 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "or") {
    slist.pop_front();
    code += 0x2 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "xor") {
    slist.pop_front();
    code += 0x3 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "lsl") {
    slist.pop_front();
    code += 0x4 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "lsr") {
    slist.pop_front();
    code += 0x5 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "asl") {
    slist.pop_front();
    code += 0x6 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "asr") {
    slist.pop_front();
    code += 0x7 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "add") {
    slist.pop_front();
    code += 0x8 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "sub") {
    slist.pop_front();
    code += 0x9 << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "addc") {
    slist.pop_front();
    code += 0xa << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "subc") {
    slist.pop_front();
    code += 0xb << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "inc") {
    slist.pop_front();
    code += 0xc << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "dec") {
    slist.pop_front();
    code += 0xd << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "ld") {
    if (way!=1) {
      cerr << "Error, line " << line_number << ": ld only allowed on way 1." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0xe << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "str") {
    if (way!=1) {
      cerr << "Error, line " << line_number << ": str only allowed on way 1." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0xf << 8;
    code += read_rx_ry(slist);
  }
  else if (slist.front() == "ja") {
    slist.pop_front();
    code += 0x10 << 8;
    uint32_t ry = read_reg(slist);
    code += ry << 0;
  }
  else if (slist.front() == "sra") {
    slist.pop_front();
    code += 0x11 << 8;
    uint32_t rx = read_reg(slist);
    code += rx << 4;
  }
  else if (slist.front() == "mov") {
    slist.pop_front();
    code+=0x12<<8;
    code += read_rx_ry(slist);
  }
  //  13 unused
  else if (slist.front() == "gez") {
    slist.pop_front();
    code += (((0x14 << 1)+0)<<7);
    code += read_px_ry(slist);
  }
  else if (slist.front() == "lsz") {
    slist.pop_front();
    code += (((0x14 << 1)+1)<<7);
    code += read_px_ry(slist);
  }
  else if (slist.front() == "lez") {
    slist.pop_front();
    code += (((0x15 << 1)+0)<<7);
    code += read_px_ry(slist);
  }
  else if (slist.front() == "gsz") {
    slist.pop_front();
    code += (((0x15 << 1)+1)<<7);
    code += read_px_ry(slist);
  }
  else if (slist.front() == "eqz") {
    slist.pop_front();
    code += (((0x16 << 1)+0)<<7);
    code += read_px_ry(slist);
  }
  else if (slist.front() == "nez") {
    slist.pop_front();
    code += (((0x16 << 1)+1)<<7);
    code += read_px_ry(slist);
  }
  // TODO check that the way is the allowed one
  else if (slist.front() == "ldi0") {
    if (way!=0) {
      cerr << "Error, line " << line_number << ": ldi0 only allowed on way 0." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0x1c << 8;
    uint32_t imm8 = read_imm8(slist);
    code += imm8 << 0;
  }
  else if (slist.front() == "ldi1") {
    if (way!=1) {
      cerr << "Error, line " << line_number << ": ldi1 only allowed on way 1." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0x1c << 8;
    uint32_t imm8 = read_imm8(slist);
    code += imm8 << 0;
  }
  else if (slist.front() == "ldi2") {
    if (way!=0) {
      cerr << "Error, line " << line_number << ": ldi2 only allowed on way 0." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0x1d << 8;
    uint32_t imm8 = read_imm8(slist);
    code += imm8 << 0;
  }
  else if (slist.front() == "ldi3") {
    if (way!=1) {
      cerr << "Error, line " << line_number << ": ldi3 only allowed on way 1." << endl;
      exit(-1);
    }
    slist.pop_front();
    code += 0x1d << 8;
    uint32_t imm8 = read_imm8(slist);
    code += imm8 << 0;
  }
  else if (slist.front() == "jrf") {
    slist.pop_front();
    code += 0x1e << 8;
    uint32_t imm8 = read_imm8_or_label(slist);
    code += imm8 << 0;
  }
  else if (slist.front() == "jrb") {
    slist.pop_front();
    code += 0x1f << 8;
    uint32_t imm8 = read_imm8_or_label(slist);
    code += imm8 << 0;
  }

  
  else {
    cerr << "Error, line " << line_number << ": unknown opcode '" << slist.front() << "'." << endl;
    exit(-1);
  }
  return code;
}

//DM2
void check_warnings(uint32_t instr0,uint32_t instr1)
{
  uint32_t op0=(instr0 & 0x1F00)>>8;
  uint32_t r0=(instr0 & 0xF0)>>4;
  uint32_t p0=(instr0 & 0x70)>>4;
  uint32_t op1=(instr1 & 0x1F00)>>8;
  uint32_t r1=(instr1 & 0xF0)>>4;
  uint32_t p1=(instr1 & 0x70)>>4;
  
  uint32_t effective_register0;
  uint32_t effective_register1;

  switch(op0)
  {
    case 15: //str
    case 16: //ja
    case 30: //jrf
    case 31: //jrb
      effective_register0=256;
      break;
    case 20:  //gez lsz
    case 21:  //gsz lez
    case 22:  //eqz nez
      effective_register0=16+p0;
      break;
    case 28:  //ldi0 ldi1
    case 29:  //ldi2 ldi3
      effective_register0=0;
      break;             
    default:
      effective_register0=r0;
      break;         
  }

  switch(op1)
  {
    case 15: //str
    case 16: //ja
    case 30: //jrf
    case 31: //jrb
      effective_register1=257;
      break;
    case 20:  //gez lsz
    case 21:  //gsz lez
    case 22:  //eqz nez
      effective_register1=16+p1;
      break;
    case 28:  //ldi0 ldi1
    case 29:  //ldi2 ldi3
      if(op0==28 && op1==28)
    	effective_register1=257;
      else if(op0==29 && op1==29)
    	effective_register1=257;
      else
        effective_register1=0;
      break;             
    default:
      effective_register1=r1;
      break;         
  }
  if(effective_register0==effective_register1 && effective_register0!=16)
    cerr << "Warning, line " << line_number << ": Simultaneous writing in the same register." << endl;
  
  if((op0==16 || op0==30 || op0==31) && (op1==16 || op1==30 || op1==31))
    cerr << "Warning, line " << line_number << ": Simultaneous jump." << endl;
}




///////////////////////////////////////////////////////////////////////

int main(int argc, char* argv[]){

  verbose = 0;
  if (argc>1) {
    string opt(argv[1]);
    if(opt=="-v")
      verbose=1;
  }


  line_number = 0; // the line in the source code
  current_address = base_address; // the address in the object code
  // TODO  add the possibility to compile code to another address?

  // Pass 1 
  if(verbose){
    cerr << "**** PASS 1 ****" << endl;
  }
  while (!cin.eof()) {

    // read a line
    char buf[256];
    cin.getline(buf, 256);
    string line(buf);
    line_number++;
    if (line.empty())
      continue;
    
    // break the line into tokens
    istringstream sstr(line);
    list<string> slist;
    while (!sstr.eof()) {
      string str;
      sstr >> str;
      if (str[0] == ';') // comment: stop parsing here
	break;      
      else{
	if (!str.empty()) 
	  slist.push_back(str);
      }
    }


    if (!slist.empty()) {     // Now process the tokens
      string s;
      uint32_t code = 0;

      s = slist.front();

      // is the first token a label ?
      if (s[s.length()-1] == ':') {
	string id = s.substr(0, s.length()-1);
	// Does the label already exist ?
	if (label.find(id) != label.end()) {
          cerr << "Error, label " << id  << " already defined " << endl;
	  exit(-1);  
	}
	label[id] = current_address;	
	slist.pop_front(); // remove it
	if(verbose){
	  cerr << "label " << id << " @ " << setfill('0')  << setw(8) << hex << current_address <<endl;
	}
      }

      if (!slist.empty()) {     //proceed
	s = slist.front();
	// is this instruction a 32-bit constant ?
	if ((slist.size() == 1) && (s[0] == '_')) {
	  s.erase(0, 1);
	  code = read_int(s);
	  hexcode.push_back(code);
	  if(verbose){
	    cerr << "@ " << setfill('0')  << setw(8) <<hex << current_address 
		 << ": "  << setw(8) << hex << code << endl;
	  }
	  current_address++;
	  // TODO check size of this constant, etc
	}

	// pseudo instruction ldl16 
	else if ((slist.size() == 2) && s=="ldl16"){
	    slist.pop_front(); // remove it
	    uint32_t c = read_imm16_or_label(slist);
	    uint32_t ch = c>>8;
	    uint32_t cl = c & 0xFF;
	    // translation to ldi0 / ldi1
	    code = (((0x1c<<8) + ch) <<16) + (((0x1c<<8) + cl));
	    hexcode.push_back(code);
	    if(verbose){
	      cerr << "@ " << setfill('0')  << setw(8) <<hex << current_address 
		   << ": "  << setw(8) << hex << code << endl;
	    }
	    current_address++;
	  }
	else if ((slist.size() == 2) && s=="ldl32"){
	    slist.pop_front(); // remove it
	    uint32_t c = read_imm32_or_label(slist);
	    uint32_t c3 = c>>24;
	    uint32_t c2 = (c>>16) & 0xFF;
	    uint32_t c1 = (c>>8) & 0xFF;
	    uint32_t c0 = (c>>0) & 0xFF;
	    // translation to ldi0 / ldi1
	    code = (((0x1c<<8) + c1) <<16) + (((0x1c<<8) + c0));
	    hexcode.push_back(code);
	    if(verbose){
	      cerr << "@ " << setfill('0')  << setw(8) << hex << current_address 
		   << ": "  << setw(8) << hex << code << endl;
	    }
	    current_address++;
	    // translation to ldi2 / ldi3
	    code = (((0x1d<<8) + c3) <<16) + (((0x1d<<8) + c2));
	    hexcode.push_back(code);
	    if(verbose){
	      cerr << "@ " << setfill('0')  << setw(8) << hex << current_address 
		   << ": "  << setw(8) << hex << code << endl;
	    }
	    current_address++;
	}

	else { //normal instructions
	  way=1;
	  uint32_t instr1 = read_op(slist); 
	  read_sep(slist);
	  way=0;
	  uint32_t instr0 = read_op(slist); 
	  //DM2
          check_warnings(instr0,instr1);
	  code = (instr1  << 16) + instr0;
	  hexcode.push_back(code);
	  if(verbose){
	    cerr << "@ " << setfill('0')  << setw(8) << hex << current_address 
		 << ": "  << setw(8) << hex << code << endl;
	  }
	  current_address ++;
	}
      }
    }
  }
  // Pass 2
if(verbose){
  cerr << "**** PASS 2 ****" << endl;
}

  // Fix all the missing labels
  for (uint32_t i=0; i<todo.size(); i++) {
    address_to_resolve atr = todo[i];
    uint32_t index = atr.hexcode_index;
    atr_type type = atr.type;
    string s = atr.label;
    uint32_t instr;

    // look up the label
    if (label.find(s) == label.end()) {
          cerr << "Error, label " << s  << " is used but not defined " << endl;
	  exit(-1);  
    }
    // OK, the label exists
    uint32_t resolved_address = label[s];      
    uint32_t instr_address = base_address + index;
    // Now put the address to its proper place
    if (type==JR) {
      instr = hexcode[index];
      int delta = resolved_address - instr_address;
      uint32_t opcode = ((instr>>(16*atr.way))>>8) & 0x1f; 
      if(opcode != 0x1e && opcode != 0x1f) {
	cerr << "INTERNAL ERROR, found opcode " << hex << opcode 
	     << ", I'm lost, there should be a jrf/jrb " << s  << " at address " ;
	cerr.width(8); cerr.fill('0');
	cerr << hex << instr_address << endl;
	exit(-1);  
      }
      if(opcode==0x1e) { // jrf, delta should be positive
	if(delta<0 || delta>255) {
          cerr << "Error, jrf to label " << s  << " out of range " << endl;
	  exit(-1);  
	}
      }
      if(opcode==0x1f) { // jrb, delta should be negative
	delta = - delta;
	if(delta<0 || delta>255) {
          cerr << "Error, jrb to label " << s  << " out of range " << endl;
	  exit(-1);  
	}
      }
      instr=instr+(delta<<(16*atr.way));
      hexcode[index] = instr;
      if(verbose){
	cerr << "Resolved label " << s 
	     << ", at address " << setfill('0')  << setw(8) << hex << instr_address
	     << " code is now " << setfill('0')  << setw(8) << hex << instr << endl;
      }
    }
    else if (type==LDL16){
      if (resolved_address > (1<<16)){
	cerr << "Error, label " << s  << " resolves to "
	     << setfill('0')  << setw(8)  << hex << resolved_address 
	     << " which is out of range for ldl16" <<endl;
	  exit(-1);  
	}
      uint32_t ch = resolved_address >> 8;
      uint32_t cl = resolved_address & 0xFF;
      // translation to ldi0 / ldi1
      instr = (((0x1c<<8) + ch) <<16) + (((0x1c<<8) + cl));
      hexcode[index] = instr;
      if(verbose){
	cerr << "Resolved label " << s 
	     << ", at address " << setfill('0')  << setw(8) << hex << instr_address
	     << " code is now " << setfill('0')  << setw(8) << hex << instr << endl;
      }
    }
    else if (type==LDL32){
      uint32_t c3 = resolved_address>>24;
      uint32_t c2 = (resolved_address>>16) & 0xFF;
      uint32_t c1 = (resolved_address>>8) & 0xFF;
      uint32_t c0 = (resolved_address>>0) & 0xFF;
      // translation to ldi0 / ldi1
      instr = (((0x1c<<8) + c1) <<16) + (((0x1c<<8) + c0));     
      hexcode[index] = instr;
      // translation to ldi2 / ldi3
      instr = (((0x1d<<8) + c3) <<16) + (((0x1d<<8) + c2));
      hexcode[index+1] = instr;
      if(verbose){
	cerr << "Resolved label " << s 
	     << ", at address " << setfill('0')  << setw(8) << hex << instr_address
	     << " code is now " << setfill('0')  << setw(8) << hex << hexcode[index] 
	     << ", " << setfill('0')  << setw(8) << hex << hexcode[index+1]  << endl;
      }
    }
  }

  // Output
  if(verbose){
    cerr << "Outputing object code..." << endl;
  }
  for (uint32_t i=0; i<hexcode.size(); i++) {
      cout << setfill('0')  << setw(8) << hex << hexcode[i] << endl;
  }
  if(verbose){
    cerr << "...done" << endl;
  }
}


