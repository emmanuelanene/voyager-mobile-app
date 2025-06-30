import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:voyager/common/controller/services/APIsNKeys/apis.dart';
import 'package:voyager/common/controller/services/APIsNKeys/keys.dart';
import 'package:voyager/common/controller/services/firebasePushNotificatinServices/pushNotificationDialogue.dart';
import 'package:voyager/common/model/profileDataModel.dart';
import 'package:voyager/common/model/rideRequestModel.dart';
import 'package:voyager/constant/constants.dart';
import 'package:http/http.dart' as http;

// This part of the PushNotificationServices class is setting up Firebase Cloud Messaging (FCM) so the app can receive push notifications, like a ride request from a rider or partner.
class PushNotificationServices {
  //  Initializing Firebase Messaging Instance. "FirebaseMessaging" is a class from Firebase that helps your app receive messages (notifications).
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  // This is a function to initialize the messaging system based on the user's type (PARTNER or not).
  // ProfileDataModel profileData: contains details like the user’s type (e.g., partner or rider).
  // BuildContext context: allows access to the app's current UI state.
  static Future initializeFirebaseMessaging(ProfileDataModel profileData, BuildContext context) async {
    // This asks the user for permission to receive notifications. It’s required on iOS and good practice on Android.
    await firebaseMessaging.requestPermission();

    // If the logged-in user is a driver, we set up driver-specific notification handling.
    if (profileData.userType == 'PARTNER') {
      /*
      This sets a handler function to run when a message is received while the app is in the background or terminated. For partners, it uses firebaseMessagingBackfroundHandlerDriver. "firebaseMessagingBackfroundHandlerDriver" is a function we defined below

      This sets up a background listener.
      It tells Firebase Messaging:
      🧏‍♂️ “Hey, if a message comes in and my app is not active (i.e., in background or terminated), please handle it using this function.”
       */
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackfroundHandlerDriver);



      /*
       This listens for messages received while the app is open (foreground). If the message contains a notification, it calls a function to handle it for drivers.

      FirebaseMessaging.onMessage:
       This is like turning on a notification listener. It listens for messages while the app is running in the foreground (open on the screen).

       .listen(...)
        This means: “When I hear something, do this action.”
        It takes a function as its argument — a function that tells it what to do when a message comes in.

        (RemoteMessage message) { ... }
          - This is a function (specifically, an anonymous callback function).
          - RemoteMessage is the type of object you're receiving. It holds all the info about the notification.
          - message is the name of the variable that will contain that notification data.
          - Inside the { ... }, you write the code that should run when a message is received.
       */
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerDriver(message, context);
        }
      });
    }


    /*
    If the user is not a partner, then they must be a rider.
    Similar setup:
        Background messages go to firebaseMessagingBackfroundHandlerRider.
        Foreground messages call firebaseMessagingForeGroundHandlerRider.
     */
    else {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackfroundHandlerRider);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          firebaseMessagingForeGroundHandlerRider(message);
        }
      });
    }
  }



  // This function takes a Firebase push notification (called message), extracts the ride ID from it, and returns that ID.
  // RemoteMessage message: This is the notification payload (data) sent by Firebase.
  static getRideRequestID(RemoteMessage message) {
    /*
     This turns the message into a map (toMap()), then into a string, and prints it in the console.
     It’s for debugging — to see what data came in the notification.
     Example output might look like:
      "{
         notification: {
           title: Ride Request,
           body: New Ride Request
         },

         data: {rideRequestID: 08012345678}
       }"
     */
    log(message.toMap().toString());


    // message.data gives you a map of key-value pairs in the "data" part of the notification.
    // ['rideRequestID'] pulls the value of that specific key from the map.
    // That value (usually a phone number or unique ID) is saved into the variable rideID.
    String rideID = message.data['rideRequestID'];

    log(rideID);
    return rideID;
  }



  /*
   ! Rider Cloud Messaging Functions
   These two functions handle push notifications when they arrive:
      In the background → firebaseMessagingBackfroundHandlerRider
      While the app is open → firebaseMessagingForeGroundHandlerRider

  They are currently empty, but will be filled with actions like showing a dialog, updating the UI, etc.
   */
  static Future<void> firebaseMessagingBackfroundHandlerRider(RemoteMessage message) async {}
  static firebaseMessagingForeGroundHandlerRider(RemoteMessage message) async {}



  // ! Driver Cloud Messaging Functions
  static Future<void> firebaseMessagingBackfroundHandlerDriver(RemoteMessage message) async {
    String riderID = getRideRequestID(message);
  }

  /*
  This line extracts the rider’s ID from the incoming message.

  It calls another function (getRideRequestID) which looks into the message data and pulls out "rideRequestID".

  🧠 But right now, nothing else happens with that riderID. You might add logic later to show a notification or update the UI.
   */
  static firebaseMessagingForeGroundHandlerDriver(RemoteMessage message, BuildContext context) async {
    // Same as before — extracts the ride ID from the message.
    String rideID = getRideRequestID(message);

    // This line retrieves full ride details from Firebase using that ride ID.
    // Then, it likely shows a dialog to the driver to accept or deny the ride (based on other parts of your code).
    fetchRideRequestInfo(rideID, context);
  }

