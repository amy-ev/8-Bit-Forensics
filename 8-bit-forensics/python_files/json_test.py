import json

data = [
['14', '4f', 'a6', '4f', '71', '6c', '76', '14', '5f', '95', '14', '8c', 'b3', '80', '7a', '67'],
['b5', '7a', 'c5', 'a6', 'b1', 'a5', 'ea', '16', '76', 'cf', '66', 'b7', '62', 'e2', 'e0', 'ee'],
['28', 'c9', 'f7', '07', 'd6', 'be', '6c', '81', '3c', 'c5', '2f', 'b0', '95', '03', '70', '27'],
['b6', '2b', 'd0', '7c', '34', 'd1', 'c5', '6f', '72', '63', '9b', 'cc', '5b', 'c4', '03', '29'],
['fc', '00', 'f3', '5e', '46', '67', '27', 'cb', '64', '65', '19', 'ab', 'e8', '7f', 'ff', 'd9']
]

result_json = {
    "rows":[
        {f'column_{i}': row[i] for i in range(len(row))}
        for row in data
    ]
}

with open("test.json", "w")as f:
    json.dump(result_json,f)

with open("test.json", "r") as f:
    read = json.load(f)


def search(x,y):
    row_data = read["rows"][x]
    value = row_data[f'column_{y}']
    return value

# select from value to value - but difficult with multiple of same value
def select(start_val,end_val):

    row_data = read["rows"]
    reconstructed = [
        [row[f'column_{i}'] for i in range(len(row))]
        for row in row_data
    ]

    flat = [value for row in reconstructed for value in row]
    start = flat.index(start_val)
    end = flat.index(end_val)
    
    if start > end:
        start, end = end, start

    return flat[start:end+1]

# select from start to end indexes
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

# find the x,y coordinate of the value
def value_pos(val):
    row_data = read["rows"]
    reconstructed = [
        [row[f'column_{i}'] for i in range(len(row))]
        for row in row_data
    ]
    pos = None

    for x, row in enumerate(reconstructed):
        for y, value in enumerate(row):
            if value == val and pos is None:
                pos = (x, y)
    return pos

print(select('6c','b5'))
print(value_pos('6c'))


# more likely to be of use
print(select_idx(0,5,1,0))
print(search(0,5))