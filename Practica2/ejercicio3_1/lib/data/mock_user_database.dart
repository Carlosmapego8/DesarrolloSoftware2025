class MockUserDatabase {
  static final List<String> registeredEmails = [
    'usuario@ejemplo.com',
    'admin@empresa.com',
    'correo@prueba.org',
    'cliente@tienda.com',
  ];

  static bool emailExists(String email) {
    return registeredEmails.contains(email.trim().toLowerCase());
  }
}
