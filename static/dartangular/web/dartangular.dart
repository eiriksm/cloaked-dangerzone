import 'package:angular/angular.dart';

@MirrorsUsed(override: '*')
import 'dart:mirrors';

@NgController(
    selector: '[booking-ctrl]',
    publishAs: 'ctrl')
class BookingController {
  String selectedBooker;
  List bookingData = new List();
  Http _http;
  Map<String, bool> categoryFilterMap = {};
  bool loading = false;
  
  BookingController(this._http) {
    // Constructor. Empty for now.
  }
  void loadBooking() {
    loading = false;
    _http.get('/api/user/' + selectedBooker)
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