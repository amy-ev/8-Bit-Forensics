import json

data = [
['14', '4f', 'a6', '4f', '71', '6c', '76', '14', '5f', '95', '14', '8c', 'b3', '80', '7a', '67'],
['b5', '7a', 'c5', 'a6', 'b1', 'a5', 'ea', '16', '76', 'cf', '66', 'b7', '62', 'e2', 'e0', 'ee'],
['28', 'c9', 'f7', '07', 'd6', 'be', '6c', '81', '3c', 'c5', '2f', 'b0', '95', '03', '70', '27'],
['b6', '2b', 'd0', '7c', '34', 'd1', 'c5', '6f', '72', '63', '9b', 'cc', '5b', 'c4', '03', '29'],
['fc', '00', 'f3', '5e', '46', '67', '27', 'cb', '64', '65', '19', 'ab', 'e8', '7f', 'ff', 'd9']
]

col_num = len(data[0])

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

print(search(2,6))