import socket

def run_client():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server_ip = "127.0.0.1"
    server_port = 8000

    client.connect((server_ip, server_port))
    
    while True:
        file_name = input('input filename: ')
        try:
            f_input = open(file_name, 'rb') 
            data = f_input.read(1024) 
            if not data:
                break
            while data:
                client.send(data)
                data = f_input.read(1024)
            f_input.close()
            break


        except IOError:
            print("invalid filename!\
                  Please enter a valid name")
    #client.shutdown(socket.SHUT_WR)
    client.close()
run_client()