import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

@MirrorsUsed(symbols: 'dartangular', override: '*')
import 'dart:mirrors';

@Component(
  selector: 'booking-ctrl',
  templateUrl: 'book-ctrl.html')
class BookingComponent {
  List<Map> availableUsers = new List();
  Map bookingData = new Map();
  final Http _http;
  bool loading = false;
  String base = '/';
  String title = 'Cloaked danger-zone';
  
  BookingComponent(this._http) {
    print("doing this init stuff.");
    // Turn on loading animation.
    loading = true;
    // Get all available users.
    _http.get(base + 'api/user')
    .then((HttpResponse response) {
      // Turn off loading animation.
      loading = false;
      response.data.forEach((v) {
        availableUsers.add(v);
      });
    });
  }
  void loadBooking(String user) {
    loading = true;
    _http.get(base + 'api/userstatus/' + user)
    .then((HttpResponse response) {
      loading = false;
      response.data.forEach((k, v) {
        if (k == 'status') {
          bookingData[user] = new List();
          v.forEach((f) {
            bookingData[user].add(f);
          });
        }
      });
    });
  }
  void unbook(String id, String user) {
    loading = true;
    _http.get(base + 'api/unbook/' + user + '/' + id)
    .then((HttpResponse response) {
      loading = false;
      loadBooking(user);
    });
  }
}

class BookingModule extends Module {
  BookingModule() {
    bind(BookingComponent);
  }
}

void main() {
  applicationFactory()
    .addModule(new BookingModule())
    .run();
}