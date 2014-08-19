library(rPython)

python.exec("import socket")
python.exec("from array import array")

python.exec("UDP_IP = '127.0.0.1'
UDP_PORT = 5000  # bci2000 sends over port 5000 by default")

python.exec("sock = socket.socket(socket.AF_INET,  # Internet
                     socket.SOCK_DGRAM)  # UDP")
python.exec("sock.bind((UDP_IP, UDP_PORT))")


# Data structures for holding columns
# (this is provisional, probably needs refactoring down the road)
stimtime <- array()
srctime <- array()
sig <- array()
seltgt <- array()
seltgt <- factor(seltgt, levels = c(0,1))
selrow <- array()
selcol <- array()
is.run <- array()
is.run <- factor(is.run, levels = c(0,1))
is.rec <- array()
is.rec <- factor(is.rec, levels = c(0,1))

repeat {
  python.exec("data, addr = sock.recvfrom(65535)  # buffer size as arg")
  
  r.data <- python.get("data")
  
  print(r.data)
  
  if (r.data == "END\n") {
      break # This is never reached. TODO investigate/fix
  }
  
  input <- strsplit(r.data, " ")[[1]] # split by spaces
  
  switch(input[1],
         StimulusTime = {
           stimtime <- append(stimtime, as.integer(input[2]))
         },
         SourceTime = {
           srctime <- append(srctime, as.integer(input[2]))
         },
         SelectedTarget = {
           seltgt <- append(seltgt, as.integer(input[2]))
         },
         SelectedRow = {
           selrow <- append(selrow, as.integer(input[2]))
         },
         SelectedColumn = {
           selcol <- append(selcol, as.integer(input[2]))
         },
         Running = {
           is.run <- append(is.run, as.integer(input[2]))
         },
         Recording = {
           is.rec <- append(is.rec, as.integer(input[2]))
         })
}

python.exec("sock.close()")