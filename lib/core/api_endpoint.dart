abstract final class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://usp.bunli-it.site/api/v1',
  );

  static const String loginPath = '/auth/login';
  static const String registerPath = '/auth/register';
  static const String mePath = '/auth/me';
  static const String logoutPath = '/auth/logout';
  static const String profilePath = '/profile';
  static const String provincesPath = '/addresses/provinces';

  static String districtsPath(int provinceId) =>
      '/addresses/provinces/$provinceId/districts';

  static String communesPath(int districtId) =>
      '/addresses/districts/$districtId/communes';

  static String villagesPath(int communeId) =>
      '/addresses/communes/$communeId/villages';

  static Uri uri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$normalizedBaseUrl$normalizedPath');
  }
}
