import 'package:angular/angular.dart';

@MirrorsUsed(override: '*')
import 'dart:mirrors';

@NgController(
    selector: '[booking-ctrl]',
    publishAs: 'ctrl')
class BookingController {
  List availableUsers = new List();
  List bookingData = new List();
  Http _http;
  Map<String, bool> categoryFilterMap = {};
  bool loading = false;
  
  BookingController(this._http) {
    // Get all available users.
    _http.get('/api/user')
    .then((HttpResponse response) {
      response.data.forEach((v) {
        availableUsers.add(v);
      });
    });
  }
  void loadBooking(String user) {
    loading = false;
    _http.get('/api/userstatus/' + user)
    .then((HttpResponse response) {
      response.data.forEach((k, v) {
        if (k == 'status') {
          v.forEach((f) {
            bookingData.add(f);
          });
        }
      });
      loading = true;
    });
    loading = true;
  }
}
class MyAppModule extends Module {
  MyAppModule() {
    type(BookingController);
  }
}

void main() {
  ngBootstrap(module: new MyAppModule());
}