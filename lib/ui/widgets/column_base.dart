import 'package:flutter/material.dart';

class ColumnBase extends StatelessWidget {
  final List<String> keys;
  final String? selectedKey;
  final void Function(String) onTap;
  final double width;
  final IconData leadingIcon;

  const ColumnBase({Key? key, required this.keys, this.selectedKey, required this.onTap, required this.width, required this.leadingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          final selected = selectedKey != null ? keys[index] == selectedKey : false;
          return GestureDetector(
            onTap: () => onTap(keys[index]),
            child: Card(
              color: selected ? Colors.grey : Theme.of(context).canvasColor,
              elevation: selected ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(leadingIcon, size: 15),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: width - 60,
                      child: Tooltip(
                        message: keys[index],
                        child: Text(
                          keys[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
