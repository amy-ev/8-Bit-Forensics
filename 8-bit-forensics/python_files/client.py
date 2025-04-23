import socket
import struct
from PIL import Image
import binascii

host = "127.0.0.1"
port = 8000

# replicate in godot

def _ready():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((host, port))

    with open("example.jpg", "rb") as img:
        msg = img.read()
    send_data(client, msg)
    print(binascii.hexlify(msg).decode())


def recv_msg(client_socket):
    msg_len = recv_data(client_socket, 4)
    if not msg_len:
        return None
    msg_len = struct.unpack("!I", msg_len)[0] #big-endian unsigned int
    return recv_data(client_socket, msg_len)

def recv_data(client_socket, num_bytes):
    data = bytearray()
    while len(data) < num_bytes:
        packet = client_socket.recv(num_bytes - len(data))
        if not packet:
            break
        data.extend(packet) # byte array used extend not append
        print(data)
    return data

def send_data(client_socket, data):
    # append the packet size to the beginning of the data
    print(len(data))#3857200

    data = struct.pack("!I", len(data)) + data
    client_socket.sendall(data)

if __name__ == "__main__":
    _ready()