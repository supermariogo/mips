/*--------------------------------------------------------------------
 * TITLE: Plasma TCP/IP HTTP Server
 * AUTHOR: Steve Rhoads (rhoadss@yahoo.com)
 * DATE CREATED: 4/22/06
 * FILENAME: http.c
 * PROJECT: Plasma CPU core
 * COPYRIGHT: Software placed into the public domain by the author.
 *    Software 'as is' without warranty.  Author liable for nothing.
 * DESCRIPTION:
 *    Plasma TCP/IP HTTP Server
 *--------------------------------------------------------------------*/
#include "rtos.h"
#include "tcpip.h"
#include "present.h"
#ifdef WIN32
#define UartPrintf printf
#define OS_MQueueCreate(A,B,C) 0
#define OS_MQueueGet(A,B,C) 0
#define OS_ThreadCreate(A,B,C,D,E) 0
#endif

static const char pageGif[]=
{
   "HTTP/1.0 200 OK\r\n"
   "Content-Length: %d\r\n"
   "Content-Type: binary/gif\r\n\r\n"
};
static const char pageGif2[]=
{
   "HTTP/1.0 200 OK\r\n"
   "Content-Type: binary/gif\r\n\r\n"
};
static const char pageBinary[]=
{
   "HTTP/1.0 200 OK\r\n"
   "Content-Length: %d\r\n"
   "Content-Type: binary/binary\r\n\r\n"
};
static const char pageBinary2[]=
{
   "HTTP/1.0 200 OK\r\n"
   "Content-Type: binary/binary\r\n\r\n"
};
static const char pageHtml[]={
   "HTTP/1.0 200 OK\r\n"
   "Content-Length: %d\r\n"
   "Content-Type: text/html\r\n\r\n"
};
static const char pageHtml2[]={
   "HTTP/1.0 200 OK\r\n"
   "Content-Type: text/html\r\n\r\n"
};
static const char pageText[]={
   "HTTP/1.0 200 OK\r\n"
   "Content-Length: %d\r\n"
   "Content-Type: text/text\r\n\r\n"
};
static const char pageEmpty[]=
{
   "HTTP/1.0 404 OK\r\n"
   "Content-Length: 0\r\n"
   "Content-Type: text/html\r\n\r\n"
};

static const PageEntry_t *HtmlPages;
static int HtmlFiles;


void HttpServer(IPSocket *socket)
{
   uint8 buf[600];
   char filename[80];
   int bytes, i, length, len, needFooter;
   char *name=NULL, *page=NULL;
   const char *header, *header2;

   if(socket == NULL)
      return;
   if(socket->funcPtr != HttpServer && socket->funcPtr)
   {
      socket->funcPtr(socket);
      return;
   }
   bytes = IPRead(socket, buf, sizeof(buf)-1);
   if(bytes)
   {
      buf[bytes] = 0;
      if(strncmp((char*)buf, "GET /", 5) == 0)
      {
         for(i = 0; ; ++i)
         {
            length = HtmlPages[i].length;
            if(length == -1)
               break;
            name = (char*)HtmlPages[i].name;
            page = (char*)HtmlPages[i].page;
            len = (int)strlen(name);
            if(strncmp((char*)buf+4, name, len) == 0)
               break;
         }
#ifndef EXCLUDE_FILESYS
         if(length == HTML_LENGTH_LIST_END && HtmlFiles)
         {
            FILE *file;
            char *ptr;

            name = (char*)buf + 5;
            ptr = strstr(name, " ");
            if(ptr)
               *ptr = 0;
            strcpy(filename, "/web/");
            strncat(filename, name, 60);
            file = fopen(filename, "rb");
            if(file == NULL)
            {
               strcpy(filename, "/flash/web/");
               strncat(filename, name, 60);
               file = fopen(filename, "rb");
            }
            if(file)
            {
               if(strstr(name, ".htm"))
                  IPWrite(socket, (uint8*)pageHtml2, sizeof(pageHtml2)-1);
               else if(strstr(name, ".gif"))
                  IPWrite(socket, (uint8*)pageGif2, sizeof(pageGif2)-1);
               else
                  IPWrite(socket, (uint8*)pageBinary2, sizeof(pageBinary2)-1);
               for(;;)
               {
                  len = fread(buf, 1, sizeof(buf), file);
                  if(len == 0)
                     break;
                  IPWrite(socket, (uint8*)buf, len);
               }
               fclose(file);
               IPWriteFlush(socket);
               IPClose(socket);
               return;
            }
         }
#endif //!EXCLUDE_FILESYS
         if(length != HTML_LENGTH_LIST_END)
         {
            if(length == HTML_LENGTH_CALLBACK)
            {
               IPCallbackPtr funcPtr = (IPCallbackPtr)(uint32)page;
               funcPtr(socket, buf, bytes);
               return;
            }
            if(length == 0)
               length = (int)strlen(page);
            needFooter = 0;
            header2 = NULL;
            if(strstr(name, ".html"))
               header = pageHtml;
            else if(strstr(name, ".htm") || strcmp(name, "/ ") == 0)
            {
               header = pageHtml;
               header2 = HtmlPages[0].page;
               needFooter = 1;
            }
            else if(strstr(HtmlPages[i].name, ".gif"))
               header = pageGif;
            else
               header = pageBinary;
            len = 0;
            if(header2)
               len += (int)strlen(header2) + (int)strlen(HtmlPages[1].page);
            sprintf((char*)buf, header, length + len);
            IPWrite(socket, buf, (int)strlen((char*)buf));
            if(header2)
               IPWrite(socket, (uint8*)header2, (int)strlen(header2));
            IPWrite(socket, (uint8*)page, length);
            if(needFooter)
               IPWrite(socket, (uint8*)HtmlPages[1].page, (int)strlen(HtmlPages[1].page));
         }
         else
         {
            IPWrite(socket, (uint8*)pageEmpty, (int)strlen(pageEmpty));
         }
         IPClose(socket);
      }
   }
}


