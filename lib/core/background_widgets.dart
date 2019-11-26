part of 'pages.dart';

class _BackgroundWidget extends StatelessWidget {
	_BackgroundWidget({Key key, this.child}): super(key: key);

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			color: PageThemeWidget.of(context, aspect: ThemeKey.BgColor).bgColor,
			child: child,
		);
	}
}

