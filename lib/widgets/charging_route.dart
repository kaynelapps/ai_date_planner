import 'package:flutter/material.dart';

class ChargingRoute extends PageRouteBuilder {
  final Widget page;

  ChargingRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      return Stack(
        children: [
          child,
          AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - animation.value,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: animation.value,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 8,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    },
    transitionDuration: Duration(milliseconds: 2000),
  );
}