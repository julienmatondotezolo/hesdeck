import 'package:hessdeck/services/actions/obs_actions.dart';

class ManageAcions {
  static Future<void> selectActions(String connectionType) async {
    switch (connectionType) {
      case 'OBS':
        OBSActions;
        break;
      default:
        throw Exception(
          'No ACTIONS for [$connectionType] exists in this services.',
        );
    }
  }
}
