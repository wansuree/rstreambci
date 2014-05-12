#include <iostream>
#include "SockStream.h"

using namespace std;

int main( int argc, char** argv )
{
  const char* address = "localhost:5000";
  if( argc > 1 )
    address = argv[ 1 ];

  receiving_udpsocket socket( address );
  sockstream connection( socket );
  string line;
  // Print each line of BCI2000 input to stdout.
  while( getline( connection, line ) )
    cout << line << endl;

  return 0;
}
