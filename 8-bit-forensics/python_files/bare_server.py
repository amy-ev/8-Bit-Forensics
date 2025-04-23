import socket
import struct

def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(0) # maybe 0

    print("server listening")

    while True:
        client_socket, client_address = server.accept()

        print(f"connected to: {client_address}")
 
        msg_len = struct.unpack("!I", client_socket.recv(4))[0]
        data = bytearray()

        while len(data) < msg_len:
            packet = client_socket.recv(msg_len - len(data))
            if not packet:
                break
            data.extend(packet)

        print(len(data))
        client_socket.sendall("I might actually cry".encode())
        with open("sent.jpg","wb") as img_file:
            img_file.write(data)
        img_file.close()


if __name__ == "__main__":
    _ready()