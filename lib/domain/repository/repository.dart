import 'package:advanced_flutter_arabic/data/network/request.dart';
import 'package:advanced_flutter_arabic/domain/models.dart';
import 'package:dartz/dartz.dart';

import '../../data/network/failure.dart';

abstract class Repository{
Future<Either<Failure,Authentication>> login(LoginRequest loginRequest);

}