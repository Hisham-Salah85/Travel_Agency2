import 'dart:io';
import 'Trip.dart';
import 'Booking.dart';

class TravelManager {
  List<Trip> _Trips;

  //List<Passenger> _Passengers;
  List<Booking> _TravelBooking;

  TravelManager() {
    _Trips = new List<Trip>();
    // _Passengers = new List<Passenger>();
    _TravelBooking = new List<Booking>();
  }

  ///
  /// Public Functions
  ///
  //Add new trip info
  AddTrip() {
    try {
      Trip _tripObj;
      while (_tripObj == null) {
        _tripObj = _GetTripFromUser();
      }
      _tripObj.id = _Trips.length + 1;
      _Trips.add(_tripObj);
      printInfo('Trip details added');
    }
    catch (e) {
      printError('Error while adding new Trip details : ' + e.toString());
    }
  }

  //View all trips data order by trip date
  ViewTrips() {
    try {
      //Print headers
      _PrintTableHeader();
      if (_Trips.length == 0) {
        printWarning('No data available');
      } else {
        //order trip list by date
        _Trips.sort((a, b) => a.date.compareTo(b.date));
        // loop on the trips
        _Trips.forEach((Trip tripobj) {
          // call print trip details
          _PrintTripDetails(tripobj, false);
        });
      }
    }
    catch (e) {
      printError('Error while View Trips : ' + e.toString());
    }
  }

  //Edit Trip by Trip id
  EditTrip() {
    try {
      int TripID = 0;
      while (TripID == 0) {
        stdout.write('Enter a valid Trip ID to Edit :');
        String TripIDLine = stdin.readLineSync();
        try {
          TripID = int.parse(TripIDLine);
          if (TripID > _Trips.length) {
            printWarning("invalid Trip Number , no Trips with ID= ${TripID}");
            TripID = 0;
          }
        } catch (ex) {
          print(ex);
        }
      }

      Trip TObj = _findTrip(TripID);
      if (TObj != null) {
        Trip _tripObj;
        while (_tripObj == null) {
          _tripObj = _GetTripFromUser();
        }
        int tripindex = _Trips.indexOf(TObj);
        _tripObj.id = TripID;
        TObj = _tripObj;
        _Trips[tripindex] = TObj;
        printInfo('Trip data updated successfully');
      }
    }
    catch (e) {
      printError('Error while update Trip details ' + e);
    }
  }

  //Delete trip by trip id
  DeleteTrip() {
    try {
      int TripID = 0;
      while (TripID == 0) {
        stdout.write('Enter a valid Trip ID to Delete :');
        String TripIDLine = stdin.readLineSync();
        try {
          TripID = int.parse(TripIDLine);
          if (TripID > _Trips.length) {
            printWarning("invalid Trip Number , no Trips with ID= ${TripID}");
            TripID = 0;
          }
        } catch (ex) {
          printError(ex);
        }
      }

      Trip TObj = _findTrip(TripID);
      if (TObj != null) {
        int tripindex = _Trips.indexOf(TObj);
        _Trips.removeAt(tripindex);
        printInfo('Trip deleted successfully');
      }
    }
    catch (e) {
      printError('Error while deleting Trip ' + e);
    }
  }

  // Search Trips by Price
  SearchTrips() {
    try {
      print('Search Trips by price:');
      bool validPrices = false;
      stdout.write('From price:');
      var minPriceline = stdin.readLineSync();
      stdout.write('To price:');
      var maxPriceline = stdin.readLineSync();
      double minPrice = 0;
      double maxPrice = 0;
      while (!validPrices) {
        try {
          minPrice = double.parse(minPriceline);
          maxPrice = double.parse(maxPriceline);
          if (minPrice <= maxPrice && maxPrice > 0) {
            validPrices = true;
          }
          else {
            printWarning('From price must be less than or equal To Price ');
          }
        }
        catch (ex) {
          printError('Invalid Prices' + ex);
        }
      }
      var tripData = _Trips.where((tripObj) =>
      tripObj.price >= minPrice && tripObj.price <= maxPrice);
      if (tripData.length > 0) {
        _PrintTableHeader();
        tripData.forEach((Trip tripobj) {
          // call print trip details
          _PrintTripDetails(tripobj, false);
        });
      }
      else {
        printWarning('No Trips within the entered Prices ');
      }
    }
    catch (e) {
      printError('Search Trips by Prices error ' + e);
    }
  }

