
def dec_to_hex(x):
    quo_1 = int(x/16)
    rem_1 = int(x%16)
    result = []
    while x != 0:
        y = x % 16
        x = x // 16
        result.insert(0,str(y))

    result = ["A" if x == "10" else x for x in result]
    result = ["B" if x == "11" else x for x in result]
    result = ["C" if x == "12" else x for x in result]
    result = ["D" if x == "13" else x for x in result]
    result = ["E" if x == "14" else x for x in result]
    result = ["F" if x == "15" else x for x in result]



    return ''.join(result).zfill(7) + "0"

print(dec_to_hex(2890))
