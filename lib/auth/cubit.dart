import 'package:attendance_verification_appdemo/auth/states.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationCubit(AuthenticationState InitialState) : super(AuthInitialState());

  static AuthenticationCubit get(context) => BlocProvider.of(context);

  Future<void> authenticateWithBarcode(String barcode) async {
    emit(AuthenticationState.loading); // Emit a loading state

    try {
      User user = await _authenticateWithBarcode(barcode);
      if (user != null) {
        emit(AuthenticationState.authenticated);
      } else {
        emit(AuthenticationState.unauthenticated);
      }
    } catch (e) {
      emit(AuthenticationState.error); // Emit an error state
      print('Authentication error: $e');
    }
  }

  Future<User?> _authenticateWithBarcode(String barcode) async {
    try {
      // Implement your authentication logic here, e.g., Firebase sign-in
      // Use Firebase's authentication methods, such as signInWithCredential
      // For example:
      // AuthResult result = await _auth.signInWithCredential(credential);
      // FirebaseUser user = result.user;

      // Replace the above lines with your actual authentication logic

      return null; // Return the authenticated Firebase user or null
    } catch (e) {
      throw e;
    }
  }
}
