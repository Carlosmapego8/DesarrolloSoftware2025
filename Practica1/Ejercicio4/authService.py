import getpass

###########################################################################################
## 1. Clase base de Filtros
###########################################################################################

class Filter:
    def execute(self, request):
        pass

###########################################################################################
## 2. Lista de Filtros
###########################################################################################

class EmailFilter(Filter):
    def execute(self, request):
        email = request.get("email", "")
        if "@" not in email or email.startswith("@"):
            raise ValueError("Correo inválido: Debe contener texto antes de '@'.")
        domain = email.split("@")[1]
        if domain not in ["gmail.com", "hotmail.com"]:
            raise ValueError("Correo inválido: El dominio debe ser gmail.com o hotmail.com.")

class PasswordLengthFilter(Filter):
    def execute(self, request):
        password = request.get("password", "")
        if len(password) < 8:
            raise ValueError("Contraseña inválida: Debe tener al menos 8 caracteres.")

class PasswordUppercaseFilter(Filter):
    def execute(self, request):
        password = request.get("password", "")
        if not any(char.isupper() for char in password):
            raise ValueError("Contraseña inválida: Debe contener al menos una letra mayúscula.")

class PasswordSpecialCharFilter(Filter):
    def execute(self, request):
        special_chars = "!@#$%^&*()-_+=<>?/"
        password = request.get("password", "")
        if not any(char in special_chars for char in password):
            raise ValueError("Contraseña inválida: Debe contener al menos un carácter especial.")

###########################################################################################
## 3. Clase Objetivo
###########################################################################################

class AuthenticationTarget:
    def execute(self, request):
        print("Autenticación exitosa!")

###########################################################################################
## 4. Cadena de Filtros
###########################################################################################

class FilterChain:
    def __init__(self, target):
        self.filters = []
        self.target = target  # El objetivo final

    def add_filter(self, filter_):
        self.filters.append(filter_)

    def execute(self, request):
        for filter_ in self.filters:
            filter_.execute(request)
        self.target.execute(request)  # Llamamos al objetivo

###########################################################################################
## 5. Gestor de filtros
###########################################################################################

class FilterManager:
    def __init__(self, target):
        self.filter_chain = FilterChain(target)

    def add_filter(self, filter_):
        self.filter_chain.add_filter(filter_)

    def execute(self, request):
        self.filter_chain.execute(request)

###########################################################################################
## 6. Clase Cliente
###########################################################################################

class AuthenticationService:
    def __init__(self, filter_manager):
        self.filter_manager = filter_manager

    def authenticate(self, email, password):
        request = {"email": email, "password": password}
        self.filter_manager.execute(request)

###########################################################################################
## Main
###########################################################################################

if __name__ == "__main__":
    email = input("Introduzca su correo: ")
    # password = getpass.getpass("Introduzca su contraseña: ")
    password = input("Introduzca su contraseña: ")

    target = AuthenticationTarget()
    filter_manager = FilterManager(target)
    filter_manager.add_filter(EmailFilter())
    filter_manager.add_filter(PasswordLengthFilter())
    filter_manager.add_filter(PasswordUppercaseFilter())
    filter_manager.add_filter(PasswordSpecialCharFilter())

    auth_service = AuthenticationService(filter_manager)

    try:
        auth_service.authenticate(email, password)
    except ValueError as e:
        print(f"Error: {e}")
