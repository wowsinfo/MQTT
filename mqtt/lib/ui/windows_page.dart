import 'package:flutter/material.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/provider/windows_provider.dart';
import 'package:mqtt/ui/game_info_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WindowsPage extends StatefulWidget {
  const WindowsPage({Key? key}) : super(key: key);

  @override
  State<WindowsPage> createState() => _WindowsPageState();
}

class _WindowsPageState extends State<WindowsPage> {
  final _provider = WindowsProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(Localisation.of(context).app_title),
              const VerticalDivider(),
              Tooltip(
                message: Localisation.of(context).tooltip_replay,
                child: TextButton.icon(
                  onPressed: () => _provider.showReplayFolder(),
                  icon: const Icon(Icons.folder),
                  label: Text(Localisation.of(context).replay),
                ),
              ),
              Consumer<WindowsProvider>(
                builder: (context, value, child) => Tooltip(
                  message: Localisation.of(context).tooltip_reload,
                  child: TextButton.icon(
                    onPressed:
                        value.canReload ? () => _provider.reload() : null,
                    icon: const Icon(Icons.refresh),
                    label: Text(Localisation.of(context).reload),
                  ),
                ),
              ),
              Tooltip(
                message: Localisation.of(context).tooltip_qr,
                child: TextButton.icon(
                  onPressed: () => _provider.showQRCode(context),
                  icon: const Icon(Icons.qr_code),
                  label: Text(Localisation.of(context).qr),
                ),
              ),
              TextButton.icon(
                onPressed: () =>
                    launchUrlString('https://github.com/wowsinfo/MQTT'),
                icon: const Icon(Icons.house),
                label: const Text('GitHub'),
              ),
            ],
          ),
        ),
        body: renderContent(),
        floatingActionButton: Tooltip(
          message: Localisation.of(context).settings,
          child: FloatingActionButton(
            onPressed: () => _provider.showSettings(context),
            child: const Icon(Icons.settings),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }

  Widget renderContent() {
    return Consumer<WindowsProvider>(
      builder: (context, value, child) {
        if (!value.hasValidPath) {
          return Center(
            child: ElevatedButton(
              child: Text(Localisation.of(context).error_invalid_replay_path),
              onPressed: () => _provider.showSettings(context),
            ),
          );
        }

        if (!value.hasValidServer) {
          return Center(
            child: ElevatedButton(
              child: Text(Localisation.of(context).error_invalid_server),
              onPressed: () => _provider.showSettings(context),
            ),
          );
        }

        return const GameInfoPage();
      },
    );
  }
}
