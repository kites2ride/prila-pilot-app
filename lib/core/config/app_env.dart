class AppEnv {
  const AppEnv._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api/v1',
  );

  static const socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:4000',
  );

  static const appKind = String.fromEnvironment(
    'APP_KIND',
    defaultValue: 'pilot',
  );
}
