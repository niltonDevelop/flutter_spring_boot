/// Fuente de datos local de autenticación (token seguro).
abstract interface class AuthLocalDataSource {
  Future<String?> readAccessToken();

  Future<void> writeAccessToken(String token);

  Future<void> clearSession();

  Future<bool> hasSession();
}
