import socket
import tkinter as tk
from tkinter import messagebox, scrolledtext
import time

# Adapter para convertir millas a kilómetros
class DistanceAdapter:
    @staticmethod
    def miles_to_km(miles):
        return miles * 1.60934

# Servidor en Los Ángeles que envía distancias en millas
def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(("localhost", 9999))
    server.listen(1)
    print("Servidor esperando conexiones...")
    
    conn, addr = server.accept()
    print(f"Conexión establecida con {addr}")
    
    distances = [5, 15, 30.41, 60, 120, 32, 1000, 63.12]  # Distancias en millas
    for d in distances:
        conn.sendall(str(d).encode())
        response = conn.recv(1024).decode()
        print(f"Cliente recibió y convirtió: {response} km")
    
    conn.close()
    server.close()

# Cliente en España que recibe millas, convierte y muestra en Tkinter
def start_client():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect(("localhost", 9999))
    
    root = tk.Tk()
    root.title("Conversión de Distancias")
    root.geometry("400x300")
    root.resizable(False, False)
    
    frame = tk.Frame(root, padx=10, pady=10)
    frame.pack(fill=tk.BOTH, expand=True)
    
    label = tk.Label(frame, text="Distancias recibidas y convertidas:", font=("Arial", 12, "bold"))
    label.pack(pady=5)
    
    text_area = scrolledtext.ScrolledText(frame, height=10, width=45, wrap=tk.WORD)
    text_area.pack()
    
    status_label = tk.Label(frame, text="Esperando datos...", font=("Arial", 10), fg="blue")
    status_label.pack(pady=5)
    
    while True:
        data = client.recv(1024)
        if not data:
            break
        miles = float(data.decode())
        km = DistanceAdapter.miles_to_km(miles)
        response = f"{miles} mi -> {km:.2f} km\n"
        text_area.insert(tk.END, response)
        text_area.see(tk.END)
        status_label.config(text=f"Última conversión: {miles} mi -> {km:.2f} km")
        client.sendall(str(km).encode())
        root.update()
        time.sleep(2)  # Espera 2 segundos antes de la siguiente conversión
    
    client.close()
    root.mainloop()

if __name__ == "__main__":
    from threading import Thread
    
    server_thread = Thread(target=start_server, daemon=True)
    client_thread = Thread(target=start_client)
    
    server_thread.start()
    client_thread.start()
    
    client_thread.join()
