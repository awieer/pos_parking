import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/model/kompaun_pelbagai_response_model.dart';
import 'package:pos_parking/model/kompaun_response_model.dart';
import 'package:pos_parking/repository/kompaun_repo.dart';

class KompaunEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FindKompaun extends KompaunEvent {
  final _noPlate;
  final _token;

  FindKompaun(this._noPlate, this._token);

  @override
  List<Object> get props => [_noPlate, _token];
}

class FindPelbagai extends KompaunEvent {
  final _data;
  final _token;

  FindPelbagai(this._data, this._token);

  @override
  List<Object> get props => [_data, _token];
}

//State or Method
class KompaunState extends Equatable {
  @override
  List<Object> get props => [];
}

class KompaunIsInit extends KompaunState {}

class KompaunIsLoading extends KompaunState {}

class KompaunIsSuccess extends KompaunState {
  final _kompaun;

  KompaunIsSuccess(this._kompaun);

  KompaunResponse get getKompaun => _kompaun;
  @override
  List<Object> get props => [_kompaun];
}

class KompaunPelbagaiIsSuccess extends KompaunState {
  final _kompaun;

  KompaunPelbagaiIsSuccess(this._kompaun);

  KompaunPelbagaiResponse get getKompaun => _kompaun;
  @override
  List<Object> get props => [_kompaun];
}

class KompaunIsNotSuccess extends KompaunState {}

//Bloc
class KompaunBloc extends Bloc<KompaunEvent, KompaunState> {
  KompaunRepository kompaunRepo;

  KompaunBloc(this.kompaunRepo) : super(null);

  @override
  KompaunState get initialState => KompaunIsInit();

  @override
  Stream<KompaunState> mapEventToState(KompaunEvent event) async* {
    if (event is FindKompaun) {
      yield KompaunIsLoading();

      try {
        KompaunResponse kompauns =
            await kompaunRepo.findKompaunList(event._noPlate, event._token);
        print(kompauns);
        yield KompaunIsSuccess(kompauns);
      } catch (_) {
        print("error catch");
        yield KompaunIsNotSuccess();
      }
    } else if (event is FindPelbagai) {
      yield KompaunIsLoading();
      try {
        KompaunPelbagaiResponse kompauns = await kompaunRepo
            .findKompaunPelbagaiList(event._data, event._token);
        print(kompauns);
        yield KompaunPelbagaiIsSuccess(kompauns);
      } catch (e) {
        print(e.toString());
        yield KompaunIsNotSuccess();
      }
    }
  }
}