// ! *****************************************


  // getToken(...): The function name. It takes in a user model (you’re not using it yet here).
  static Future getToken(ProfileDataModel model) async {
    /*
    firebaseMessaging.getToken() asks Firebase for this device's unique FCM token.
    The token is a long string that identifies this specific device.
    You need it so you can send push notifications directly to this device.
    await means: "wait here until Firebase gives us the token."
     */
    String? token = await firebaseMessaging.getToken();

    // This prints the token to the debug console (for your reference).
    log('Cloud Messaging Token is : $token');

    // This builds the path in your Firebase Realtime Database where the token will be saved.
    // Let's say the user’s phone number is +2348012345678, then the path becomes:
    // 'User/+2348012345678/cloudMessagingToken'  -> That’s where the token will be saved.
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .ref()
        .child('User/${auth.currentUser!.phoneNumber}/cloudMessagingToken');

    // This line actually saves the token at that database location.
    tokenRef.set(token);
  }





  // String rideID: This is the unique ID of the ride you want to fetch from Firebase.
  // BuildContext context: Needed to display the dialogue later.
  static fetchRideRequestInfo(String rideID, BuildContext context) {
    // This tells Firebase: “Go to the RideRequest node → then go inside the one that has the ID of rideID.”
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('RideRequest/$rideID');

    // .once() means: “Read this data only once (don’t keep listening).”
    // .then(...): When the data comes back, run the function inside.
    ref.once().then((databaseEvent) {
      // Checks if the ride request was found.
      // If there's no data (it's null), nothing happens.
      if (databaseEvent.snapshot.value != null) {
        /*
        databaseEvent.snapshot.value: This is the raw ride request data from Firebase.
        jsonEncode(...): Converts the data to a JSON string.
        jsonDecode(...): Converts that JSON string back into a Map.
        RideRequestModel.fromMap(...): Converts the Map into your app’s RideRequestModel object.
         */
        RideRequestModel rideRequestModel = RideRequestModel.fromMap(
            jsonDecode(jsonEncode(databaseEvent.snapshot.value)) as Map<String, dynamic>
        );

        // Just prints the ride data (for debugging).
        log(rideRequestModel.toMap().toString());

        log('Showing Dialogue');

        /*
        Shows a custom dialogue box using your PushNotificationDialouge class.
        You’re passing in:
            rideRequestModel: The ride info
            context: So Flutter knows where to show the dialogue.
         */
        PushNotificationDialouge.rideRequestDialogue(rideRequestModel, context);
      }
    }).onError((error, stackTrace) {
      log(error.toString());
      throw Exception(error);
    });
  }

  static subscribeToNotification(ProfileDataModel model) {
    /*
    What is subscribeToTopic()? -> It is a method provided by Firebase Cloud Messaging (FCM) that Subscribes a device (user's app) to a named topic so that it can receive broadcast push notifications sent to that topic.

    If the user is a partner, they’ll subscribe to:
        PARTNER: Messages meant for all drivers/partners.
        USER: Messages meant for all app users, regardless of role.
     */
    if (model.userType == 'PARTNER') {
      firebaseMessaging.subscribeToTopic('PARTNER');
      firebaseMessaging.subscribeToTopic('USER');
    }

    /*
    If the user is not a partner (so they’re a rider), subscribe to:
        RIDER: Messages meant for all riders.
        USER: General messages for everyone.
     */
    else {
      firebaseMessaging.subscribeToTopic('RIDER');
      firebaseMessaging.subscribeToTopic('USER');
    }
  }


  /*
  It's a setup function.
  It does 3 things in one call:
      Set up notification permissions & listeners
      Get the user's FCM token
      Subscribe the user to a notification topic

  🧠 Imagine you just logged in to the app.
  Now, the app needs to:
      Ask for notification permission 📲
      Save your device's token so it can receive notifications 🎯
      Decide what kind of messages you should get (RIDER? PARTNER?) 📢

  That's what this function is automating for you.
   */
  static initializeFirebaseMessagingForUsers(ProfileDataModel profileData, BuildContext context) {
    initializeFirebaseMessaging(profileData, context);
    getToken(profileData);
    subscribeToNotification(profileData);
  }


  // It sends a push notification to a specific driver's phone using their FCM token.
  // This is like saying: "Hey driver, there's a ride request near you!"
  static sendRideRequestToNearbyDrivers(String driverFCMToken) async {
    try {
        // APIs.pushNotificationAPI() gives the link to Firebase Cloud Messaging (FCM) server. Think of this like sending a letter to a post office (FCM), which then delivers it to the driver.
        final api = Uri.parse(APIs.pushNotificationAPI());

        /*
        to: the driver's FCM token (like their phone number in the Firebase notification world).
        notification: What appears on the driver's screen (title + message).
        data: Extra hidden info that the app can use (in this case, your phone number as the ride request ID).

        ✅ This will show a pop-up on the driver’s phone and also include ride data for the app to process.
         */
        var body = jsonEncode({
          "to": driverFCMToken,
          "notification": {
            "body": "New Ride Request In your Location.",
            "title": "Ride Request"
          },

          "data": {"rideRequestID": auth.currentUser!.phoneNumber!}
        });


        /*
        Sends the body to the FCM server. The Authorization header uses your fcmServerKey, which proves that your app has permission to send notifications.

        ✅ Logs success if it works.
        ⚠️ If the server takes more than 60 seconds, it throws a timeout error.
        ❌ If any error occurs during sending, it throws an exception.
         */
        var response = await http
            .post(
                api,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'key=$fcmServerKey'
                },
                body: body
            )

            .then((value) {
              log('Successfully send Ride Request');
            })

            .timeout(const Duration(seconds: 60), onTimeout: () {
              throw TimeoutException('Connection Timed Out');
            })

            .onError((error, stackTrace) {
              throw Exception(error);
            });
    }

    // If anything unexpected goes wrong during this process (like a crash), it logs the error.
    catch (e) {
      log(e.toString());
      log('Error sending push Notification');
      throw Exception(e);
    }
  }
}
