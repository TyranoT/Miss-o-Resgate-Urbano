import 'package:intl/intl.dart';

/// Utilitários de formatação de datas para a UI.
class DateFormatter {
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _dateFormat = DateFormat('dd/MM/yyyy');

  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatDate(DateTime date) => _dateFormat.format(date);

  /// Retorna o tempo decorrido em formato legível (ex: "há 2 horas").
  static String timeElapsed(DateTime from) {
    final difference = DateTime.now().difference(from);

    if (difference.inDays > 0) {
      return 'há ${difference.inDays} ${_pluralize(difference.inDays, 'dia', 'dias')}';
    }
    if (difference.inHours > 0) {
      return 'há ${difference.inHours} ${_pluralize(difference.inHours, 'hora', 'horas')}';
    }
    if (difference.inMinutes > 0) {
      return 'há ${difference.inMinutes} ${_pluralize(difference.inMinutes, 'minuto', 'minutos')}';
    }
    return 'agora mesmo';
  }

  static String _pluralize(int value, String singular, String plural) {
    return value == 1 ? singular : plural;
  }
}
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
