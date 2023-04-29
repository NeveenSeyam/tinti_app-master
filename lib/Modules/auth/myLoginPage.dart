// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class _MyAppState extends State<MyApp> {
//   final _phoneNumberController = TextEditingController();
//   String _verificationId = "";

//   Future<void> _verifyPhoneNumber() async {
//     final PhoneVerificationCompleted verificationCompleted =
//         (AuthCredential phoneAuthCredential) async {
//       await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
//     };

//     final PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException authException) {
//       print('Phone verification failed: ${authException.message}');
//     };

//     final PhoneCodeSent codeSent =
//         (String verificationId, [int forceResendingToken]) async {
//       _verificationId = verificationId;
//       print('Please check your phone for the verification code.');
//     };

//     final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//         (String verificationId) {
//       _verificationId = verificationId;
//       print("verification code: $_verificationId");
//     };

//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: _phoneNumberController.text,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _phoneNumberController,
//                   decoration: InputDecoration(
//                     hintText: 'Enter your phone number',
//                   ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: _verifyPhoneNumber,
//                 child: Text('Verify'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
