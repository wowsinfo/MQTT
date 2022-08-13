import 'package:flutter/material.dart';

class DropdownValue<T> {
  const DropdownValue({
    required this.value,
    required this.title,
  });

  final String title;
  final T value;
}

/// A customised [ListTile] that displays a dropdown menu in the subtitle.
class DropdownListTile<T> extends StatelessWidget {
  const DropdownListTile({
    Key? key,
    required this.options,
    required this.value,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  final List<DropdownValue<T>> options;
  final T value;
  final Widget title;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    GlobalKey? dropdownButtonKey = GlobalKey();

    void openDropdown() {
      GestureDetector? detector;

      /// Find the button that opens the dropdown
      void searchForGestureDetector(BuildContext? element) {
        element?.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector?;
          } else {
            searchForGestureDetector(element);
          }
        });
      }

      searchForGestureDetector(dropdownButtonKey.currentContext);
      assert(detector != null, 'Dropdown button not found');

      detector?.onTap?.call();
    }

    // PopupMenuButton should be used instead
    return ListTile(
      onTap: () => openDropdown(),
      title: title,
      subtitle: AbsorbPointer(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            key: dropdownButtonKey,
            isExpanded: true,
            isDense: true, // shrink the dropdown button
            focusColor: Colors.transparent, // hides the focus within dropdown
            value: value,
            items: options
                .map((e) =>
                    DropdownMenuItem<T>(value: e.value, child: Text(e.title)))
                .toList(growable: false),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
