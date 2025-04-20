import socket

def run_client():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    server_ip = "127.0.0.1"
    server_port = 8000

    client.connect((server_ip, server_port))
    
    msg = open('example.jpg', 'rb')
    jpeg_packet = msg.read(1024)

    while (jpeg_packet):

        client.send(jpeg_packet)
        jpeg_packet = msg.read(1024)

        response = client.recv(1024)
        response = response.decode("utf-8")

        if response.lower() == "closed":
            break

        print(f"Recieved: {response}")

    #client.shutdown(socket.SHUT_WR)
    client.close()
    print("connection to server closed")

run_client()