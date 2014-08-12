import socket
import sys

# Sends udp test data piped in from STDIN to the listener.
# ex: cat sampleoutput.txt | python testsender.py 

UDP_IP = "127.0.0.1"
UDP_PORT = 5000
MESSAGE = "Hello, World!"

print "UDP target IP:", UDP_IP
print "UDP target port:", UDP_PORT
# print "message:", MESSAGE

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP

# Send from stdin
while True:
  line = sys.stdin.readline()
  if line:
    sock.sendto(line, (UDP_IP, UDP_PORT))
  else:
    break

sock.close()
