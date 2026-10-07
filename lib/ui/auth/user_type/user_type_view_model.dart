import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/voting/register_voting.dart';
import '../../../helper/shared_keys.dart';
import '../../../network/api_service/api_service.dart';
import '../../../utils/pref_helper.dart';
import 'association/association.dart';
import 'non_voting/register_non_voting.dart';

class UserTypeViewModel extends ChangeNotifier {
  final int repCount;
  bool isLoading = false;
  List<dynamic> type = [];

  UserTypeViewModel({required this.repCount});

  Future<void> loadInitialData(BuildContext context) async {
    await getTypeOfMemberShipList(context);
  }

  Future<void> getTypeOfMemberShipList(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<dynamic>(
       // context,
        "typeOfMembershipList",
      );

      type = response.data['TypeOfMembership'] ?? [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> voting(BuildContext context, String? type) async {
    selectMemberShip(context, type);
  }

  Future<void> selectMemberShip(BuildContext context, String? type) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID, "type_of_membership": type});

    debugPrint("selectMemberShip Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "selectMembership",
        body: requestBody,
      );

      final data = response.data ?? [];

      final message = data?['selectMembership']?[0]?['msg']?.toString();
      if (!context.mounted) return;

      if (message == "SUCCESS") {
        if (type == "Voting") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterVotingScreen(repCount: repCount)),
          );
        } else if (type == "Non-Voting") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RegisterNonVotingScreen(repCount: repCount)),
          );
        } else if (type == "Association") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Association(repCount: repCount)));
        }else{
          debugPrint("--- type --- $type");
          debugPrint("--- type --- else");
        }
        debugPrint("SUCCESS");
      } else {
        debugPrint("FAIL");
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

}
