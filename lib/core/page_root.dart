part of 'pages.dart';

class PageRoot extends StatefulWidget {
	PageRoot({Key key, this.child, this.theme = ThemeBundle.defaultTheme}): super(key: key);
	final Widget child;
	final ThemeBundle theme;

	@override
	_PageRootState createState() => _PageRootState();
}

class _PageRootState extends State<PageRoot> {
	Scope get scope => Scope.rootScope;

	ThemeBundle _themeBundle;

	@override
	void initState() {
		super.initState();
		_themeBundle = widget.theme;
		scope.registerActiveDelayCallback(onReceiverActiveDelayMessage);
	}

	void onReceiverActiveDelayMessage(Map<dynamic, dynamic> activeMessageMap) {
		var isUpdated = false;
		final themeBundle = castTo<ThemeBundle>(activeMessageMap[PageScopeMessageKey.Theme]);
		if(themeBundle != null) {
			isUpdated = true;
			_themeBundle = _themeBundle.and(themeBundle);
		}

		if(isUpdated) {
			setState(() {});
		}
	}

	@override
	Widget build(BuildContext context) {
		return PageTheme (
			_themeBundle,
			child: widget.child,
		);
	}
}

