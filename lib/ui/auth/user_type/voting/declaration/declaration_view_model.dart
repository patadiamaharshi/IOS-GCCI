
import 'package:flutter/material.dart';

import '../../../../../dialog/confirmation_dialog.dart';
import '../../../../../utils/app_strings.dart';

class DeclarationViewModel extends ChangeNotifier {
  final VoidCallback? onNext;
  bool isAccept = false;
  bool isLoading = false;

  final Map<String, dynamic> declarationResponse = {
    "declaration": {
      "details": '''
<p>Important points to be kept in mind by the applicant at the time of filling up the application form for GCCI Membership<br />
1.The applicant should fill the form in clear and legible writing.<br />
2. In case the office/ Factory/ Work address is provided by the applicant, it is compulsory to provide the proof of address.<br />
3. In case the names of the representatives mentioned by the applicant are not included in the Memorandum of Association, then they need to provide a self-attested copy of the Form 32 submitted to the Registrar of Companies notifying the names of the representatives.<br />
4. In case of corporate members if the names of the representatives are not included either in the Memorandum of Association or in Form 32, the applicant has to submit a nomination letter on the Company's letterhead.<br />
5. Forms which are partly filled, or which do not include the cheque for the required amount, will not be accepted.<br />
</p>

<table border="1">
<tr>
<th>Business Classification</th>
<th>Investment</th>
<th>Turnover</th>
</tr>

<tr>
<td>Micro</td>
<td>Upto 1 Crore</td>
<td>Upto 5 Crore</td>
</tr>

<tr>
<td>Small</td>
<td>Upto 10 Crore</td>
<td>Upto 50 Crore</td>
</tr>

<tr>
<td>Medium</td>
<td>Upto 50 Crore</td>
<td>Upto 250 Crore</td>
</tr>

<tr>
<td>Large</td>
<td>Above 50 Crore</td>
<td>Above 250 Crore</td>
</tr>

</table>
''',
    },
  };

  DeclarationViewModel({this.onNext, required BuildContext context}) {
    //getDeclarationDetails(context);
  }

  void setAccept(bool value) {
    isAccept = value;
    notifyListeners();
  }

  Future<void> next(context) async {
    DialogHelper.alertDialog(
      iconPath: "assets/check.png",
      btnString: AppStrings.ok,
      errorMessageHeading: "Registration Successful",
      errorMessageTitle:
          "Thank you for completing your registration. A GCCI representative will get in touch with you soon to guide you through the further process.",
      onClick: () {
        Navigator.pop(context);
        onNext?.call();
      },
    );
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getDeclarationDetails(BuildContext context) async {
    _setLoading(true);
    //final memberID = await Prefs.getData(SharedKeys.memberId);

    //final requestBody = ({"mid": memberID});

    try {
     /* final response = await ApiService.instance.post<dynamic>(
        "getDeclarationDetails",
        body: requestBody,
      );

      final res = response.data;*/
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }
}
