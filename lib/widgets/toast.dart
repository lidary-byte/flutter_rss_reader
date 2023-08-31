import 'package:fluttertoast/fluttertoast.dart';

void toast(String title,
    {Toast toastLength = Toast.LENGTH_LONG,
    ToastGravity gravity = ToastGravity.CENTER}) {
  Fluttertoast.showToast(
      msg: title,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}
