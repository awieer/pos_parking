import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/model/pay_parkir_response.dart';
import 'package:pos_parking/repository/parkir_repo.dart';

class ParkirEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PayParkir extends ParkirEvent {
  final _noPlate;
  final _token;
  final _parkingPass;

  PayParkir(this._noPlate, this._token, this._parkingPass);

  @override
  List<Object> get props => [_noPlate, _token, _parkingPass];
}

//State or Method
class ParkirState extends Equatable {
  @override
  List<Object> get props => [];
}

class ParkirIsInit extends ParkirState {}

class ParkirIsLoading extends ParkirState {}

class ParkirIsSuccess extends ParkirState {
  final parkir;

  ParkirIsSuccess(this.parkir);

  PayParkirResponse get getResponse => parkir;

  @override
  List<Object> get props => [];
}

class ParkirIsNotSuccess extends ParkirState {}

//Bloc
class ParkirBloc extends Bloc<ParkirEvent, ParkirState> {
  ParkirRepo parkirRepo;

  ParkirBloc(this.parkirRepo) : super(null);

  @override
  ParkirState get initialState => ParkirIsInit();

  @override
  Stream<ParkirState> mapEventToState(ParkirEvent event) async* {
    if (event is PayParkir) {
      yield ParkirIsLoading();

      try {
        PayParkirResponse parkir = await parkirRepo.addPlate(
            event._noPlate, event._token, event._parkingPass);
        yield ParkirIsSuccess(parkir);
      } catch (_) {
        print("error catch");
        yield ParkirIsNotSuccess();
      }
    }
  }
}
