import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

@MirrorsUsed(symbols: 'dartangular', override: '*')
import 'dart:mirrors';

@Controller(
    selector: '[booking-ctrl]',
    publishAs: 'ctrl')
class BookingController {
  List availableUsers = new List();
  Map bookingData = new Map();
  Http _http;
  bool loading = false;
  String base = '/';
  String title = 'Cloaked danger-zone'; 
  
  BookingController(this._http) {
    // So we can do requests on localhost as well.
    
    // @todo: This should probably be proxied through something in dart.
    if (window.location.origin == 'http://127.0.0.1:3030') {
      base = 'http://localhost:8080/';
    }
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

void main() {
  applicationFactory()
    .addModule(new Module()..bind(BookingController))
    .run();
}