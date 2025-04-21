import socket
import struct
from PIL import Image
from PIL.ExifTags import TAGS

def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(1) # maybe 0

    print("server listening")

    with open("index.txt", "r") as file_idx:
        file_no = int(file_idx.read())
    file_idx.close()

    while True:
        client_socket, client_address = server.accept()
        
        b_size = client_socket.recv(4)

        # if not b_size:
        #     print("No response.")
        #     break

        img_size= struct.unpack('!I', b_size)[0]

        img_data = b''

        while len(img_data) < img_size:
            data = client_socket.recv(4096)
            if not data:
                break
            img_data += data
        print("recieved img")

        file_no = file_no+1
        
        with open("index.txt", "w") as file_idx:
            file_idx.write(str(file_no))
        file_idx.close()

        file_name = "image"+str(file_no)+".jpeg"
        with open(file_name, "wb") as img_f:
            img_f.write(img_data)
            file_name = img_f.name
        print("img saved to file")

        response_str = respond(file_name)
        response_bytes = response_str.encode('utf-8')

        client_socket.sendall(struct.pack('!I', len(response_bytes)))
        client_socket.sendall(response_bytes)
        print("hex result returned")

        client_socket.close()


def respond(filename):
    img = Image.open(filename)
    img_exif = img.getexif()
    img_str = ""
    
    for k, v in img_exif.items():
        img_str += str(TAGS[k])

    return img_str

if __name__ == "__main__":
    _ready()
