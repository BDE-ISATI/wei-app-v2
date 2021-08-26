import 'package:flutter/material.dart';
import 'package:isati_integration/models/is_form.dart';
import 'package:isati_integration/services/forms_service.dart';
import 'package:isati_integration/src/pages/administration/admin_forms_page/admin_form_page/widgets/admin_drawing_button.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class AdminFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserStore, AppUserStore>(
      builder: (context, userStore, appUserStore, child) {
        return Scaffold(
          appBar: IsAppBar(
            title: Text("Questionnaire de ${userStore.user.fullName}"),
          ),
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: FutureBuilder(
              future: FormsService.instance.getFormForUser(userStore.user.id!, authorization: appUserStore.authenticationHeader),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return IsStatusMessage(
                      title: "Erreur de chargement",
                      message: "Impossible de charger le formulaure : ${snapshot.error}",
                    );
                  }

                  final form = snapshot.data as IsForm;

                  return _buildForm(context, form);
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
        );
      },    
    );
  }

  Widget _buildForm(BuildContext context, IsForm form) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(child: _buildItem(context, "Score total", "${form.totalScore} point(s)")),
          const SizedBox(height: 20,),
          for (final qa in form.formQas) 
            Flexible(child: _buildItem(context, qa.question, qa.answer)),
          const SizedBox(height: 40,),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: ScreenUtils.instance.responsiveCrossAxisCount(context),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdminDrawingButton(media: form.drawing1,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdminDrawingButton(media: form.drawing2,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdminDrawingButton(media: form.drawing3,),
                ),
              ], 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, String answer) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0,),
        Text(answer),
        const SizedBox(height: 8.0,),
        Divider(color: colorPrimary,),
        const SizedBox(height: 8.0,)
      ],
    );
  }
}