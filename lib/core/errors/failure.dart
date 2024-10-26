import 'package:equatable/equatable.dart';
import 'package:project1/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  String get errorMessage => '$statusCode Error: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});
  ApiFailure.fromApiException(ApiException apiException)
      : this(
            message: apiException.message, statusCode: apiException.statusCode);
}
