import 'package:flutter/material.dart';
import 'package:hessdeck/providers/connection_provider.dart';
import 'package:hessdeck/services/connections/stream_elements_connections.dart';
import 'package:stream_elements_package/stream_elements.dart';

const selectOverlayMethod = 'Select overlay';
const updateOverlayMethod = 'Update overlay';

class StreamElementsMethodMetadata {
  final List<String> parameterNames;

  StreamElementsMethodMetadata(this.parameterNames);
}

class StreamElementsActions {
  static Future<String?> selectOverlay(BuildContext context) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;

    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        Map<String, dynamic> response = await streamElements!.getAllOverlays();
        final overlayList = response['docs']
            .map<Map<String, dynamic>>((overlay) => {
                  '_id': overlay['_id'],
                  'type': overlay['type'],
                  'name': overlay['name'],
                })
            .toList();

        if (overlayList != null && overlayList.isNotEmpty) {
          return await showModalBottomSheet<String>(
            context: context,
            builder: (context) {
              return ListView.builder(
                itemCount: overlayList.length,
                itemBuilder: (context, int index) {
                  String name = overlayList[index]['name'];
                  String id = overlayList[index]['_id'];
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      Navigator.pop(context, id);
                    },
                  );
                },
              );
            },
          );
        }
      } catch (e) {
        throw Exception('Error getting overlays: $e');
      }
    }
    return null;
  }

  static Future<void> updateOverlay(
      BuildContext context, String overlayId, Object body) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;
    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        final response =
            await streamElements!.updateOverlayByID(overlayId, body);
        print('UPDATE OVERLLAY: $response');
      } catch (e) {
        throw Exception('Error updating overlays: $e');
      }
    }
  }

  static Future<void> getAllOverlays(BuildContext context) async {
    StreamElements? streamElements =
        connectionProvider(context).streamElementsClient;
    if (await StreamElementsConnections.checkIfConnectedToStreamElements(
        context, streamElements)) {
      try {
        Map<String, dynamic> response = await streamElements!.getAllOverlays();
        final data = response['docs']
            .map<Map<String, dynamic>>((overlay) => {
                  '_id': overlay['_id'],
                  'type': overlay['type'],
                  'name': overlay['name'],
                })
            .toList();

        print('data: $data');
      } catch (e) {
        throw Exception('Error getting overlays: $e');
      }
    }
  }

  static final Map<String, StreamElementsMethodMetadata>
      streamElementsMethodMetadata = {
    selectOverlayMethod: StreamElementsMethodMetadata([]),
    updateOverlayMethod: StreamElementsMethodMetadata([selectOverlayMethod]),
  };
}

typedef StreamElementsMethod = Function(BuildContext, String);

final Map<String, StreamElementsMethod> streamElementsMethods = {
  updateOverlayMethod: (
    BuildContext context,
    String overlayId,
  ) async {
    return await StreamElementsActions.updateOverlay(context, overlayId, "");
  },
};

final Map<String, StreamElementsMethod> streamElementsMethodParameters = {
  selectOverlayMethod: (
    BuildContext context,
    String overlayId,
  ) async {
    return await StreamElementsActions.selectOverlay(context);
  }
};
