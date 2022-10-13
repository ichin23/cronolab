class CronolabException implements Exception {
  String message;
  int? code;
  CronolabException(this.message, [this.code]);

  @override
  String toString() {
    String result = 'IMoviesRepoExceptionl';
    if (message is String) return message;
    return result;
  }
}
