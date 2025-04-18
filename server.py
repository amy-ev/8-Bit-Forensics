import socket


def run_server():

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_ip = "127.0.0.1" #localhost
    port = 8000 # above 1023 to avoid collisions

    server.bind((server_ip, port)) # preparing the socket to recieve connects

    server.listen(0) # means only a single client can interact with the server
    print(f"listening on {server_ip}:{port}")

    # creates a new socket object that shares a connection with the client
    client_socket, client_address = server.accept() 

    # create files
    jpeg_file = open('sent.jpeg','wb')
    hex_text = open('hex.txt','w')

    while True:
        request = client_socket.recv(1024)
        # send the image
        jpeg_file.write(request)

        request = request.hex()
        #represent in hex
        hex_text.write(request)

        #if 'close' recieved then break out of the loop
        if request.lower() == "close": 
            #respond to client that connect will be closed and loop broken out of
            client_socket.send("closed".encode("utf-8"))
            break
        print(f"recieved: {request}")

        # normal response of server to the client
        response = "accepted".encode("utf-8")
        client_socket.send(response)

    #closing client socket and server socket
    client_socket.close()

    jpeg_file.close()
    hex_text.close()

    print("connection to client closed")
    server.close()


run_server()


    