/*
 modified 12 Aug 2013
 by Soohwan Kim (suhwan@wiznet.co.kr)

 - 10 Apr. 2015
 Added support for Arduino Ethernet Shield 2
 by Arduino.org team
 
 */
#ifndef ethernet_h
#define ethernet_h

#include <inttypes.h>
#include "w5500.h"
#include "IPAddress.h"
#include "EthernetClient.h"
#include "Dhcp.h"

class EthernetClass {
private:
  IPAddress _dnsServerAddress;
  char* _dnsDomainName;
  char* _hostName;
  DhcpClass _dhcp;
public:
  uint8_t w5500_cspin;

  static uint8_t _state[MAX_SOCK_NUM];
  static uint16_t _server_port[MAX_SOCK_NUM];

  EthernetClass() {w5500_cspin = 10; }
  void init(uint8_t _cspin = 10) { w5500_cspin = _cspin; }

  // Initialize the Ethernet shield to use the provided MAC address and gain the rest of the
  // configuration through DHCP.
  // Returns 0 if the DHCP configuration failed, and 1 if it succeeded
  int begin(uint8_t *mac_address);
  
  int maintain();

  friend class EthernetClient;
  friend class EthernetServer;
};

extern EthernetClass Ethernet;

#endif
