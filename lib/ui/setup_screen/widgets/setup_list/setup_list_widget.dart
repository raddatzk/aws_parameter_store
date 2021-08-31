import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setup_list.dart';
import 'widgets/setup_item.dart';

class SetupList extends StatefulWidget {
  SetupList({Key? key}) : super(key: key);

  final PreferencesRepository repository = sl<PreferencesRepository>();

  @override
  SetupListState createState() => SetupListState();
}

class SetupListState extends State<SetupList> {
  @override
  void initState() {
    super.initState();
    sl<SetupListContext>().setItems(widget.repository.getNames().map(_createNewItemFromBucket).toList());
    WidgetsBinding.instance!.addPostFrameCallback((_) => sl<SetupListContext>().refresh());
  }

  SetupItemWithKey _createNewItemFromBucket(String bucketName) {
    final bucket = widget.repository.getBucketByName(bucketName);
    return _createNewItem(bucketName: bucketName, bucketUrl: bucket.url, awsProfile: bucket.awsProfile);
  }

  SetupItemWithKey _createNewItem({String? bucketName, String? bucketUrl, String? awsProfile}) {
    final key = GlobalKey<SetupItemState>();
    SetupItem? item;
    item = SetupItem(
      onChanged: () => sl<SetupListContext>().refresh(),
      key: key,
      onDelete: () => sl<SetupListContext>().deleteItem(item!),
      bucketName: bucketName,
      bucketUrl: bucketUrl,
      awsProfile: awsProfile,
    );
    return SetupItemWithKey(item, key);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.repository.hasBuckets()
                          ? "update your configured buckets"
                          : "seems like you are new here. please enter the name of the configured aws profile and give the bucket a nice name",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("help"),
                          content: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: "you need the "),
                                TextSpan(text: "aws region", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ", "),
                                TextSpan(text: "access-key", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ", "),
                                TextSpan(text: "secret-access-key", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: " and "),
                                TextSpan(text: "bucket", style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: " to configure for each bucket a profile and then assign the credentials to the profile. to add a profile, issue "),
                                TextSpan(text: "aws configure --profile <profile-name>", style: TextStyle(fontStyle: FontStyle.italic)),
                                TextSpan(
                                    text: " and enter the parameters (you might ignore the last parameter). \n\n"
                                        "on this screen you can configure the buckets you want to use, each bucket needs a nice name and the corresponding profile you configured earlier"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("okay"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: BlocBuilder<SetupListContext, SetupListContextState>(
                    bloc: sl<SetupListContext>(),
                    builder: (context, state) {
                      return ListView(
                        children: [
                          ...state.items.map((e) => e.item).toList(),
                          TextButton(
                            child: const Icon(Icons.add_circle_outline),
                            onPressed: () => sl<SetupListContext>().addItem(_createNewItem()),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
