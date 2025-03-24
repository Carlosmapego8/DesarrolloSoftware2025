import socket
import tkinter as tk
from tkinter import messagebox

def send_distance(miles):
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client_socket.connect(('localhost', 65432))
    client_socket.sendall(str(miles).encode())

    response = client_socket.recv(1024).decode()
    messagebox.showinfo("Resultado", response)
    client_socket.close()

def convert_distance():
    try:
        miles = float(entry_miles.get())
        send_distance(miles)
    except ValueError:
        messagebox.showerror("Error", "Por favor, introduce un número válido.")

# Configuración de la interfaz gráfica
root = tk.Tk()
root.title("Conversor de Distancia (Millas a Kilómetros)")

label_miles = tk.Label(root, text="Distancia en millas:")
label_miles.grid(row=0, column=0, padx=10, pady=10)

entry_miles = tk.Entry(root)
entry_miles.grid(row=0, column=1, padx=10, pady=10)

convert_button = tk.Button(root, text="Convertir", command=convert_distance)
convert_button.grid(row=1, column=0, columnspan=2, pady=10)

root.mainloop()
