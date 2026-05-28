import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String tempoDecorrido(DateTime date) {
    final diferenca = DateTime.now().difference(date);

    if (diferenca.inMinutes < 1) {
      return 'agora mesmo';
    }

    if (diferenca.inHours < 1) {
      return 'há ${diferenca.inMinutes} min';
    }

    if (diferenca.inDays < 1) {
      return 'há ${diferenca.inHours}h';
    }

    return 'há ${diferenca.inDays} dias';
  }
}