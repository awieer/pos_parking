import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_parking/model/coupon_pass_model.dart';
import 'package:pos_parking/repository/coupon_repo.dart';

class CuoponPassEvent extends Equatable {
  @override
  List<Object> get props => throw [];
}

class GetCoupons extends CuoponPassEvent {
  final _token;

  GetCoupons(this._token);

  @override
  List<Object> get props => [_token];
}

class CouponState extends Equatable {
  @override
  List<Object> get props => throw [];
}

class CouponLoaded extends CouponState {
  final _data;

  CouponLoaded(this._data);

  CouponModel get getCouponPass => _data;

  @override
  List<Object> get props => [_data];
}

class CouponLoading extends CouponState {}

class CouponFailed extends CouponState {
  final _message;

  CouponFailed(this._message);

  String get errorMsg => _message;

  @override
  List<Object> get props => [_message];
}

class CouponBloc extends Bloc<CuoponPassEvent, CouponState> {
  CouponPassRepository couponRepo;

  CouponBloc(this.couponRepo) : super(null);

  CouponState get initialState => CouponLoading();

  @override
  Stream<CouponState> mapEventToState(CuoponPassEvent event) async* {
    if (event is GetCoupons) {
      yield CouponLoading();

      try {
        CouponModel coupons = await couponRepo.getParkingPass(event._token);
        print(coupons);
        yield CouponLoaded(coupons);
      } catch (e) {
        print("error catch");
        yield CouponFailed(e.toString());
      }
    }
  }
}
