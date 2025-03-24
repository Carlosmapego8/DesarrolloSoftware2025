import socket
from distance_adapter import DistanceInMiles, DistanceAdapter

def start_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('localhost', 65432))
    server_socket.listen(5)
    print("Servidor esperando conexiones...")

    conn, addr = server_socket.accept()
    print(f"Conexión establecida con {addr}")

    data = conn.recv(1024).decode()
    if data:
        try:
            miles = float(data)
            distance_in_miles = DistanceInMiles(miles)
            adapter = DistanceAdapter(distance_in_miles)
            result = adapter.get_distance()
            conn.sendall(f"{distance_in_miles.get_distance()} millas son {result:.2f} kilómetros".encode())
        except ValueError:
            conn.sendall("Error: valor inválido".encode())

    conn.close()

if __name__ == "__main__":
    
    start_server()
    print("Cerrando servidor...")
    