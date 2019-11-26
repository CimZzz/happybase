part of 'pages.dart';

class _BackgroundWidget extends StatelessWidget {
	_BackgroundWidget({Key key, this.builder}): super(key: key);

	final WidgetBuilder builder;

	@override
	Widget build(BuildContext context) {
		return Container(
			color: PageThemeWidget.of(context, aspect: ThemeKey.BgColor).bgColor,
			child: builder(context),
		);
	}
}