  ReserveTrip() {
    try {
      print('Reserve Trip:');
      stdout.write('Passenger Name:');
      String PassengerName = stdin.readLineSync();

      int TripID = 0;
      while (TripID == 0) {
        stdout.write('Enter a valid Trip ID to Reserve :');
        String TripIDLine = stdin.readLineSync();
        try {
          TripID = int.parse(TripIDLine);
          if (TripID > _Trips.length) {
            printWarning("invalid Trip Number , no Trips with ID= ${TripID}");
            TripID = 0;
          }
          else {
            int FreePlaces = _GetFreePlacesOnTrip(TripID);
            if (FreePlaces <= 0) {
              printWarning('No free Places on this Trip');
              TripID = 0;
            }
          }
        } catch (ex) {
          printError(ex);
        }
      }

      Trip TObj = _findTrip(TripID);
      _PrintTripDetails(TObj, true);
      stdout.write(
          'confirm reserve on Trip ${TObj.location} on ${_FormatDateString(TObj
              .date)} with Price ${TObj
              .price} , to Reserve press y , else press any key :');
      String userConfirmation = stdin.readLineSync();
      if (userConfirmation.toLowerCase() == 'y') {
        Booking bookObj = new Booking();
        bookObj.tripID = TripID;
        bookObj.passengerName = PassengerName;
        bookObj.ticketNumber = _GenerateTicketNumber(TObj);
        _TravelBooking.add(bookObj);
        printWarning('Trip data updated successfully with Ticket Number : ${bookObj
            .ticketNumber}');
      }
      else {
        printWarning('Trip Reserved canceled');
      }
    }
    catch (e) {
      printError('Reserve Trip error ' + e);
    }
  }

  Discount() {
    try {
      int TripID = 0;
      while (TripID == 0) {
        stdout.write('Enter a valid Trip ID to show discount :');
        String TripIDLine = stdin.readLineSync();
        try {
          TripID = int.parse(TripIDLine);
          if (TripID > _Trips.length) {
            printWarning("invalid Trip Number , no Trips with ID= ${TripID} ");
            TripID = 0;
          }
        } catch (ex) {
          printError(ex);
        }
      }

      Trip TObj = _findTrip(TripID);
      _PrintTripDetails(TObj, true);
      printInfo('This Trip has discount by ${TObj.discount}% , final price will be : ${TObj.price -(TObj.price * TObj.discount / 100)}');
    }
    catch (e) {
      printError('Error while get Discount : ' + e.toString());
    }
  }
