import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:voyager/common/controller/provider/authProvider.dart';
import 'package:voyager/common/controller/provider/locattionProvider.dart';
import 'package:voyager/common/controller/provider/profileDataProvider.dart';
import 'package:voyager/common/view/signInLogic/signInLogin.dart';
import 'package:voyager/constant/utils/colors.dart';
import 'package:voyager/driver/controller/provider/rideRequestProvider.dart';
import 'package:voyager/driver/controller/services/bottomNavBarRiderProvider.dart';
import 'package:voyager/driver/controller/services/mapsProviderDriver.dart';
import 'package:voyager/firebase_options.dart';
import 'package:voyager/rider/controller/provider/bottomNavBarRiderProvider/bottomNavBarRiderProvider.dart';
import 'package:voyager/rider/controller/provider/tripProvider/rideRequestProvider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Voyager());
}

class Voyager extends StatefulWidget {
  const Voyager({super.key});

  @override
  State<Voyager> createState() => _VoyagerState();
}

class _VoyagerState extends State<Voyager> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MultiProvider(
        providers: [
          // ! Common Providers
          ChangeNotifierProvider<MobileAuthProvider>(
            create: (_) => MobileAuthProvider(),
          ),
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          ),
          ChangeNotifierProvider<ProfileDataProvider>(
            create: (_) => ProfileDataProvider(),
          ),
          // ! Rider Providers
          ChangeNotifierProvider<BottomNavBarRiderProvider>(
            create: (_) => BottomNavBarRiderProvider(),
          ),
          ChangeNotifierProvider<RideRequestProvider>(
            create: (_) => RideRequestProvider(),
          ),
          // ! Driver Providers
          ChangeNotifierProvider<BottomNavBarDriverProvider>(
            create: (_) => BottomNavBarDriverProvider(),
          ),
          ChangeNotifierProvider<MapsProviderDriver>(
            create: (_) => MapsProviderDriver(),
          ),
          ChangeNotifierProvider<RideRequestProviderDriver>(
            create: (_) => RideRequestProviderDriver(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              color: white,
              elevation: 0,
            ),
          ),
          home: const SignInLogic(),
        ),
      );
      // return
    });
  }
}
