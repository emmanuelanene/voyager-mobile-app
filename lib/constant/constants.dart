import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
DatabaseReference realTimeDatabaseRef = FirebaseDatabase.instance.ref();

final picker = ImagePicker();

PersistentTabController partnerBottomNavbarController = PersistentTabController(initialIndex: 0);

AudioPlayer audioPlayer = AudioPlayer();