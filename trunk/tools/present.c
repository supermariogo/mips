#include "plasma.h"
#include "present.h"
extern int puts(const char *string);
extern int putchar(int value);


int main(void)
{
    char i=0;
	uint8_t plain[] ={0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
	uint8_t key[]=	{0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
	uint8_t cipher[9];
	present(plain,key,cipher);
	for (i=0;i<8;i++)
	{
	putchar(*(xtoa(plain[i])+1));
	putchar(*(xtoa(plain[i])));	
	}
	puts("\r\n");
	for (i=0;i<10;i++)
	{
	putchar(*(xtoa(key[i])+1));	
	putchar(*(xtoa(key[i])));
	}
	puts("\r\n");
	for (i=0;i<8;i++)
	{
	putchar(*(xtoa(cipher[i])+1));	
	putchar(*(xtoa(cipher[i])));
	}
	puts("\r\n");
	return 0;
}

 IPWrite(socket, (uint8*)(xtoa(plain[i])+1), (int)strlen(xtoa(plain[i])+1));
 IPWrite(socket, (uint8*)(xtoa(plain[i])+1), (int)strlen(xtoa(plain[i])+1));
