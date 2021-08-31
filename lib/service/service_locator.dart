import 'package:aws_parameter_store/aws/aws_parameter_store.dart';
import 'package:aws_parameter_store/bloc/scroll_handler/scroll_handler_cubit.dart';
import 'package:aws_parameter_store/repository/aws_repository.dart';
import 'package:aws_parameter_store/repository/preferences_repository.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/app_bar.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/app_bar/widgets/add_button/add_button.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/column_view.dart';
import 'package:aws_parameter_store/ui/home_screen/widgets/column_view/widgets/parameter_column/parameter_column.dart';
import 'package:aws_parameter_store/ui/setup_screen/widgets/setup_list/setup_list.dart';
import 'package:aws_parameter_store/ui/setup_screen/widgets/setup_save_button/save_button.dart';

import '../main.dart';

class ServiceLocator {
  static void setSetupDependencies() {
    final preferences = PreferencesRepository();
    sl.registerSingleton<PreferencesRepository>(preferences);
    sl.registerSingleton<SetupListContext>(SetupListContext());
    sl.registerSingleton<SaveButtonContext>(SaveButtonContext());
  }

  static void setHomeDependencies() {
    final awsParameterStore = AWSParameterStore();
    sl.registerSingleton<AWSRepository>(AWSRepository(awsParameterStore));
    sl.registerSingleton<ScrollHandler>(ScrollHandler());

    sl.registerSingleton<AwsAppBarContext>(AwsAppBarContext());

    sl.registerSingleton<ParameterColumnContext>(ParameterColumnContext());

    var context = ColumnViewContext();
    sl.registerSingleton<ColumnViewContext>(context);

    sl.registerSingleton<AddButtonContext>(AddButtonContext());
  }
}
