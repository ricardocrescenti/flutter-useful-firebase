# Useful Firebase (Developing)

This package was developed to facilitate the use of [Firebase](https://firebase.google.com/) resources using [FlutterFire](https://firebase.flutter.dev/) packages, simplifying basic operations and avoiding duplication of code between your applications / packages.

- **[Introduction](#introduction)**
- **[How to Install](#how-to-install)**
- **[Firebase](#firebase)**
- **[Authentication](#authentication)**
- **[Firestore](#firestore)**
- **[Messaging](#messaging)**
- **[Storage](#storage)**

## Introduction

This package is dependent on [FlutterFire](https://firebase.flutter.dev/) packages, and was developed to automate several basic operations, avoiding duplication of code between your applications / packages.

To implement any feature of this package, you must first implement the [FirebaseMixin](#firebase) class , see the documentation below.

## How to install

Add the dependency on `pubspec.yaml`. 

*Informing `^` at the beginning of the version, you will receive all updates that are made from version `1.0.0` up to the version before `2.0.0`.*

```yaml
dependencies:
  useful_firebase: ^1.0.0
```

Import the package in the source code.

```dart
import 'package:useful_firebase/useful_firebase.dart';
```

## Firebase