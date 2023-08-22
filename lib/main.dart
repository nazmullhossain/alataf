
import 'package:alataf/provider/imge_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:alataf/bloc/CartDetailsBloc.dart';
import 'package:alataf/bloc/HomeBloc.dart';
import 'package:alataf/screens/home_screen.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'bloc/MainBloc.dart';
import 'bloc/history_bloc.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  getIt.registerSingleton<CartDetailsBloc>(CartDetailsBloc());
  getIt.registerSingleton<HistoryDetailsBloc>(HistoryDetailsBloc());
  getIt.registerSingleton<MainBloc>(MainBloc());

  return runApp(MyApp());
}

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
//   oneSignalPushSetup() async {
//     //comment by Rasel
//     // OneSignal.shared.init("edfdf652-b305-4398-8e23-c12b5407d84a", iOSSettings: {
//     //   OSiOSSettings.inAppLaunchUrl: false
//     // });
//     //added by Rasel
//     OneSignal.shared.setAppId("edfdf652-b305-4398-8e23-c12b5407d84a", );

//     //comment by Rasel
//     // OneSignal.shared
//     //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
//     //added by Rasel
//     OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
//       // Will be called whenever a notification is received in foreground
//       // Display Notification, pass null param for not displaying the notification
//       event.complete(event.notification);
//     });
//     OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//       // Will be called whenever a notification is opened/button pressed.
//     });
//     //added by Rasel
//     OneSignal.shared.setLaunchURLsInApp(false);

// // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//     OneSignal.shared
//         .promptUserForPushNotificationPermission(fallbackToSettings: true);
//     await OneSignal.shared
//         .promptUserForPushNotificationPermission(fallbackToSettings: true);

//     //comment by Rasel
//     // OneSignal.shared
//     //     .setNotificationReceivedHandler((OSNotification notification) {
//     //   // will be called whenever a notification is received
//     //   print(
//     //       " setNotificationReceivedHandler ${notification.jsonRepresentation()}");
//     // });

//     OneSignal.shared
//         .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//       // will be called whenever a notification is opened/button pressed.
//       print(
//           " setNotificationOpenedHandler ${result.notification.jsonRepresentation()}");
//     });

//     OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
//       print(" setPermissionObserver ${changes.jsonRepresentation()}");
//       // will be called whenever the permission changes
//       // (ie. user taps Allow on the permission prompt in iOS)
//     });

//     OneSignal.shared
//         .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
//       print("set subscription ${changes.jsonRepresentation()}");
//       // will be called whenever the subscription changes
//       //(ie. user gets registered with OneSignal and gets a user ID)
//     });

//     OneSignal.shared.setEmailSubscriptionObserver(
//         (OSEmailSubscriptionStateChanges emailChanges) {
//       // will be called whenever then user's email subscription changes
//       // (ie. OneSignal.setEmail(email) is called and the user gets registered
//       print("email ${emailChanges.jsonRepresentation()}");
//     });

//     // For each of the above functions, you can also pass in a
//     // reference to a function as well:

//     void _handleNotificationReceived(OSNotification notification) {
//       print("${notification.title}");
//     }

//     //added by Rasel
//     OneSignal.shared
//         .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//       print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');

//     });
//     // comment by Rasel
//     // OneSignal. 
//     //     .setNotificationReceivedHandler(_handleNotificationReceived);
//   } .

  @override
  Widget build(BuildContext context) {
    // oneSignalPushSetup();
    final _cartDetailsBloc = getIt<CartDetailsBloc>();
    _cartDetailsBloc.initDatabase();
    HomeBloc _homeBloc = HomeBloc();
    _homeBloc.getUserPreference();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => RecipeClass()),
      ],
      child: Consumer<Counter>(
        builder: (context, counter, _) {
          return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
        },
      ),
    );
  }
}
