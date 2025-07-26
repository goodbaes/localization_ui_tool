import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization_ui_tool/application/bloc/settings_cubit.dart';
import 'package:localization_ui_tool/core/use_cases/get_settings_use_case.dart';
import 'package:localization_ui_tool/presentation/widgets/toast.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            Toast.show(context, 'Settings saved!');
          }
        },
        builder: (context, state) {
          if (state is SettingsInitial) {
            context.read<SettingsCubit>().load();
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: const Text('ARB Directory'),
                    subtitle: Text(state.settings.directoryPath ?? 'Not set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.folder_open),
                      onPressed: () async {
                        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                        if (selectedDirectory != null) {
                          context.read<SettingsCubit>().update(
                            Settings(
                              directoryPath: selectedDirectory,
                              autoSave: state.settings.autoSave,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Auto Save'),
                    value: state.settings.autoSave,
                    onChanged: (value) {
                      context.read<SettingsCubit>().update(
                        Settings(
                          directoryPath: state.settings.directoryPath,
                          autoSave: value,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Error loading settings.'));
        },
      ),
    );
  }
}