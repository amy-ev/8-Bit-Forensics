import socket
import struct
from PIL import Image
from PIL.ExifTags import TAGS

def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""
    with open("index.txt","r") as i:
        file_no = int(i.read())
    i.close()
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(0) # maybe 0

    print("server listening")

    while True:
        client_socket, client_address = server.accept()

        print(f"connected to: {client_address}")
        # --- receive data ---
        msg_len = struct.unpack("!I", client_socket.recv(4))[0]
        data = bytearray()

        while len(data) < msg_len:
            packet = client_socket.recv(msg_len - len(data))
            if not packet:
                break
            data.extend(packet)

        print(len(data))
        
        # --- send response ---
        client_socket.sendall("I might actually cry".encode())

        file_name = "file_"+ str(file_no).strip() + ".jpg"
        with open(file_name,"wb") as img_file:
            img_file.write(data)
        img_file.close()

        file_no = file_no + 1
        with open("index.txt","w") as i:
            i.write(str(file_no))
        i.close()


if __name__ == "__main__":
    _ready()