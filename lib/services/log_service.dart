import 'package:logger/logger.dart';
import 'dio_service.dart';

class Log {
  static final Logger _logger = Logger(printer: PrettyPrinter());

  static void d(String message) {
    if (Network.isTester) _logger.d(message);
  }

  static void i(String message) {
    if (Network.isTester) _logger.i(message);
  }

  static void w(String message) {
    if (Network.isTester) _logger.w(message);
  }

  static void e(String message) {
    if (Network.isTester) _logger.e(message);
  }
}