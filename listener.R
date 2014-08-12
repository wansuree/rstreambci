library(rPython)

python.exec("import socket")
python.exec("from array import array")

python.exec("UDP_IP = '127.0.0.1'
UDP_PORT = 5000  # bci2000 sends over port 5000 by default")

python.exec("sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP")
python.exec("sock.bind((UDP_IP, UDP_PORT))")

python.exec("stimtime = array('I')  # unsigned int
srctime = array('I')
sigvolt = array('d')  # double
target = array('c')  # char (should be binary, basically)
rowsel = array('I')  # unsigned int
colsel = array('I')  # unsigned int
isrun = array('c')  # char (binary)
isrec = array('c')  # char (binary)")

python.exec("# dictionary for label parsing
def lstimtime():
    stimtime.append(int(parsedata[1]))
    
def lsrctime():
    srctime.append(int(parsedata[1]))

def lsig(): # TODO doesn't work yet, we need a more clever test in the dict
    sigvolt.append(float(parsedata[1]))

def ltarg():
    target.append(parsedata[1])

def lrow():
    rowsel.append(int(parsedata[1]))

def lcol():
    colsel.append(int(parsedata[1]))

def lrun():
    isrun.append(parsedata[1])

def lrec():
    isrec.append(parsedata[1])

def default(): # catch default case
    pass")

python.exec("parsing = {'StimulusTime': lstimtime,
           'SourceTime': lsrctime,
           'Signal': lsig,
           'SelectedTarget': ltarg,
           'SelectedRow': lrow,
           'SelectedColumn': lcol,
           'Running': lrun,
           'Recording': lrec,
          }")

repeat {
  python.exec("data, addr = sock.recvfrom(1024)  # buffer size is 1024 bytes")
  
  r.data <- python.get("data")
  
  print(r.data)
  
  if (r.data == "END") {
      break
  }
}