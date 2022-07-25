import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localstorage/localstorage.dart';

/// https://firebase.flutter.dev/docs/storage/overview
abstract class FirebaseStorageMixin {

	FirebaseStorage? _storage;
	FirebaseStorage? get storage => _storage;

	Reference? _storageRef;
	Reference? get storageRef => _storageRef;

	LocalStorage? _localStorage;

	initializeStorage() async {

		final auth = FirebaseAuth.instance;
		final options = auth.app.options;
		final storageBucket = ((options.storageBucket?.startsWith('gs://') ?? false) ? '' : 'gs://') + options.storageBucket!;
		_storage = FirebaseStorage.instanceFor(app: auth.app, bucket: storageBucket);
		_storageRef = _storage!.ref();

	}

	Future<bool> initializeCache({ String? fileName }) {

		_localStorage = LocalStorage('cache_${(fileName?.isEmpty ?? true ? runtimeType.toString() : fileName)}.json', null, {});
		return _localStorage!.ready;

	}

	Future<String?> getPublicUrl(String filePath) async {

		String? publicUrl;

		if (_localStorage != null) {
			await _localStorage!.ready;
			publicUrl = _localStorage!.getItem(filePath);
		}

		publicUrl ??= await _storageRef!.child(filePath).getDownloadURL();

		if (_localStorage != null) {
			_localStorage!.setItem(filePath, publicUrl);
		}

		return publicUrl;

	}

}