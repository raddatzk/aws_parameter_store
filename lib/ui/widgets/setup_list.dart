import 'package:aws_parameter_store/bloc/setup_items/setup_items_cubit.dart';
import 'package:aws_parameter_store/main.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setup_item.dart';

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
    sl<SetupItemsCubit>().setItems(widget.repository.getNames().map(_createNewItemFromBucket).toList());
    WidgetsBinding.instance!.addPostFrameCallback((_) => sl<SetupItemsCubit>().refresh());
  }

  SetupItemWithKey _createNewItemFromBucket(String bucketName) {
    final bucket = widget.repository.getBucketByName(bucketName);
    return _createNewItem(bucketName: bucketName, bucketUrl: bucket.url, awsProfile: bucket.awsProfile);
  }

  SetupItemWithKey _createNewItem({String? bucketName, String? bucketUrl, String? awsProfile}) {
    final key = GlobalKey<SetupItemState>();
    SetupItem? item;
    item = SetupItem(
      onChanged: () => sl<SetupItemsCubit>().refresh(),
      key: key,
      onDelete: () => sl<SetupItemsCubit>().deleteItem(item!),
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
              widget.repository.hasBuckets()
                  ? const Text("update your configured buckets", textAlign: TextAlign.center)
                  : const Text("seems like you are new here. please enter the name of the configured aws profile and give the bucket a nice name", textAlign: TextAlign.center),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: BlocBuilder<SetupItemsCubit, SetupItemsState>(
                    bloc: sl<SetupItemsCubit>(),
                    builder: (context, state) {
                      return ListView(
                        children: [
                          ...state.items.map((e) => e.item).toList(),
                          TextButton(
                            child: const Icon(Icons.add_circle_outline),
                            onPressed: () => sl<SetupItemsCubit>().addItem(_createNewItem()),
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
