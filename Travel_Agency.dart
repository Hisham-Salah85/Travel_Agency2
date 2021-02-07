import 'dart:io';
import 'TravelManager.dart';

main()
{
  bool _exit = false;
  TravelManager _TravelManager = new TravelManager();

  printError('Welcome to Travel Agency');

  while(!_exit) {
    print('**********************************************');
    printWarning('Press proper Number for function as below:');
    printInfo('===================================================================================================================================');
    print('| Add Trip | Edit Trip | Delete Trip | View Trips | Search Trip | Reserve Trip | Discount | Latest Trips |View Passenger|   Exit  |');
    printInfo('----------------------------------------------------------------------------------------------------------------------------------');
    print('|    1     |     2     |      3      |     4      |      5      |      6       |    7     |      8       |      9       |    0    |');
    printInfo('===================================================================================================================================');
    stdout.write('Your Choice is:');
    var line = stdin.readLineSync();

    switch(line) {
      case '1':
        print('**** Add new Trip details ****');
        _TravelManager.AddTrip();
        break;
      case '2':
        print('**** Edit Trip ****');
        _TravelManager.EditTrip();
          break;
      case '3':
        print('**** Delete Trip ****');
        _TravelManager.DeleteTrip();
        break;
      case '4':
        print('**** View All Trips ****');
        _TravelManager.ViewTrips();
        break;
      case '5':
        print('**** Search Trip ****');
        _TravelManager.SearchTrips();
        break;
      case '6':
        print('**** Reserve Trip ****');
        _TravelManager.ReserveTrip();
        break;
      case '7':
        print('**** Discount ****');
        _TravelManager.Discount();
        break;
      case '8':
      print('**** Latest Trips ****');
      _TravelManager.LatestTrips(2);
      break;
      case '9':
        print('**** View Passenger ****');
        _TravelManager.ViewPassenger();
        break;
      case '0':
        _exit = true;
        print('Good bye !!!');
        break;
      default:
        print('Invalid entry.');
        break;
    }
  }
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


//https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html