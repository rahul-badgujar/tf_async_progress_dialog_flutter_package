import 'package:flutter/material.dart';

const _defaultDecoration = BoxDecoration(
  color: Colors.white,
  shape: BoxShape.rectangle,
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class TfAsyncProgressDialog<T> extends StatefulWidget {
  /// The async task till end of which the dialog will be shown.
  final Future<T> Function() future;

  /// decoration for the dialog
  final BoxDecoration? decoration;

  /// opacity of the dialog, defaults to 1.0
  final double opacity;

  /// custom progress widget, default to [CircularProgressIndicator]
  final Widget? progress;

  /// custom message widget
  final Widget? message;

  const TfAsyncProgressDialog(
    this.future, {
    Key? key,
    this.decoration,
    this.opacity = 1.0,
    this.progress,
    this.message,
  }) : super(key: key);

  @override
  State<TfAsyncProgressDialog> createState() => _TfAsyncProgressDialogState();
}

class _TfAsyncProgressDialogState extends State<TfAsyncProgressDialog> {
  @override
  void initState() {
    widget.future.call().then((val) {
      final result = <String, dynamic>{'success': true, 'value': val};
      Navigator.of(context).pop(result);
    }).catchError((e) {
      final result = <String, dynamic>{'success': false, 'value': e};
      Navigator.of(context).pop(result);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _buildDialog(context),
      onWillPop: () {
        return Future<bool>.value(false);
      },
    );
  }

  Widget _buildDialog(BuildContext context) {
    Widget content;
    if (widget.message == null) {
      content = Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: widget.decoration ?? _defaultDecoration,
          child: widget.progress ?? const CircularProgressIndicator(),
        ),
      );
    } else {
      content = Container(
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: widget.decoration ?? _defaultDecoration,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          widget.progress ?? const CircularProgressIndicator(),
          const SizedBox(width: 20),
          _buildText(context)
        ]),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Opacity(
        opacity: widget.opacity,
        child: content,
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    if (widget.message == null) {
      return const SizedBox.shrink();
    }
    return Expanded(
      flex: 1,
      child: widget.message!,
    );
  }
}
