import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/stream_elements_connections.dart';
import 'package:stream_elements_package/stream_elements.dart';

const getAllOverlaysMethod = 'Get all overlays';
const updateOverlayMethod = 'Update overlay';

class StreamElementsMethodMetadata {
  final List<String> parameterNames;

  StreamElementsMethodMetadata(this.parameterNames);
}

class StreamElementsActions {
  static Future<void> getAllOverlays(BuildContext context) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;
    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        Map<String, dynamic> overlays = await streamElements!.getAllOverlays();

        debugPrint('[STREAM ELEMENTS OVERLAYS]: $overlays');
      } catch (e) {
        throw Exception('Error getting overlays: $e');
      }
    }
  }

  static final Map<String, StreamElementsMethodMetadata>
      streamElementsMethodMetadata = {
    getAllOverlaysMethod: StreamElementsMethodMetadata([]),
    updateOverlayMethod: StreamElementsMethodMetadata([]),
  };
}

typedef StreamElementsMethod = Function(BuildContext, String);

final Map<String, StreamElementsMethod> streamElementsMethods = {
  getAllOverlaysMethod: (
    BuildContext context,
    String sceneName,
  ) async {
    StreamElementsActions.getAllOverlays(context);
  }
};
