// enum AuthenticationState { initial, loading, authenticated, unauthenticated, error }
abstract class AuthenticationState{

}

class AuthInitialState extends AuthenticationState {}

class AuthLaodingState extends AuthenticationState {}

class AuthAuthenticatedState extends AuthenticationState {}

class AuthErrorState extends AuthenticationState {}