//
  LatestTrips(int numberOfRows) {
    try {
      print('Show Latest ${numberOfRows} Trips:');
      //Print headers
      _PrintTableHeader();
      if (_Trips.length == 0) {
        printWarning('No data available');
      } else {
        int loopingEndIndex = 0;
        if (numberOfRows > _Trips.length) {
          numberOfRows = _Trips.length-1;
        }
        else {
          loopingEndIndex = _Trips.length - numberOfRows;
          numberOfRows = _Trips.length-1;

        }

        // loop on the trips
        for (int i = numberOfRows; i >= loopingEndIndex; i--) {
          // call print trip details
          _PrintTripDetails(_Trips[i], false);
        }
      }
    }
    catch (e) {
      printError('Error while get Latest Trips : ' + e.toString());
    }
  }

  //View Passenger
  ViewPassenger() {
    try {
      if (_Trips.isNotEmpty) {


      _Trips.forEach((tripobj) {
        // call print trip details
        _PrintTripDetails(tripobj, true);
        List<Booking> passengerLst = _findPassengersInTrip(tripobj.id);
        if (passengerLst.isNotEmpty) {
          _PrintPassengerTableHeader();
          passengerLst.forEach((passenger) {
            _PrintPassengerDetails(passenger, false);
          });
        }
        else {
          printWarning('-------  No Passengers on this trip  -------');
        }
        print(
            '--------------------------------------------------------------------------------------------------');
      });


      }
    }
    catch (e) {
      printError('Error while View Passenger details ' + e);
    }
  }



  // Private Functions

  //Print trip details
  _PrintTripDetails(Trip TripObj, bool PrintWithHeader) {
    if (PrintWithHeader) {
      _PrintTableHeader();
    }
    print('${TripObj.id.toString().padRight(6, ' ')} \t ${TripObj.location.padRight(30, ' ')} \t ${TripObj
        .passengerLimit.toString().padRight(6, ' ')} \t\t\t ${_FormatDateString(TripObj.date)} \t ${TripObj
        .price.toString().padRight(12, ' ')}\t${TripObj.discount}%');
  }
  _PrintPassengerDetails(Booking BookingObj, bool PrintWithHeader) {
    if (PrintWithHeader) {
      _PrintPassengerTableHeader();
    }
    print('${BookingObj.ticketNumber} \t\t ${BookingObj.passengerName}');
  }

  //return date to string in form of YYYY-MM-DD
  String _FormatDateString(DateTime DateObj) {
    return "${DateObj.year}-${DateObj.month}-${DateObj.day}";
  }

  // find trip by trip id
  Trip _findTrip(int TripID) {
    Trip data = _Trips.firstWhere((TObj) => (TObj.id == TripID));
    return data;
  }

  //Get Trip From User
  Trip _GetTripFromUser() {
    try {
      Trip _tripObj = new Trip();
      print('Please Enter Trip details');
      stdout.write('Location:');
      var locationline = stdin.readLineSync();

      stdout.write('Passenger Limit:');
      var passengerLimitline = stdin.readLineSync();
      stdout.write('date (YYYY-MM-dd):');
      var dateline = stdin.readLineSync();
      stdout.write('price:');
      var priceline = stdin.readLineSync();

      //TODO: try to parse each user entry and ask the user to renter

      _tripObj.location = locationline;
      _tripObj.passengerLimit = int.parse(passengerLimitline);
      _tripObj.date = DateTime.parse(dateline);
      _tripObj.price = double.parse(priceline);

      if (_tripObj.price >= 10000)
        _tripObj.discount = 20;
      else
        _tripObj.discount = 0;

      return _tripObj;
    }
    catch (ex) {
      printError('Error with  Trip details : ' + ex.toString());
      return null;
    }
  }

  // Generate Ticket Number
  String _GenerateTicketNumber(Trip tripObj) {
    DateTime dObj = new DateTime.now();
    return "${tripObj.id.toString().padLeft(4, '0')}${dObj.year.toString()
        .padLeft(4, '0')}${dObj.month.toString().padLeft(2, '0')}${dObj.day
        .toString().padLeft(2, '0')}${dObj.hour.toString().padLeft(
        2, '0')}${dObj.minute.toString().padLeft(2, '0')}${dObj.second
        .toString().padLeft(2, '0')}${dObj.millisecond.toString().padLeft(
        2, '0')}${dObj.microsecond.toString().padLeft(2, '0')}";
  }

  //Get Free Places On Trip
  int _GetFreePlacesOnTrip(int TripID) {
    int FreePlaces = _findTrip(TripID).passengerLimit;
    //check if there is any booking
    var tBookObj = _TravelBooking.where((book) => book.tripID == TripID);
    if (tBookObj != null) {
      FreePlaces = FreePlaces - tBookObj.length;
    }
    return FreePlaces;
  }

  //Print Table header
  _PrintTableHeader() {
    print('------------------------------------------------------------------------------------------------------------------------');
    print(' ID  \t Location \t\t\t\t\t\t\t passenger Limit \t Date \t\t Price \t\t Discount%');
    print('------------------------------------------------------------------------------------------------------------------------');
  }

  _PrintPassengerTableHeader() {
    print('-------------------------------------------------------------');
    print('Ticket Number \t\t\t Passenger Name ');
    print('-------------------------------------------------------------');
  }

  List<Booking> _findPassengersInTrip(int TripID) {
    return  _TravelBooking.where((BObj) => (BObj.tripID == TripID)).toList();
  }
  void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }
  void printWarning(String text) {
    print('\x1B[33m$text\x1B[0m');
  }
  void printInfo(String text) {
    print('\x1B[34m$text\x1B[0m');
  }
}