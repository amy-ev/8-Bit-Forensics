import socket
from PIL import Image
from PIL.ExifTags import TAGS

def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""


    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(2) # maybe 0

    print("server listening")

    with open("index.txt", "r") as file_idx:
        file_no = int(file_idx.read())
    file_idx.close()

    while True:
        client_socket, client_address = server.accept()

        img_data = b''
        data = client_socket.recv(4096)

        while data:
            if not data:
                break
            img_data += data
            data = client_socket.recv(4096)

        print("recieved img")

        file_no = file_no+1

        with open("index.txt", "w") as file_idx:
            file_idx.write(str(file_no))
        file_idx.close()

        file_name = "image"+str(file_no)+".jpg"
        with open(file_name, "wb") as img_f:
            img_f.write(img_data)
            file_name = img_f.name
        print("img saved to file")

       
        client_socket.close()

def respond(filename):
    img = Image.open(filename)
    img_exif = img.getexif()
    img_str = ""
    
    for k, v in img_exif.items():
        img_str += str(TAGS[k])

    return img_str
_ready()