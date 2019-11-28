part of 'pages.dart';


abstract class PageWork<T extends PageInterface> {
	PageWork({this.pageInterface});

	final T pageInterface;

	Scope get scope => pageInterface.scope;
	TaskPipeline get taskPipeline => pageInterface.taskPipeline;

	void init();
	void destroy();
}