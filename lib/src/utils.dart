import 'package:flutter/material.dart';
import 'package:tf_async_progress_dialog/src/tf_async_progress_dialog_impl.dart';

/// Function to show a [TfAsyncProgressDialog].
///
/// Returns the result of async task.
///
/// If async task  fails due to exception, the same exception will be thrown from this method.
Future<T> showAsyncProgressDialog<T>({
  required BuildContext context,
  required TfAsyncProgressDialog<T> dialog,
}) async {
  // the [TfAsyncProgressDialog] returns a map with status and value
  final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          return dialog;
        },
        barrierDismissible: false,
      ) ??
      <String, dynamic>{};
  // extract states
  final success = result['success'] ?? false;
  final value = result['value'];
  // if there occured no exception while executing async task
  if (success) {
    // the value is the result of async task in this case
    assert(value is T,
        'The value type returned by async process does not match with type argument provided.');
    return value;
  } else {
    // if not success, then value returned is the exception thrown by the async task
    throw value;
  }
}
