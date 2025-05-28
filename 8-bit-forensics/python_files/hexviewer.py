from PIL import Image
from binascii import hexlify

with open ("python_files\photo0.jpg", "rb") as image:
    b = image.read()
    #b = bytearray(f)

hex_arr = [f"{byte:02x}" for byte in b]

def to_2d_arr(hex_arr,columns):
    return [hex_arr[i:i + columns] for i in range(0, len(hex_arr),columns)]

columns = 16
hex_2d = to_2d_arr(hex_arr,columns)

for row in hex_2d:
    print(row)
