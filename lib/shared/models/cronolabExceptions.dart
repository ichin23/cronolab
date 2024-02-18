class CronolabException implements Exception {
  String message;
  int? code;
  Object? data;
  CronolabException(this.message, [this.code, this.data]);

  @override
  String toString() {
    String result = 'IMoviesRepoExceptionl';
    return message;
  }
}
