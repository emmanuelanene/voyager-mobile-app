// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:voyager/common/controller/services/directionServices.dart';
import 'package:voyager/common/controller/services/locationServices.dart';
import 'package:voyager/common/model/rideRequestModel.dart';
import 'package:voyager/constant/constants.dart';
import 'package:voyager/constant/utils/colors.dart';
import 'package:voyager/constant/utils/textStyles.dart';
import 'package:voyager/driver/controller/provider/rideRequestProvider.dart';
import 'package:voyager/driver/controller/services/rideRequestServices/rideRequestServices.dart';


// The goal of the PushNotificationDialouge class is to display a custom dialog that notifies a driver of an incoming ride request, allowing them to either accept or deny the request.
class PushNotificationDialouge {
  // rideRequestModel: an object that holds details about the ride request.
  // context: a special object in Flutter representing where in the app this function is running. It’s needed to show UI elements like dialogs.
  static rideRequestDialogue(RideRequestModel rideRequestModel, BuildContext context) {
    /*
      showDialog is a built-in Flutter function to display a modal popup on the screen.
      When you call showDialog, it shows an alert dialog or a custom dialog widget above your current screen.
      This method returns a Future, meaning it can be awaited if you want to wait until the dialog is closed.
     */
    return showDialog(
        // This tells Flutter where (which part of the app’s widget tree) to display the dialog.
        context: context,

        // This controls whether the dialog can be dismissed by tapping outside it.
        // false means users cannot close the dialog by tapping outside; they must interact with buttons inside the dialog.
        // This is often used for important prompts where you want users to make a decision.
        barrierDismissible: false,

        // The builder is a function that returns the widget (UI element) to display as the dialog.
        builder: (context) {
          // This sets up an audio file (alert.mp3) from your app’s assets to be played. audioPlayer is probably a pre-initialized object that handles playing sounds.
          audioPlayer.setAsset('assets/sounds/alert.mp3');

          // This plays the sound to alert the user when the dialog appears.
          audioPlayer.play();


          /*
            This calls a function that checks if the ride is still available.
            It uses the phone number of the rider from rideRequestModel.
            The exclamation mark ! means you are sure this phone number is not null.
            This might update the UI or data depending on ride availability.
           */
          RideRequestServicesDriver.checkRideAvailability(
            context,
            rideRequestModel.riderProfile.mobileNumber!,
          );


          /*
            After running the above code (playing sound, checking ride), it returns an AlertDialog widget.

            This widget is what actually displays the dialog UI on the screen.

            The content and buttons inside this dialog will be defined inside this widget (not shown in the snippet yet).
           */
          return AlertDialog(
            content: SizedBox(
              height: 50.h,
              width: 90.w,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*
                    Builder is a Flutter widget that helps create a new context inside the widget tree.
                    It’s useful when you want to build some UI based on the latest data or need a fresh context.
                    Here, it lets you return different widgets conditionally inside the dialog.
                   */
                  Builder(builder: (context) {
                    /*
                      This checks if the carType property of the rideRequestModel is 'Uber Go'.

                      If yes, it returns an Image widget that shows the 'uberGo.png' image.

                      AssetImage loads an image from your app’s assets folder.

                      height: 5.h means the image height is 5% of the device screen height (using sizer package for responsive sizing).
                     */
                    if (rideRequestModel.carType == 'Uber Go') {
                      return Image(
                        image: const AssetImage('assets/images/vehicle/uberGo.png',),
                        height: 5.h,
                      );
                    }

                    else if (rideRequestModel.carType == 'Uber Go Sedan') {
                      return Image(
                        image: const AssetImage('assets/images/vehicle/uberGoSedan.png'),
                        height: 5.h,
                      );
                    }

                    else if (rideRequestModel.carType == 'Uber Premier') {
                      return Image(
                        image: const AssetImage('assets/images/vehicle/uberPremier.png'),
                        height: 5.h,
                      );
                    }

                    else {
                      return Image(
                        image: const AssetImage('assets/images/vehicle/uberXL.png'),
                        height: 5.h,
                      );
                    }
                  }),


                  SizedBox(
                    height: 3.w,
                  ),


                  Text(
                    'Ride Request',
                    style: AppTextStyles.body18Bold,
                  ),


                  SizedBox(
                    height: 4.h,
                  ),


                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image: AssetImage('assets/images/icons/pickupPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),

                      SizedBox(
                        width: 5.w,
                      ),

                      Expanded(
                        child: Text(
                          rideRequestModel.pickupLocation.name!,
                          maxLines: 2,
                          style: AppTextStyles.body16,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(
                    height: 3.h,
                  ),


                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4.h,
                        child: const Image(
                          image: AssetImage('assets/images/icons/dropPng.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Text(
                          rideRequestModel.dropLocation.name!,
                          maxLines: 2,
                          style: AppTextStyles.body16,
                        ),
                      ),
                    ],
                  ),


                  SizedBox(
                    height: 2.h,
                  ),



                  // This is a custom widget that shows a button you swipe, not just tap. Think of it like the “slide to unlock” on older iPhones.
                  SwipeButton(
                    // Sets the space around the thumb (the part you swipe). 1.w means 1% of the screen width — makes it responsive on all devices.
                    thumbPadding: EdgeInsets.all(1.w),

                    // The swipeable "thumb" shows a right arrow (>).
                    // white is the color of the arrow
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),

                    // Both when idle and being swiped, the thumb has the same color (success, likely a green color).
                    inactiveThumbColor: success,
                    activeThumbColor: success,

                    // The track (background line) has the same color, even during swipe.
                    inactiveTrackColor: greyShade3,
                    activeTrackColor: greyShade3,

                    // Adds shadow to thumb and track — for a 3D look.
                    elevationThumb: 2,
                    elevationTrack: 2,

                    // This is the main logic. Everything inside happens when the user swipes the button.
                    onSwipe: () async {
                      // Puts the ride request info into the app’s memory so it can be accessed globally.
                      context
                          .read<RideRequestProviderDriver>()
                          .updateRideRequestData(rideRequestModel);

                      // Saves the pickup and drop-off locations for the ride.
                      context
                          .read<RideRequestProviderDriver>()
                          .updateTripPickupAndDropLoction(
                            rideRequestModel.pickupLocation,
                            rideRequestModel.dropLocation,
                          );

                      // Prepares custom icons for the map (like pickup, drop-off, or driver location icons).
                      context
                          .read<RideRequestProviderDriver>()
                          .createIcons(context);

                      // Uses GPS to get the driver’s current position. This was a method we defined ourselves
                      LatLng crrDriverLocation = await LocationServices.getCurrentLocation();

                      // Saves the driver's location for tracking and directions.
                      context
                          .read<RideRequestProviderDriver>()
                          .updateRideAcceptLocation(crrDriverLocation);

                      // Converts pickup location to GPS format to calculate a route.
                      LatLng pickupLocation = LatLng(
                        rideRequestModel.pickupLocation.latitude!,
                        rideRequestModel.pickupLocation.longitude!,
                      );


                      // Gets turn-by-turn directions from driver’s location to pickup point.
                      await DirectionServices.getDirectionDetailsDriver(crrDriverLocation, pickupLocation, context);


                      // Converts the route info into a line (polyline) to draw on the map.
                      context
                          .read<RideRequestProviderDriver>()
                          .decodePolylineAndUpdatePolylineField();


                      // Updates what the map is showing: markers, their positions, and movement.
                      context
                          .read<RideRequestProviderDriver>()
                          .updateUpdateMarkerStatus(true);

                      context
                          .read<RideRequestProviderDriver>()
                          .updateMovingFromCurrentLocationToPickupLocationStatus(true);

                      context.read<RideRequestProviderDriver>().updateMarker();


                      // Notifies the backend that the driver accepted the ride.
                      RideRequestServicesDriver.acceptRideRequest(
                          rideRequestModel.riderProfile.mobileNumber!,
                          context
                      );


                      // Changes the status from “pending” to “accepted”.
                      RideRequestServicesDriver.updateRideRequestStatus(
                        RideRequestServicesDriver.getRideStatus(1),
                        rideRequestModel.riderProfile.mobileNumber!,
                      );

                      // Saves a unique ID for this ride request to the database.
                      RideRequestServicesDriver.updateRideRequestID(
                        rideRequestModel.riderProfile.mobileNumber!,
                      );

                      // Stops any alert sound that was playing.
                      audioPlayer.stop();

                      // Closes the ride request popup after accepting the ride.
                      Navigator.pop(context);
                    },


                    // This is the text shown on the swipe button. It simply says "Accept" in bold font.
                    /*
                    In this case the Builder is not necessary, we could have just added the Text widget directly like this:
                        child: Text(
                          'Accept',
                          style: AppTextStyles.body16Bold,
                        )

                    So when do I need to use "Builder"??? - READ NOTION
                    So when do I need to use "Builder"??? - READ NOTION
                    So when do I need to use "Builder"??? - READ NOTION
                    So when do I need to use "Builder"??? - READ NOTION
                    So when do I need to use "Builder"??? - READ NOTION
                    So when do I need to use "Builder"??? - READ NOTION
                     */
                    child: Builder(builder: (context) {
                      return Text(
                        'Accept',
                        style: AppTextStyles.body16Bold,
                      );
                    }),
                  ),



                  SizedBox(
                    height: 2.h,
                  ),



                  // SWIPE BUTTON TO DECLINE THE RIDE
                  SwipeButton(
                    // Sets the space around the thumb (the part you swipe). 1.w means 1% of the screen width — makes it responsive on all devices.
                    thumbPadding: EdgeInsets.all(1.w),

                    // The swipeable "thumb" shows a right arrow (>).
                    // white is the color of the arrow
                    thumb: Icon(
                      Icons.chevron_right,
                      color: white,
                    ),


                    // Both when idle and being swiped, the thumb has the same color (success, likely a green color).
                    inactiveThumbColor: success,
                    activeThumbColor: success,

                    // The track (background line) has the same color, even during swipe.
                    inactiveTrackColor: greyShade3,
                    activeTrackColor: greyShade3,

                    // Adds shadow to thumb and track — for a 3D look.
                    elevationThumb: 2,
                    elevationTrack: 2,

                    // This is the main logic. Everything inside happens when the user swipes the button
                    onSwipe: () {
                      // Stops any audio playing
                      audioPlayer.stop();

                      // // Closes the ride request popup after accepting the ride.
                      Navigator.pop(context);
                    },

                    child: Builder(builder: (context) {
                      return Text(
                        'Deny',
                        style: AppTextStyles.body16Bold,
                      );
                    }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
