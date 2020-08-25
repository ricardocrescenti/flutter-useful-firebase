import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:useful_firebase/useful_firebase.dart';
import 'package:simple_localization/simple_localization.dart';

class UsefulFirebaseLocalizations extends SimpleLocalizations {
  static UsefulFirebaseLocalizations of(BuildContext context) {
    UsefulFirebaseLocalizations localization = Localizations.of<UsefulFirebaseLocalizations>(context, UsefulFirebaseLocalizations);
    return localization ?? UsefulFirebaseLocalizations(Localizations.localeOf(context));
  }
  
  UsefulFirebaseLocalizations(Locale locale) : super(locale);

  @override
  Locale get defaultLocale => Locale('en');

  @override
  Iterable<Locale> get suportedLocales => [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  @override
  Map<String, Map<dynamic, String>> get localizedValues => {
    'en': {
			/// login
			UsefulFirebaseStringsEnum.loggingInWithEmailAndPassword: 'Logging in',
			UsefulFirebaseStringsEnum.loggingInWithFacebook: 'Logging in with Facebook',
			UsefulFirebaseStringsEnum.loggingInWithGoogle: 'Logging in with Google',
			UsefulFirebaseStringsEnum.loggingOut: 'Logging out',
			UsefulFirebaseStringsEnum.login: 'Enter your email and password to login',
			UsefulFirebaseStringsEnum.sendingRecoverPassword: 'Sending password recovery email.',
			UsefulFirebaseStringsEnum.sucessSentRecoverPassword: 'Successfully sent password recovery email to [email].',

      // errors
      UsefulFirebaseStringsEnum.noEmailInformed: 'The authentication email was not informed.', 
      UsefulFirebaseStringsEnum.noPasswordInformed: 'The authentication password was not provided.',
      UsefulFirebaseStringsEnum.wrongPassword: 'The password is invalid or the user does not have a password.'
    },
    'es': {
      /// login
			UsefulFirebaseStringsEnum.loggingInWithEmailAndPassword: 'Iniciando sesión',
			UsefulFirebaseStringsEnum.loggingInWithFacebook: 'Iniciar sesión con Facebook',
			UsefulFirebaseStringsEnum.loggingInWithGoogle: 'Iniciar sesión con Google',
			UsefulFirebaseStringsEnum.loggingOut: 'Saliendo de tu cuenta',
			UsefulFirebaseStringsEnum.login: 'Ingrese su correo electrónico y contraseña para iniciar sesión',
			UsefulFirebaseStringsEnum.sendingRecoverPassword: 'Envío de correo electrónico de recuperación de contraseña.',
			UsefulFirebaseStringsEnum.sucessSentRecoverPassword: 'Correo electrónico de recuperación de contraseña enviado correctamente a [email].',

			/// errors
      UsefulFirebaseStringsEnum.noEmailInformed: 'No se informó el correo electrónico de autenticación.', 
      UsefulFirebaseStringsEnum.noPasswordInformed: 'No se proporcionó la contraseña de autenticación.',
      UsefulFirebaseStringsEnum.wrongPassword: 'La contraseña no es válida o el usuario no tiene contraseña.'
    },
    'pt': {
      /// login
			UsefulFirebaseStringsEnum.loggingInWithEmailAndPassword: 'Efetuando login',
			UsefulFirebaseStringsEnum.loggingInWithFacebook: 'Efetuando login com Facebook',
			UsefulFirebaseStringsEnum.loggingInWithGoogle: 'Efetuando login com Google',
			UsefulFirebaseStringsEnum.loggingOut: 'Saindo',
			UsefulFirebaseStringsEnum.login: 'Informe o seu e-mail e senha para entrar',
			UsefulFirebaseStringsEnum.sendingRecoverPassword: 'Enviando e-mail de recuperação de senha.',
			UsefulFirebaseStringsEnum.sucessSentRecoverPassword: 'Enviado e-mail de recuperação de senha com sucesso para [email].',

			/// erros
      UsefulFirebaseStringsEnum.noEmailInformed: 'O e-mail de autenticação não foi informado.', 
      UsefulFirebaseStringsEnum.noPasswordInformed: 'A senha de autenticação não foi informada.',
      UsefulFirebaseStringsEnum.wrongPassword: 'A senha é inválida ou o usuário não possui uma senha.'
    }
  };
}