import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:voxeldash/util/handlers/local_notif.dart';

///Network Handler
class NetworkHandler {
  ///Connectivity
  static final Connectivity _connectivity = Connectivity();

  ///Stream Subscription
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  ///Dispose of Network Listener
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  ///Listen for Network Changes
  static void startListening() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        if (result.contains(ConnectivityResult.none)) {
          //Offline
          LocalNotif.show(title: "Uh-oh!", message: "You Are Offline!");
        } else {
          //Connected
          LocalNotif.show(title: "Yay!", message: "You Are Online!");
        }
      },
    );
  }
}
