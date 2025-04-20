import socket
import struct

def _ready():
    host = '127.0.0.1'
    port = 8000
    with open('example.jpg','rb') as img_f:
        img_data = img_f.read()

    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((host,port))

    client.sendall(struct.pack('!I', len(img_data))) # big-endian, unsigned int (converts the length into a 4-byte binary rep to send)
    client.sendall(img_data) # send img
    print(f"sent image, length = {len(img_data)} bytes")


    # --- REPONSE FROM SERVER ---
    
    b_size = client.recv(4)
    # if not raw_len:
    #     print("No response.")
    #     return
    response_len = struct.unpack('!I', b_size)[0]

    response_data = b''
    while len(response_data) < response_len:
        data = client.recv(4096)
        if not data:
            break
        response_data += data
    response_str = response_data.decode('utf-8')
    print("recieved hex")
    with open("response.txt", "w") as fo:
        fo.write(response_str)
    print("response saved to txt file")

    client.close()

if __name__ == "__main__":
    _ready()
