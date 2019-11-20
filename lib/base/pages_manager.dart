part of 'pages.dart';

class PageManager {
	PageManager._();
	static List<PageState> _pageContextStack;

	static BuildContext get _rootPageContext {
		if(_pageContextStack == null)
			return null;
		return _pageContextStack.last.context;
	}

	static void _addPageContext(PageState state) {
		_pageContextStack ??= List();
		_pageContextStack.add(state);
	}

	static void _removePageContext(PageState state) {
		if(_pageContextStack != null) {
			_pageContextStack.remove(state);
		}
	}

	static Future<T> routeTo<T>(Page page, {BuildContext context}) {
		final existContext = context ?? _rootPageContext;
		if(existContext == null) {
			return null;
		}

		return Navigator.push(existContext, MaterialPageRoute<T>(builder: (context) => page, settings: RouteSettings(name: page.name)));
	}

	static void pop<T>([BuildContext context, T result]) {
		final existContext = context ?? _rootPageContext;
		if(existContext == null) {
			return null;
		}

		Navigator.pop(existContext, result);
	}

	static void popUntil<T>(String routeName, [BuildContext context]) {
		final existContext = context ?? _rootPageContext;
		if(existContext == null) {
			return null;
		}

		Navigator.popUntil(existContext, ModalRoute.withName(routeName));
	}

	static void popInclude<T>(String routeName, [BuildContext context]) {
		final existContext = context ?? _rootPageContext;
		if(existContext == null) {
			return null;
		}
		final modalRoute = ModalRoute.withName(routeName);

		Navigator.popUntil(existContext, modalRoute);
		Navigator.pop(existContext);
	}
}