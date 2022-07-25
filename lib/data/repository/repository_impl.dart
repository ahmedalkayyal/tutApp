import 'package:advanced_flutter_arabic/data/data_source/remote_data_source.dart';
import 'package:advanced_flutter_arabic/data/network/error_handler.dart';
import 'package:advanced_flutter_arabic/data/network/failure.dart';
import 'package:advanced_flutter_arabic/data/network/network_info.dart';
import 'package:advanced_flutter_arabic/data/network/request.dart';
import 'package:advanced_flutter_arabic/domain/models.dart';
import 'package:advanced_flutter_arabic/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:advanced_flutter_arabic/data/mapper/mapper.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      //its connected ,safe to call api
      try {
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.SUCCESS) {
          //success
          //return either right
          //return data
          return Right(response.toDomain());
        } else {
          //failure -- business error
          //return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      //return internet connection
      //return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}