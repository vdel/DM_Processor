#include <iostream>
#include <iomanip>

using namespace std;

int main(int argc, char* argv[]) {
  char buf1[4];
  int buf2[4];
  int count=0;
  while (!cin.eof())   {
    cin.read(buf1,4);
    for(int i=0;i<4;i++) {
      buf2[i]=(int)buf1[3-i];
      if(buf2[i]<0)
        buf2[i]=256+buf2[i];
      buf2[i]=((buf2[i]&0x0f)<<4)+(buf2[i]>>4);
    }
    cout<<"\t_0x";
    cout<< setfill('0') << setw(2) << hex << buf2[0] 
	<< setfill('0')	<< setw(2) << hex << buf2[1]  
	<< setfill('0')	<< setw(2) << hex << buf2[2]  
	<< setfill('0')	<< setw(2) << hex << buf2[3]  << '\n';
    
    cin.read(buf1,4);
    for(int i=0;i<4;i++) {
      buf2[i]=(int)buf1[3-i];
      if(buf2[i]<0)
        buf2[i]=256+buf2[i];
      buf2[i]=((buf2[i]&0x0f)<<4)+(buf2[i]>>4);
    }
    cout<<"\t_0x";
    cout<< setfill('0') << setw(2) << hex << buf2[0]  
	<< setfill('0')	<< setw(2) << hex << buf2[1]  
	<< setfill('0')	<< setw(2) << hex << buf2[2]  
	<< setfill('0')	<< setw(2) << hex << buf2[3]  << '\n';	
    count++;
    if(count==256) break;
  }
  return 0;
}
