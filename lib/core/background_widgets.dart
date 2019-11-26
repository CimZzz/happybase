part of 'pages.dart';

class _BackgroundWidget extends StatefulWidget {
	_BackgroundWidget({Key key}): super(key: key);

	@override
	_BackgroundState createState() {
		return _BackgroundState();
	}

}

class _BackgroundState extends State<_BackgroundWidget> {
	@override
	Widget build(BuildContext context) {
		return Container(
			color: PageThemeWidget.of(context, aspect: ThemeKey.BgColor).bgColor,
		);
	}
}

