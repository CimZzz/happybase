
import 'dart:async';

typedef TaskExecutor<T, Q> = Future<Q> Function(T);

/// 任务管线
class TaskPipeline {
	Map<dynamic, _Task> _taskMap;
	Map<dynamic, _Task> get _tasks {
		return _taskMap ??= Map();
	}

	void _remove(dynamic key) {
		if(_taskMap == null) {
			return null;
		}
		_taskMap.remove(key);
		if(_taskMap.isEmpty) {
			_taskMap = null;
		}
	}

	Future<Q> completeTask<T extends BaseTaskParams, Q>(TaskMixin<T, Q> taskMixin) {
		var task = _tasks[taskMixin.taskParams];
		if(task == null) {
			task = _Task<T, Q>();
			task.start();
			_tasks[taskMixin.taskParams] = task;
			task.execute(taskMixin.execute());
			task._completer.future.whenComplete((){
				_remove(taskMixin.taskParams);
			});
		}

		return task._completer.future;
	}

	Future<Q> completeCallback<T, Q>(T key, TaskExecutor<T, Q> executor) {
		var task = _tasks[key];
		if(task == null) {
			task = _Task<T, Q>();
			task.start();
			_tasks[key] = task;
			task.execute(executor(key));
			task._completer.future.whenComplete((){
				_remove(key);
			});

		}

		return task._completer.future;
	}

	void finishTask(dynamic key) {
		if(this._taskMap != null) {
			var task = _tasks[key];
			if(task != null) {
				task.stop();
			}
		}
	}
}

class _Task<T, Q> {
	Completer<Q> _completer;
	Completer<Q> _innerCompleter;

	void start() {
		_completer = Completer();
		_innerCompleter = Completer();
		_completer.complete(_innerCompleter.future);
	}

	void execute(Future<Q> realFuture) async {
		try {
			final result = await realFuture;
			if(_innerCompleter != null && !_innerCompleter.isCompleted) {
				_innerCompleter.complete(result);
			}
		}
		catch (e) {
			if(_innerCompleter != null && !_innerCompleter.isCompleted) {
				_innerCompleter.completeError(e);
			}
		}
	}

	void stop() {
		_innerCompleter.complete(null);
	}
}

abstract class BaseTaskParams {

}

mixin TaskMixin<T extends BaseTaskParams, Q> {
	T get taskParams;

	Future<Q> execute();
}