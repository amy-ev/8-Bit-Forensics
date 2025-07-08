import socket
import struct
import os
import json
from PIL import Image
from PIL import ExifTags

exif_dict = {}
gps_dict = {}
def _ready():

    host = '127.0.0.1'
    port = 8000

    file_name = ""
    # with open("index.txt","r") as i:
    #     file_no = int(i.read())
    # i.close()
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((host, port))
    server.listen(0)

    print("server listening")

    while True:
        client_socket, client_address = server.accept()

        print(f"connected to: {client_address}")

        # --- receive data ---
        file_no = struct.unpack("!I",client_socket.recv(4))[0]
        print("file idx: ", file_no)

        msg_len = struct.unpack("!I", client_socket.recv(4))[0]
        print("msg_len: ", msg_len)

        data = bytearray()

        while len(data) < msg_len:
            packet = client_socket.recv(msg_len - len(data))
            if not packet:
                break
            data.extend(packet)

        # --- save img to specific file ---
        # need to have a way where a new file directory is created/selected with each new 'crime'
        file_name = "file_"+ str(file_no).strip() + ".jpg"
        file_path = os.path.join("folder1/", file_name)

        with open(file_path,"wb") as img_file:
            img_file.write(data)
        img_file.close()

      # --- send response ---
        img = Image.open(file_path)
        img_exif = img._getexif()

        try:
            for k, v in img_exif.items():
                metadata = ExifTags.TAGS.get(k,k)
                if metadata == "GPSInfo":
                    for t in v:
                        metadata = ExifTags.GPSTAGS.get(t,t)
                        gps_dict[str(metadata)] = str(v[t])
                        # exif_dict[str(metadata)] = str(v[t])
                else:
                    exif_dict[str(metadata)] = str(v)
        except KeyError:
            pass


        for k,v in gps_dict.items():
            exif_dict[k] = v

        img.close()

        # --- hex data response ---
        with open(file_path,"rb") as ib:
            bytedata = ib.read()
        ib.close()


        # --- write metadata to json file ---
        
        json_dict = {}
        # starts as an empty {}
        with open("metadata.json","r") as j:
            json_dict = json.load(j)
        j.close()

        # create a nested dict that appends to itself with the new files metadata
        json_dict["file_"+str(file_no).strip()] = exif_dict

        with open("metadata.json","w") as j:
            json.dump(json_dict, j, indent=4)
        j.close()

        # keep track of file number                
        # file_no = file_no + 1
        # with open("index.txt","w") as i:
        #     i.write(str(file_no))
        # i.close()

        client_socket.send(bytedata)


if __name__ == "__main__":
    _ready()