void HttpInit(const PageEntry_t *Pages, int UseFiles)
{
   HtmlPages = Pages;
   HtmlFiles = UseFiles;
   IPOpen(IP_MODE_TCP, 0, 80, HttpServer);
   IPOpen(IP_MODE_TCP, 0, 8080, HttpServer);
}


#ifdef EXAMPLE_HTML
//Example test code
static void MyProg(IPSocket *socket, char *request, int bytes)
{   char i=0;
	uint8_t plain[] ={0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
	uint8_t key[]=	{0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
	uint8_t cipher[9];
   char *text="HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"
              "<html><body><h2>PRESENT Encryption</h2><br>"
			  "64bits plain, 80bits key, 64bits cipher<br>";
	char *br="<br>";
    (void)request; (void)bytes;
    IPWrite(socket, (uint8*)text, (int)strlen(text));

	present(plain,key,cipher);
	for (i=0;i<8;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(plain[i])+1), 1);
	IPWrite(socket, (uint8*)(xtoa(plain[i])), 1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	for (i=0;i<10;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(key[i])+1),1);
	IPWrite(socket, (uint8*)(xtoa(key[i])), 1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	for (i=0;i<8;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(cipher[i])+1), 1);
	IPWrite(socket, (uint8*)(xtoa(cipher[i])),1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	IPClose(socket);
}

static void MyPresent(IPSocket *socket, char *request, int bytes)
{   char i=0;
	uint8_t plain[8];
	uint8_t key[10];
	uint8_t cipher[8];
   char *text="HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"
              "<html><body><h2>PRESENT Encryption</h2><br>"
			  "64bits plain, 80bits key, 64bits cipher<br>";
	char *br="<br>";
   // (void)request;
	(void)bytes;
	atox(request+21,plain,8);
	atox(request+40,key,10);
    IPWrite(socket, (uint8*)text, (int)strlen(text));
	
	present(plain,key,cipher);
	for (i=0;i<8;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(plain[i])+1), 1);
	IPWrite(socket, (uint8*)(xtoa(plain[i])), 1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	for (i=0;i<10;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(key[i])+1),1);
	IPWrite(socket, (uint8*)(xtoa(key[i])), 1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	for (i=0;i<8;i++)
	{
	IPWrite(socket, (uint8*)(xtoa(cipher[i])+1), 1);
	IPWrite(socket, (uint8*)(xtoa(cipher[i])),1);
	}
	IPWrite(socket, (uint8*)br, (int)strlen(br));

	IPClose(socket);
}
static const PageEntry_t pageEntry[]=
{  //name, length, htmlText
   {"/Header", 0, "<HTML><HEAD><TITLE>Plasma CPU</TITLE></HEAD>\n<BODY>"},
   {"/Footer", 0, "</BODY></HTML>"},
   {"/ ", 0, "<h2>Home Page</h2>Welcome! <br> 1.<a href='/other.htm'>Hello Word</a>"
             "<br><br><br>2."
			 "<form name=\"mypresent\" action=\"./cgi/mypresent\"> plain:<input type=\"text\" name=\"p\" /> <br/>key:<input type=\"text\" name=\"k\" /><br/><input type=\"submit\" value=\"submit\" /></form>"
			 "<br><br><br>3.<a href='http://202.118.229.199/you.html'>End</a>"
              },
   {"/other.htm ", 0, "<h2>Hello World</h2>Hello World."},
   //{"/binary/plasma.gif ", 1945, PlasmaGif},
   {"/cgi/mypresent", HTML_LENGTH_CALLBACK, (char*)(int)MyPresent},
   {"/cgi/myprog", HTML_LENGTH_CALLBACK, (char*)(int)MyProg},
   {"", HTML_LENGTH_LIST_END, NULL}
};
void HtmlInit(int UseFiles)
{
   (void)UseFiles;
   HttpInit(pageEntry, 1);
}
#endif


