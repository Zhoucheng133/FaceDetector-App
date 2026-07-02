import 'dart:io';

import 'package:path/path.dart' as p;

String getDetectorPath(){
  return p.join(
    p.dirname(Platform.resolvedExecutable), 
    Platform.isWindows ? "detector.exe" : "detector"
  );
}

String getModelPath(){
  if(Platform.isWindows){
    return p.join(
      p.dirname(Platform.resolvedExecutable), 
      "model.tflite"
    );
  }else{
    final executableDir = p.dirname(Platform.resolvedExecutable);
    final resourcesDir = p.join(p.dirname(executableDir), 'Resources');
    return p.join(resourcesDir, "model.tflite");
  }
}