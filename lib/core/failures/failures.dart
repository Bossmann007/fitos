// lib/core/failures/failures.dart

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class HiveFailure extends Failure {
  const HiveFailure(super.message);
}

class ExportFailure extends Failure {
  const ExportFailure(super.message);
}
