// Dart imports:
import 'dart:io';

// Project imports:
import 'package:zego_live/logger.dart';

String? getIconSource(String? iconFileName) {
  String? iconSource;

  if (Platform.isAndroid && (iconFileName?.isNotEmpty ?? false)) {
    var targetIconFileName = iconFileName ?? '';
    final postfixIndex = targetIconFileName.indexOf('.');
    if (-1 != postfixIndex) {
      targetIconFileName = targetIconFileName.substring(0, postfixIndex);
    }

    iconSource = 'resource://drawable/$targetIconFileName';

    ZegoLiveLogger.logInfo(
      "icon file, config name:${iconFileName ?? ""}, "
      'file name:$targetIconFileName, source:$iconSource',
      tag: 'live',
      subTag: 'offline',
    );
  }

  return iconSource;
}

String? getSoundSource(String? soundFileName) {
  String? soundSource;

  if (Platform.isAndroid && (soundFileName?.isNotEmpty ?? false)) {
    var targetSoundFileName = soundFileName ?? '';
    final postfixIndex = targetSoundFileName.indexOf('.');
    if (-1 != postfixIndex) {
      targetSoundFileName = targetSoundFileName.substring(0, postfixIndex);
    }

    soundSource = 'resource://raw/$targetSoundFileName';

    ZegoLiveLogger.logInfo(
      "sound file, config name:${soundFileName ?? ""}, "
      'file name:$targetSoundFileName, source:$soundSource',
      tag: 'live',
      subTag: 'offline',
    );
  }

  return soundSource;
}
