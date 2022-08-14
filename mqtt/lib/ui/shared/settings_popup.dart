import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/ui/shared/alert.dart';
import 'package:mqtt/ui/shared/dropdown_list_tile.dart';

void showSettingsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const _SettingsPopup(),
  );
}

class _SettingsPopup extends StatefulWidget {
  const _SettingsPopup({Key? key}) : super(key: key);

  @override
  State<_SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<_SettingsPopup> {
  String? _path;
  String? _server;

  @override
  void initState() {
    super.initState();
    _path = AppRepository.instance.replayFolder;
    _server = AppRepository.instance.gameServer;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Localisation.of(context).settings),
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(Localisation.of(context).game_replay_folder),
              subtitle: Text(_path ?? Localisation.of(context).pick_folder),
              onTap: () {
                FilePicker.platform
                    .getDirectoryPath(initialDirectory: _path)
                    .then((path) {
                  if (path == null) {
                    // nothing is picked here
                    return;
                  }

                  // do a simple validation
                  if (!path.contains('replays')) {
                    showErrorAlert(
                      context,
                      message: Localisation.of(context).error_no_replay_in_path,
                    );
                    return;
                  }

                  AppRepository.instance.replayFolder = path;
                  setState(() {
                    _path = path;
                  });
                });
              },
            ),
            DropdownListTile<String?>(
              options: [
                DropdownValue(
                  value: null,
                  title: Localisation.of(context).server_selection,
                ),
                DropdownValue(
                  value: 'asia',
                  title: Localisation.of(context).server_asia,
                ),
                DropdownValue(
                  value: 'eu',
                  title: Localisation.of(context).server_eu,
                ),
                DropdownValue(
                  value: 'na',
                  title: Localisation.of(context).server_na,
                ),
                DropdownValue(
                  value: 'ru',
                  title: Localisation.of(context).server_ru,
                ),
              ],
              title: Text(Localisation.of(context).game_server),
              value: _server,
              onChanged: (String? value) {
                AppRepository.instance.gameServer = value;
                setState(() {
                  _server = value;
                });
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(Localisation.of(context).close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
