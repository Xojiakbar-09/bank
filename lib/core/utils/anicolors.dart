class AnsiColor {
  // Reset
  static const String reset = '\x1B[0m';

  // Foreground Colors
  static const String green = '\x1B[32m';
  static const String red = '\x1B[31m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String cyan = '\x1B[36m';
  static const String magenta = '\x1B[35m';

  // Convenience wrapper functions
  static void success(String message) => print('$green[SUCCESS] $message$reset');
  static void error(String message) => print('$red[ERROR] $message$reset');
  static void warning(String message) => print('$yellow[WARNING] $message$reset');
  static void info(String message) => print('$cyan[INFO] $message$reset');
}

void main() {
  // Using the helper functions
  AnsiColor.success('Build completed successfully!');
  AnsiColor.info('Fetching dependencies...');
  AnsiColor.warning('Deprecated API usage detected.');
  AnsiColor.error('Failed to connect to database.');

  // Or using colors inline
  print('${AnsiColor.magenta}Custom colorful text${AnsiColor.reset} can also be done inline.');
}