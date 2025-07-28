from PIL import Image
from binascii import hexlify


#TODO: turn this into another server script 
#   have the search function as a client script that sends the signature
#   this responds with the offsets
#   client handles the printing to screen

def search_hex_pattern(filename, signature, chunk_size=4096):
    signature_bytes = bytes.fromhex(signature)
    signature_len = len(signature_bytes)

    buffer = b""
    offset = 0

    with open(filename, 'rb') as f:
        while True:
            chunk = f.read(chunk_size)
            if not chunk:
                break

            buffer += chunk

            search_pos = 0
            while search_pos <= len(buffer) - signature_len:
                if buffer[search_pos : search_pos + signature_len] == signature_bytes:

                    signature_location = offset + search_pos
                    
                    print(f"offset: {signature_location:08x}") # in hex format
                    print(signature_location) # in dec format
                search_pos += 1

            #since the loop is 'resetting' every 4096 bytes
            offset += len(chunk)
            #incase the signature is found between the cut off
            buffer = buffer[-(signature_len - 1):]

search_hex_pattern('8-bit-forensics/python_files/test-sd.001', 'ffd9')
