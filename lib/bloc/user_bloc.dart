import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pos_parking/model/user_response_model.dart';
import 'package:pos_parking/repository/user_repo.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Authenticate extends LoginEvent {
  final _email;
  final _password;

  Authenticate(this._email, this._password);

  @override
  List<Object> get props => [_email, _password];
}

//State or Method
class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginIsInit extends LoginState {}

class LoginIsLoading extends LoginState {}

class LoginIsSuccess extends LoginState {
  final _user;

  LoginIsSuccess(this._user);

  UserResponse get getUser => _user;
  @override
  List<Object> get props => [_user];
}

class LoginIsNotSuccess extends LoginState {}

//Bloc
class UserBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepo;

  UserBloc(this.userRepo) : super(null);

  @override
  LoginState get initialState => LoginIsInit();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is Authenticate) {
      yield LoginIsLoading();

      try {
        UserResponse user = await userRepo.login(event._email, event._password);
        yield LoginIsSuccess(user);
      } catch (_) {
        yield LoginIsNotSuccess();
      }
    }
  }
}
