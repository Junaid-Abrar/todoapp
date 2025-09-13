import 'package:flutter/material.dart';

class ToDoCart extends StatelessWidget {
  const ToDoCart(
      {required Key key,
      required this.title,
      required this.iconData,
      required this.iconColor,
        required this.time,
        required this.iconBgColor,
      required this.isCompleted, required this.onChange, required this.index})
      : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool isCompleted;
  final iconBgColor;
  final Function onChange;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              primaryColor: Colors.blue,
              unselectedWidgetColor: Colors.grey,
            ),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                activeColor: Colors.blue,
                checkColor: Colors.white,
                value: isCompleted,
                onChanged: (value) {
                  onChange(value, index);
                }, // stays fixed for now
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
