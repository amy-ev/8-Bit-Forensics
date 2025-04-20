from PIL import Image
from PIL.ExifTags import TAGS, GPSTAGS, IFD
import socket


file_name = ""
exifKeys = []

with open("index.txt", "r") as file_idx:
    file_no = int(file_idx.read())
    print(file_no)
file_idx.close()

print(file_no)
def run_server():
    global file_no

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_ip = "127.0.0.1" 
    port = 8000 

    server.bind((server_ip, port))
    server.listen(0)

    print(f"listening on {server_ip}:{port}")

    client_socket, client_address = server.accept() 

    file_no = file_no+1
    with open("index.txt", "w") as file_idx:
        file_idx.write(str(file_no))
    file_idx.close()


    data = client_socket.recv(1024)

    file_name = "image"+str(file_no)+".jpeg"

    f_output = open(file_name,"wb")

    while data:
        if not data:
            break
        else:
            f_output.write(data)
            data = client_socket.recv(1024)
            print(data.hex())
            #client_socket.send(data)
        print("hello")


    f_output.close()
    metadata = exif_read(file_name)
    server.send(metadata.encode('utf-8'))
    client_socket.close()

    print("connection to client closed")

    server.close()



def exif_read(img_file):
    img = Image.open(img_file)
    
    img_exif = img.getexif()
    #print(type(img_exif))
    if img_exif:

        img_exif_dict = dict(img_exif)
        for k, v in img_exif_dict.items():
            tag = TAGS.get(k,k)
            #print(tag,v)

        for ifd_id in IFD:
            #print(ifd_id.name)
            try:
                ifd = img_exif.get_ifd(ifd_id)
                if ifd_id == IFD.GPSInfo:
                    resolve = GPSTAGS
                else:
                    resolve = TAGS
                for k, v in ifd.items():
                    tag = resolve.get(k,k)
                    #print(tag + " : " + str(v))
                    exifKeys.append((TAGS[k],v))
            except KeyError:
                pass

        print("method called")
    else:
        print("no exif data")
    exif_string = ",".join("(%s,%s)" % tup for tup in exifKeys)
    return exif_string
                           
run_server()
