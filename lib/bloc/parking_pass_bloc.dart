import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/model/parking_pass_monthly_model.dart';
import 'package:pos_parking/repository/parking_pass_repo.dart';

class ParkingPassEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetParkingPassMonthly extends ParkingPassEvent {
  final _token;

  GetParkingPassMonthly(this._token);

  @override
  List<Object> get props => [_token];
}

class ParkingPassState extends Equatable {
  @override
  List<Object> get props => [];
}

class ParkingPassLoading extends ParkingPassState {}

// ignore: must_be_immutable
class ParkingPassLoaded extends ParkingPassState {
  final _data;

  ParkingPassLoaded(this._data);

  ParkingPassMonthly get getParkingPass => _data;

  @override
  List<Object> get props => [_data];
}

class ParkingPassFailed extends ParkingPassState {
  final _message;

  ParkingPassFailed(this._message);

  String get errorMsg => _message;

  @override
  List<Object> get props => [_message];
}

class ParkingPassBloc extends Bloc<ParkingPassEvent, ParkingPassState> {
  ParkingPassRepository parkingPassRepo;

  ParkingPassBloc(this.parkingPassRepo) : super(null);

  ParkingPassState get initialState => ParkingPassLoading();

  @override
  Stream<ParkingPassState> mapEventToState(ParkingPassEvent event) async* {
    if (event is GetParkingPassMonthly) {
      yield ParkingPassLoading();

      try {
        ParkingPassMonthly pass =
            await parkingPassRepo.getParkingPass(event._token);
        print(pass);
        yield ParkingPassLoaded(pass);
      } catch (e) {
        print("error catch");
        yield ParkingPassFailed(e.toString());
      }
    }
  }
}
