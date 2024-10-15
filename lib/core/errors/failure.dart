import 'package:equatable/equatable.dart';
import 'package:project1/core/errors/exceptions.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;
  const Failure({required this.message, required this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, required super.statusCode});
  ApiFailure.fromApiException(ApiException apiException)
      : this(
            message: apiException.message, statusCode: apiException.statusCode);
}
