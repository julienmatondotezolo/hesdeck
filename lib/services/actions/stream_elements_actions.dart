import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:stream_elements_package/stream_elements.dart';

const getAllOverlaysMethod = 'Get all overlays';
const updateOverlayMethod = 'Update overlay';

class StreamElementsMethodMetadata {
  final List<String> parameterNames;

  StreamElementsMethodMetadata(this.parameterNames);
}

class StreamElementsActions {
  static Future<void> getAllOverlays(BuildContext context) async {
    try {
      StreamElements? streamElements =
          connectionProvider(context).streamElementsClient;
      final overlays = streamElements!.getAllOverlays;

      debugPrint('[STREAM ELEMENTS OVERLAYS]: $overlays');
    } catch (e) {
      throw Exception('Error getting overlays: $e');
    }
  }

  static final Map<String, StreamElementsMethodMetadata>
      streamElementsMethodMetadata = {
    getAllOverlaysMethod: StreamElementsMethodMetadata([]),
    updateOverlayMethod: StreamElementsMethodMetadata([]),
  };

  List<String> getMethodParameters(String methodName) {
    return StreamElementsMethodMetadata[methodName]?.parameterNames ?? [];
  }
}

typedef StreamElementsMethod = Function(BuildContext, String);

final Map<String, StreamElementsMethod> streamElementsMethods = {
  //
};
