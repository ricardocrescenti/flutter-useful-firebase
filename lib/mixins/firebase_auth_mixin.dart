import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:standard_dialogs/standard_dialogs.dart';
import 'package:useful_firebase/useful_firebase.dart';

/// https://firebase.flutter.dev/docs/auth/overview
mixin FirebaseAuthMixin {

	User _lastLoggedInUser;

	/// 
	bool automaticDeleteAnonymousUser = true;
	
	///
	final FirebaseAuth auth = FirebaseAuth.instance;
	
	/// https://firebase.flutter.dev/docs/auth/social#google
	/// google_sign_in: ^4.5.1
	/// import 'package:google_sign_in/google_sign_in.dart';
	/// googleSignIn = GoogleSignIn();
	dynamic googleSignIn;
	/// https://firebase.flutter.dev/docs/auth/social#facebook
	/// flutter_facebook_auth: ^0.2.3
	/// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
	/// facebookLogin = FacebookAuth.instance
	dynamic facebookSignIn;
	/// https://firebase.flutter.dev/docs/auth/social#apple
	/// apple_sign_in: ^0.1.0
	/// import 'package:apple_sign_in/apple_sign_in.dart';
	/// appleLogin = AppleSignIn();
	dynamic appleSignIn;

	///
	Future<UserCredential> _processSignIn(BuildContext context, Future<UserCredential> Function() futureSignIn) async {
		bool anonymousUserHasBeenDeleted = false;
		try {

			if (automaticDeleteAnonymousUser && (auth.currentUser?.isAnonymous ?? false)) {
				anonymousUserHasBeenDeleted = true;
				auth.currentUser.delete();
			}

			UserCredential userCredential = await futureSignIn();
			_lastLoggedInUser = userCredential.user;

			return userCredential;
			
		} catch (error) {
			if (anonymousUserHasBeenDeleted) {
				await _signInAnonimous(context);
			}
			rethrow;
		}
	}

	/// 
	Future<User> _signInAnonimous(BuildContext context) async {
		try {

			UserCredential userCredential = await _processSignIn(context, () => auth.signInAnonymously());
			User user = userCredential?.user;
			
			if (user != null) {
				await onLoginRetriveUser(context, _lastLoggedInUser, user);
				return user;
			}

		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
		return null;
	}

	/// 
	Future<User> signInAnonimous(BuildContext context) async {
		return _signInAnonimous(context).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> signInAnonimousDialog(BuildContext context) async {
		return await _showLoginDialog(context, UsefulFirebaseStringsEnum.loggingInWithGoogle, _signInAnonimous(context)).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> _signInWithEmailAndPassword(BuildContext context, String email, String password) async {
		try {

			_checkEmailInformed(context, email);
			_checkPasswordInformed(context, password);

			UserCredential userCredential = await _processSignIn(context, () => auth.signInWithEmailAndPassword(
				email: email, 
				password: password));
			User user = userCredential?.user;

			if (user != null) {
				await onLoginRetriveUser(context, _lastLoggedInUser, user);
				return user;
			}

		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
		return null;
	}

	/// 
	Future<User> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
		return _signInWithEmailAndPassword(context, email, password).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> signInWithEmailAndPasswordDialog(BuildContext context, String email, String password) async {
		_checkEmailInformed(context, email);
		_checkPasswordInformed(context, password);

		return await _showLoginDialog(context, UsefulFirebaseStringsEnum.loggingInWithGoogle, _signInWithEmailAndPassword(context, email, password)).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> _signInWithGoogle(BuildContext context) async {
		try {
		
			if (googleSignIn == null) {
				throw Exception('Login with Google is not configured. Override the getGoogleSignIn method in AuthService.');
			}

			final googleAccount = await googleSignIn.signIn();
			if (googleAccount != null) {
				final googleAuthentication = await googleAccount.authentication;

				AuthCredential authCredential = GoogleAuthProvider.credential(
					accessToken: googleAuthentication.accessToken,
					idToken: googleAuthentication.idToken,
				);

				if (authCredential != null) {

					UserCredential userCredential = await _processSignIn(context, () => auth.signInWithCredential(authCredential));
					User user = userCredential?.user;

					if (user != null) {
						await onLoginRetriveUser(context, _lastLoggedInUser, user);
						return user;
					}

				}
			}

		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
		return null;
	}

	/// 
	Future<User> signInWithGoogle(BuildContext context) async {
		return _signInWithGoogle(context).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> signInWithGoogleDialog(BuildContext context) async {
		return await _showLoginDialog(context, UsefulFirebaseStringsEnum.loggingInWithGoogle, _signInWithGoogle(context)).then((user) => _onLoginComplete(context, user));
	}

	/// 
	Future<User> _signInWithFacebook(BuildContext context) async {
		try {

			final result = await facebookSignIn.login();
			if (result.status == 200) {

				final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
				
				UserCredential userCredential = await _processSignIn(context, () => auth.signInWithCredential(credential));
				User user = userCredential?.user;
				
				if (user != null) {
					await onLoginRetriveUser(context, _lastLoggedInUser, user);
					return user;
				}

			}

		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
		return null;
	}

	/// 
	Future<User> signInWithFacebook(BuildContext context) async {
		User user = await _signInWithFacebook(context).then((user) => _onLoginComplete(context, user));
		return _onLoginComplete(context, user);
	}

	/// 
	Future<User> signInWithFacebookDialog(BuildContext context) async {
		User user = await _showLoginDialog(context, UsefulFirebaseStringsEnum.loggingInWithFacebook, _signInWithFacebook(context));
		return await _onLoginComplete(context, user);
	}

	/// 
	@mustCallSuper
	Future<void> onLoginRetriveUser(BuildContext context, User previousUser, User user) async {}

	///
	Future<User> _onLoginComplete(BuildContext context, User user) async {
		if (user != null) {
			await onLoginComplete(context, user);
		}
		return user;
	}

	/// 
	Future<void> onLoginComplete(BuildContext context, User user) async {
		return true;
	}

	/// 
	Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
		try {

			_checkEmailInformed(context, email);

			return auth.sendPasswordResetEmail(email: email);

		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
	}

	/// 
	Future<void> sendPasswordResetEmailDialog(BuildContext context, String email) async {
		_checkEmailInformed(context, email);

		return await showAwaitDialog<void>(context, message: Text(UsefulFirebaseLocalizations.of(context)[UsefulFirebaseStringsEnum.sendingRecoverPassword]), function: (context, updateMessage) async {
			await sendPasswordResetEmail(context, email);		
		});
	}

	/// 
	Future<User> _signOut(BuildContext context) async {
		User user = auth.currentUser;

		if (user == null) {
			return null;
		}

		try {
			
			await auth.signOut();
			await onSignOut(context, user);
			return user;
		
		} catch (error) {
			if (!await processFirebaseAuthErrors(context, error)) {
				rethrow;
			}
		}
		return null;
	}

	/// 
	Future<User> signOut(BuildContext context) async {
		User user = auth.currentUser;
		if (user == null) {
			return null;
		}

		user = await _signOut(context).then((user) => _onSignOutComplete(context, user));
		return _onSignOutComplete(context, user);
	}

	/// 
	Future<User> signOutDialog(BuildContext context) async {
		User user = auth.currentUser;
		if (user == null) {
			return null;
		}

		user = await showAwaitDialog<User>(context, message: Text(UsefulFirebaseLocalizations.of(context)[UsefulFirebaseStringsEnum.loggingOut]), function: (context, updateMessage) async {
			return _signOut(context);
		});
		return _onSignOutComplete(context, user);
	}

	/// 
	@mustCallSuper
	Future<void> onSignOut(BuildContext context, User user) async {
		_lastLoggedInUser = null;
	}

	/// 
	Future<User> _onSignOutComplete(BuildContext context, User user) async {
		if (user != null) {
			await onSignOutComplete(context, user);
		}
		return user;
	}

	///
	Future<void> onSignOutComplete(BuildContext context, User user) async {}

	/// 
	_checkEmailInformed(BuildContext context, String email) {
		if ((email ?? '').isEmpty) {
			throw PlatformException(code: 'NO_EMAIL_INFORMED');
		}
	}
	
	/// 
	_checkPasswordInformed(BuildContext context, String password) {
		if ((password ?? '').isEmpty) {
			throw PlatformException(code: 'NO_PASSWORD_INFORMED');
		}
	}

	/// 
	Future<User> _showLoginDialog(BuildContext context, UsefulFirebaseStringsEnum localizationString, Future<User> login) async {
		return await showAwaitDialog<User>(context, message: Text(UsefulFirebaseLocalizations.of(context)[localizationString]), function: (context, updateMessage) async {
			
			User user = await login;
			return user;
		
		});
	}

	///
	Future<bool> processFirebaseAuthErrors(BuildContext context, dynamic error) async {
		switch (error.code) {
			
			case 'wrong-password':
			case 'ERROR_WRONG_PASSWORD': 
				await showBasicDialog(context, title: Text(UsefulFirebaseLocalizations.of(context)[UsefulFirebaseStringsEnum.wrongPassword]));
				return true;
			break;
			
			case 'NO_EMAIL_INFORMED': 
				await showBasicDialog(context, title: Text(UsefulFirebaseLocalizations.of(context)[UsefulFirebaseStringsEnum.noEmailInformed]));
				return true;
			break;
			
			case 'NO_PASSWORD_INFORMED': 
				await showBasicDialog(context, title: Text(UsefulFirebaseLocalizations.of(context)[UsefulFirebaseStringsEnum.noPasswordInformed]));
				return true;
			break;

		}
		return false;
	}
}