#ifndef ethernetclient_h
#define ethernetclient_h

#include "Client.h"
#include "IPAddress.h"

class EthernetClient : public Client {

public:
  EthernetClient();

  uint8_t status();
  virtual int connect(IPAddress ip, uint16_t port);
  virtual size_t write(uint8_t);
  virtual size_t write(const uint8_t *buf, size_t size);
  virtual int available();
  virtual int read();
  virtual int read(uint8_t *buf, size_t size);
  virtual int peek();
  virtual void stop();
  virtual uint8_t connected();
  virtual operator bool();
  virtual bool operator==(const EthernetClient&);
  virtual bool operator!=(const EthernetClient& rhs) { return !this->operator==(rhs); };

  friend class EthernetServer;


private:
  static uint16_t _srcport;
  uint8_t _sock;
};

#endif
