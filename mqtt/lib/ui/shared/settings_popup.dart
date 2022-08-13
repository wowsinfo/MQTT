import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/ui/shared/alert.dart';
import 'package:mqtt/ui/shared/max_width_box.dart';

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

  @override
  void initState() {
    super.initState();
    _path = AppRepository.instance.replayFolder;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Game replay folder'),
              subtitle: Text(_path ?? 'Click to pick folder'),
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
                      message: 'The path should contain "replays"',
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
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
