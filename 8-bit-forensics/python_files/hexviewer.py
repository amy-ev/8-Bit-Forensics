from PIL import Image
from binascii import hexlify

import json

with open ("8-bit-forensics\python_files\photo0.jpg", "rb") as image:
    b = image.read()
    #b = bytearray(f)

hex_arr = [f"{byte:02x}" for byte in b]

def to_2d_arr(hex_arr,columns):
    return [hex_arr[i:i + columns] for i in range(0, len(hex_arr),columns)]

columns = 16
hex_2d = to_2d_arr(hex_arr,columns)

result_json = {
    "rows":[
        {f'column_{i}': row[i] for i in range(len(row))}
        for row in hex_2d
    ]
}

with open("test.json", "w")as f:
    json.dump(result_json,f)

with open("test.json", "r") as f:
    read = json.load(f)

def select_idx(x1,y1,x2,y2):

    row_data = read["rows"]
    reconstructed = [
        [row[f'column_{i}'] for i in range(len(row))]
        for row in row_data
    ]

    num_cols = len(reconstructed[0])
    flat = [value for row in reconstructed for value in row]

    start = x1 * num_cols + y1
    end = x2 * num_cols + y2
    
    if start > end:
        start, end = end, start

    return flat[start:end+1]

print(select_idx(15,7,18,1))