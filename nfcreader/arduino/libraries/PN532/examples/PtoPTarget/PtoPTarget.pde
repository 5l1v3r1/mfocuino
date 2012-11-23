#include <PN532.h>

#define SCK 13
#define MOSI 11
#define SS 10
#define MISO 12

PN532 nfc(SCK, MISO, MOSI, SS);

void setup(void) {
    Serial.begin(9600);
    Serial.println("Hello!");

    nfc.begin();

    uint32_t versiondata = nfc.getFirmwareVersion();
    if (! versiondata) {
        Serial.print("Didn't find PN53x board");
        while (1); // halt
    }
    // Got ok data, print it out!
    Serial.print("Found chip PN5"); Serial.println((versiondata>>24) & 0xFF, HEX);
    Serial.print("Firmware ver. "); Serial.print((versiondata>>16) & 0xFF, DEC);
    Serial.print('.'); Serial.println((versiondata>>8) & 0xFF, DEC);
    Serial.print("Supports "); Serial.println(versiondata & 0xFF, HEX);

    // configure board to read RFID tags and cards
    nfc.SAMConfig();
}

char DataOut[]="HELLO INITIATOR"; //16bytes
char DataIn[16];//Should be 16bytes

void loop(void) {

    // Configure PN532 as Peer to Peer Target
    if(nfc.configurePeerAsTarget()) //if connection is error-free
    {
        //trans-receive data
        if(nfc.targetTxRx(DataOut,DataIn))
        {
         Serial.print("Data Received: ");
         Serial.println(DataIn);
        }
    }

}

      
      

