import socket

def run_client():

    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server_ip = "127.0.0.1"
    server_port = 8000

    client.bind((server_ip, server_port))
    client.listen(0)

    server_socket, server_address = client.accept() 

    while True:
        file_name = "example.jpg"
        try:
            f_input = open(file_name, "rb")
            data = f_input.read(1024)
            if not data:
                break
            while data:
                client.send(data)
                data = f_input.read(1024)

            f_input.close()
            #print(client.recv(1024).decode("latin-1"))
            print("data sent")
            response = server_socket.recv(1024)
            print(response)
            break
        except IOError:
            print("omfg")
    # response = client.recv(1024)
    # response = response.decode("utf-8")
    # print(response)

    client.close()
    #print(response)
run_client()