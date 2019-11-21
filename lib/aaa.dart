import 'dart:async';

import 'package:happybase/core/task_pipeline.dart';



void main() async {
	final pipeline = TaskPipeline();

	Future.delayed(const Duration(seconds: 2), (){
		pipeline.finishTask(123);
	});

	final future1 = pipeline.completeCallback(123, (int data) async {
		await Future.delayed(const Duration(seconds: 5));
		return 20;
	});

	final future2 = pipeline.completeCallback(123, (int data) async {
		await Future.delayed(const Duration(seconds: 50));
		return 20;
	});

	final result1 = await future1;
	print("result1: $result1");
	final result2 = await future2;
	print("result2: $result2");
}