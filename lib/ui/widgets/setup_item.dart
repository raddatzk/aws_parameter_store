import 'package:flutter/material.dart';

class SetupItem extends StatefulWidget {
  const SetupItem({Key? key, required this.onDelete, this.bucketName, this.bucketUrl, this.awsProfile, required this.onChanged}) : super(key: key);

  final void Function() onDelete;
  final void Function() onChanged;
  final String? bucketName;
  final String? bucketUrl;
  final String? awsProfile;

  @override
  SetupItemState createState() => SetupItemState();
}

class SetupItemState extends State<SetupItem> {
  late final TextEditingController bucketNameController;
  late final TextEditingController bucketUrlController;
  late final TextEditingController awsProfileController;

  @override
  void initState() {
    super.initState();
    bucketNameController = TextEditingController(text: widget.bucketName);
    bucketUrlController = TextEditingController(text: widget.bucketUrl);
    awsProfileController = TextEditingController(text: widget.awsProfile);
  }

  bool complete() => bucketNameController.text.isNotEmpty && bucketUrlController.text.isNotEmpty && awsProfileController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    TextField(
                      controller: bucketNameController,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "name of this bucket",
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        isDense: true,
                      ),
                      onChanged: (value) => widget.onChanged(),
                    ),
                    TextField(
                      controller: bucketUrlController,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "url of the bucket",
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        isDense: true,
                      ),
                      onChanged: (value) => widget.onChanged(),
                    ),
                    TextField(
                      controller: awsProfileController,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "name of the configured aws profile",
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        isDense: true,
                      ),
                      onChanged: (value) => widget.onChanged(),
                    ),
                  ],
                ),
              ),
              TextButton(
                child: const Icon(Icons.remove_circle_outline),
                onPressed: widget.onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}