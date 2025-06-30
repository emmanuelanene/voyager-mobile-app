import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:voyager/common/controller/services/locationServices.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:voyager/constant/constants.dart';
import 'package:voyager/driver/controller/provider/locationProviderDriver.dart';

class GeoFireServices {
  static DatabaseReference databaseRef = FirebaseDatabase.instance
      .ref()
      .child('User/${auth.currentUser!.phoneNumber}/driverStatus');

  static goOnline() async {
    LatLng currentPosition = await LocationServices.getCurrentLocation();
    Geofire.initialize('OnlineDrivers');
    Geofire.setLocation(
      auth.currentUser!.phoneNumber!,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    databaseRef.set('ONLINE');
    databaseRef.onValue.listen((event) {});
  }



  /*
  goOffline method:
Geofire.removeLocation(auth.currentUser!.phoneNumber!): Remove the driver’s location from GeoFire, so they no longer appear as “online” in location queries.

databaseRef.set('OFFLINE'): Update the driver's status in the database to the string “OFFLINE” to show they are not available.

databaseRef.onDisconnect(): This sets up a Firebase listener that will trigger when the connection is lost (like if the app crashes or the user loses internet). Here, it's just called but not given further instructions, so it’s incomplete or a placeholder.


---


updateLocationRealTime method:
Geolocator.checkPermission(): Ask the device if the app has permission to access the location data.

if (permission == LocationPermission.denied): If permission is denied, then...

Geolocator.requestPermission(): Ask the user to allow location access.

LocationSettings(...): Create settings that define how precise the location updates should be and how far the driver must move before an update is sent (here, accuracy is very high, and the location updates only after moving 10 meters).

Geolocator.getPositionStream(locationSettings: locationSettings): Start listening to the device’s GPS location updates according to the settings.

.listen((event) {...}): Every time the device gets a new location, run the code inside the braces.

context.read<LocationProviderDriver>().updateDriverPosition(event): Tell the app’s location provider to update the driver’s current position with the new GPS data.

Geofire.setLocation(auth.currentUser!.phoneNumber!, event.latitude, event.longitude): Update GeoFire with the driver’s new location, so their position stays accurate in the database.
   */
  static goOffline(BuildContext context) {
    Geofire.removeLocation(auth.currentUser!.phoneNumber!);
    databaseRef.set('OFFLINE');
    databaseRef.onDisconnect();
  }

  static updateLocationRealTime(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    StreamSubscription<Position> driverPositionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((event) {
      context.read<LocationProviderDriver>().updateDriverPosition(event);
      Geofire.setLocation(
        auth.currentUser!.phoneNumber!,
        event.latitude,
        event.longitude,
      );
    });
  }
}
