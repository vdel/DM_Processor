/* Written by Nicolas Bonifas */

#include <stdio.h>

void rX(int instr)
{
  printf("r%d ", (instr & 0x00f0) >> 4);
}

void rY(int instr)
{
  printf("r%d", (instr & 0x000f));
}

void rp(int instr)
{
  printf("p%d ", (instr & 0x0070) >> 4);
}

void Y(int instr)
{
  printf("0x%x", (instr & 0x00ff));
}

void decode(int instr, int voie)
{
  if (instr & 0xe000)
    printf("?p%d ", (instr & 0xe000) >> 13);
  switch((instr & 0x1f00) >> 8)
    {
      //instructions générales
    case 0:
      printf("not ");
      rX(instr);
      rY(instr);
      break;
    case 1:
      printf("and ");
      rX(instr);
      rY(instr);
      break;
    case 2:
      printf("or ");
      rX(instr);
      rY(instr);
      break;
    case 3:
      printf("xor ");
      rX(instr);
      rY(instr);
      break;
    case 4:
      printf("lsl ");
      rX(instr);
      rY(instr);
      break;
    case 5:
      printf("lsr ");
      rX(instr);
      rY(instr);
      break;
    case 6:
      printf("asl ");
      rX(instr);
      rY(instr);
      break;
    case 7:
      printf("asr ");
      rX(instr);
      rY(instr);
      break;
    case 8:
      printf("add ");
      rX(instr);
      rY(instr);
      break;
    case 9:
      printf("sub ");
      rX(instr);
      rY(instr);
      break;
    case 10:
      printf("addc ");
      rX(instr);
      rY(instr);
      break;
    case 11:
      printf("subc ");
      rX(instr);
      rY(instr);
      break;
    case 12:
      printf("inc ");
      rX(instr);
      rY(instr);
      break;
    case 13:
      printf("dec ");
      rX(instr);
      rY(instr);
      break;
    case 14:
      printf("ld ");
      rX(instr);
      rY(instr);
      break;
    case 15:
      printf("str ");
      rX(instr);
      rY(instr);
      break;
    case 16:
      printf("ja ");
      rY(instr);
      break;
    case 17:
      printf("sra ");
      rX(instr);
      rY(instr);
      break;
    case 18:
      printf("mov ");
      rX(instr);
      rY(instr);
      break;
      // instructions de comparaison
    case 20:
      if (instr & 0x80)
	printf("lsz ");
      else
	printf("gez ");
      rp(instr);
      rY(instr);
      break;
    case 21:
      if (instr & 0x80)
	printf("gsz ");
      else
	printf("lez ");
      rp(instr);
      rY(instr);
      break;
    case 22:
      if (instr & 0x7f)
	{
	  if (instr & 0x80)
	    printf("nez ");
	  else
	    printf("eqz ");
	  rp(instr);
	  rY(instr);
	}
      else
	printf("nop");
      break;
      // instructions à opérande immédiate
    case 28:
      if (voie)
	printf("ldi1 ");
      else
	printf("ldi0 ");
      Y(instr);
      break;
    case 29:
      if (voie)
	printf("ldi3 ");
      else
	printf("ldi2 ");
      Y(instr);
      break;
    case 30:
      printf("jrf ");
      Y(instr);
      break;
    case 31:
      printf("jrb ");
      Y(instr);
      break;
    default:
	printf("UNKNOWN");
    }
}

int main()
{
  int instr;
  while(scanf("%x", &instr) != EOF)
    {
      decode((instr & 0xffff0000) >> 16, 1);
      printf(" / ");
      decode((instr & 0x0000ffff), 0);
      printf("\n");
    }
  return 0;
}
