import socket
from array import array

UDP_IP = "127.0.0.1"
UDP_PORT = 5000  # bci2000 sends over port 5000 by default

sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP
sock.bind((UDP_IP, UDP_PORT))

# Things we get from the AppConnector (incomplete list in order of importance):
# StimulusTime -- time in ms?
# Signal(x,y) -- voltage in microvolts? what are x and y?
# SelectedTarget -- should be class label
# SelectedRow -- selected row of speller
# SelectedColumn -- selected column of speller
# Running -- Whether or not test is running?
# Recording -- Umm?
# ...delimited by empty message and LF..

stimtime = array('I')  # unsigned int
srctime = array('I')
sigvolt = array('d')  # double
target = array('c')  # char (should be binary, basically)
rowsel = array('I')  # unsigned int
colsel = array('I')  # unsigned int
isrun = array('c')  # char (binary)
isrec = array('c')  # char (binary)


# dictionary for label parsing
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
    pass

parsing = {"StimulusTime": lstimtime,
           "SourceTime": lsrctime,
           "Signal": lsig,
           "SelectedTarget": ltarg,
           "SelectedRow": lrow,
           "SelectedColumn": lcol,
           "Running": lrun,
           "Recording": lrec,
          }

try:
    while True:
        data, addr = sock.recvfrom(1024)  # buffer size

        print data
        # write to file for later testing
        # file = open("testp300dummy.txt", "a")
        # file.write(data)
        if data == "END\n":
            break

        # split the data into label and value
        parsedata = data.split()

        # actually parse
        # TODO needs error handling
        if len(parsedata) > 0:
            parsing.get(parsedata[0],default)
except KeyboardInterrupt:
    file.close
