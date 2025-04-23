import socket
import struct
import binascii

host = "127.0.0.1"
port = 8000

def _ready():

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(1) # maybe 0

    print(f"[+] listening on port {host}:{port}")

    while True:
        client_socket, client_address = server.accept()
        print(f"[+] accepted connection from: {client_address}")
        msg = recv_msg(client_socket)

        # will ONLY reach this point if the client disconnects

        # print("recieved")
        # response = "kill me".encode()
        # print("sending response")
        # send_data(client_socket, response)
        # print("sent")
        #print(binascii.hexlify(msg).decode())

        with open("hex.txt","w") as hex_text:
            hex_text.write(binascii.hexlify(msg).decode())
        hex_text.close()

        with open("sent.jpg", "wb") as img:
            img.write(msg)
        img.close()

        response = "accepted".encode("utf-8")
        send_data(client_socket, response)
        print("got here")
    client_socket.close()


def recv_msg(client_socket):
    msg_len = recv_data(client_socket, 4)
    if not msg_len or len(msg_len) < 4:
        print("failed to read msg length")
        return None
    msg_len = struct.unpack("!I", msg_len)[0] #big-endian unsigned int
    print("msg length: ", msg_len)

    return recv_data(client_socket, msg_len)

def recv_data(client_socket, num_bytes):
    data = bytearray()
    while len(data) < num_bytes:
        packet = client_socket.recv(num_bytes - len(data))
        #print(packet)
        if not packet:
            break
        data.extend(packet) # byte array used extend not append
    
    return data

def send_data(socket, data):
    data = struct.pack("!I", len(data)) + data
    socket.sendall(data)

if __name__ == "__main__":
    _ready()