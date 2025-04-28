import socket
import struct
import os
from PIL import Image
from PIL.ExifTags import TAGS, GPSTAGS, IFD

exif_keys = []
def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""
    with open("index.txt","r") as i:
        file_no = int(i.read())
    i.close()
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(0)

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

        print(msg_len)
        print(len(data))
        
        # --- save img to specific file ---
        # need to have a way where a new file directory is created/selected with each new 'crime'
        file_name = "file_"+ str(file_no).strip() + ".jpg"
        file_path = os.path.join("folder1/", file_name)

        with open(file_path,"wb") as img_file:
            img_file.write(data)
        img_file.close()

      # --- send response ---
        img = Image.open(file_path)
        img_exif = img.getexif()

        for ifd_id in IFD:
            try:
                ifd = img_exif.get_ifd(ifd_id)
                if ifd_id == IFD.GPSInfo:
                    resolve = GPSTAGS
                else:
                    resolve = TAGS
                for k, v in ifd.items():
                    tag = resolve.get(k,k)
                    #print(tag + " : " + str(v))
                    exif_keys.append((TAGS[k],v))
            except KeyError:
                pass

        img.close()
        exif_string = ",".join("(%s,%s)" % tup for tup in exif_keys)
        #client_socket.send(exif_string.encode())

        with open(file_path,"rb") as ib:
            bytedata = ib.read()
        ib.close()
        client_socket.send(bytedata)

        print(exif_string) # for debugging

        file_no = file_no + 1
        with open("index.txt","w") as i:
            i.write(str(file_no))
        i.close()


if __name__ == "__main__":
    _ready()