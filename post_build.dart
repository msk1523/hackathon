import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  final String pluginName = 'flutter_alarm_clock';
  final String pluginPathPattern =
      '*/.pub-cache/hosted/pub.dev/$pluginName-*/android/build.gradle';
  final List<FileSystemEntity> files = Directory('./')
      .listSync(recursive: true, followLinks: false)
      .where((entity) =>
          entity is File &&
          path.basename(entity.path) == "build.gradle" &&
          path.dirname(entity.path).contains(pluginName))
      .toList();

  if (files.isEmpty) {
    print('$pluginName build.gradle not found.');
    return;
  }
  final File file = File(files[0].path);

  print('Checking for existence of build.gradle at path: ${file.path}');

  if (file.existsSync()) {
    print('$pluginName build.gradle file exists');
    String content = file.readAsStringSync();
    print('$pluginName build.gradle content read successfully');

    if (!content.contains('namespace')) {
      print('Namespace does not exist, attempting to add it...');
      content = content.replaceFirst(
        'android {',
        'android {\n    namespace "com.example.$pluginName"',
      );
      file.writeAsStringSync(content);
      print('Namespace added to $pluginName/android/build.gradle');
    } else {
      print('Namespace already exists in $pluginName/android/build.gradle');
    }
  } else {
    print('$pluginName/android/build.gradle not found');
  }
}
