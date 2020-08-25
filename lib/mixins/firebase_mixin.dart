import 'package:firebase_core/firebase_core.dart';

/// https://firebase.flutter.dev/docs/overview
class FirebaseMixin {
	FirebaseApp firebaseApp;

	Future<FirebaseApp> initializarFirebase() async {
		firebaseApp = await Firebase.initializeApp();
		return firebaseApp;
	}
}