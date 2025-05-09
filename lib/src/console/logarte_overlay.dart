import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_auth_screen.dart';

class LogarteOverlay extends StatelessWidget {
  final Logarte instance;
  final String? appBarTitle;

  const LogarteOverlay._internal({
    required this.instance,
    this.appBarTitle,
  });

  static void attach({
    required BuildContext context,
    required Logarte instance,
    String? appBarTitle,
  }) {
    final entry = OverlayEntry(
      builder: (context) {
        return LogarteOverlay._internal(
          instance: instance,
          appBarTitle: appBarTitle,
        );
      },
    );

    Future.delayed(kThemeAnimationDuration, () {
      final overlay = Overlay.of(context);

      overlay.insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = (MediaQuery.of(context).size.height / 2) - 12.0;

    return Positioned(
      right: 0.0,
      bottom: height,
      child: _LogarteFAB(
        instance: instance,
        appBarTitle: appBarTitle ?? 'Developer Console',
      ),
    );
  }
}

class _LogarteFAB extends StatefulWidget {
  final Logarte instance;
  final String appBarTitle;

  const _LogarteFAB({
    required this.instance,
    required this.appBarTitle,
  });

  @override
  _LogarteFABState createState() => _LogarteFABState();
}

class _LogarteFABState extends State<_LogarteFAB> {
  bool _isOpened = false;
  OverlayEntry? _logOverlay;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _onPressed() async {
    if (_isOpened) {
      _logOverlay?.remove();
      _logOverlay = null;
    } else {
      _logOverlay = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black87,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black87,
              appBar: AppBar(
                backgroundColor: Colors.black87,
                centerTitle: false,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      _logOverlay?.remove();
                      setState(() {
                        _isOpened = false;
                      });
                    },
                  ),
                ],
                title: Text(widget.appBarTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white)),
              ),
              body: LogarteAuthScreen(widget.instance),
            ),
          ),
        ),
      );

      Overlay.of(context, rootOverlay: true).insert(_logOverlay!);
    }

    setState(() => _isOpened = !_isOpened);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      onDoubleTap: () {
        if (!_isOpened) {
          widget.instance.onRocketDoubleTapped?.call(context);
        }
      },
      onLongPress: () {
        if (!_isOpened) {
          widget.instance.onRocketLongPressed?.call(context);
        }
      },
      child: Container(
        width: 52.0,
        height: 52.0,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
          ),
        ),
        child: Icon(
          _isOpened ? Icons.close : Icons.rocket_launch_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
