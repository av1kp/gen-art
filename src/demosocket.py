import socket

def TestSocketClient():
    print("Tetsing socket ...")

    sock = socket.socket()
    port = 5204
    sock.connect(("127.0.0.1", port))
    data = "Yayyy, it's working !!"
    sock.send(data.encode())

    got = sock.recv(1024).decode()
    print ("Got data = [", got, "]")

    sock.close()