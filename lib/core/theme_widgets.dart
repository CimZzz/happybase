part of 'pages.dart';

enum ThemeKey {
	BgColor,
}

class ThemeBundle {
    const ThemeBundle({this.bgColor});
    ThemeBundle and(ThemeBundle otherBundle) {
    	if(otherBundle == null) {
    		return otherBundle;
	    }

    	return ThemeBundle(
		    bgColor: otherBundle.bgColor ?? this.bgColor
	    );
    }

    static const ThemeBundle defaultTheme = const ThemeBundle();

	final Color bgColor;
}

class PageTheme extends InheritedModel<ThemeKey> {
	PageTheme(ThemeBundle bundle, {Widget child}):
		bgColor = bundle?.bgColor,
		super(child: child);

	final Color bgColor;

	@override
	bool updateShouldNotify(PageTheme oldWidget) {
		return this.bgColor != oldWidget.bgColor;
	}

	@override
	bool updateShouldNotifyDependent(PageTheme oldWidget, Set<ThemeKey> dependencies) {
		if(dependencies.contains(ThemeKey.BgColor) && bgColor != oldWidget.bgColor) {
			return true;
		}
		return false;
	}


	static PageTheme of(BuildContext context, {ThemeKey aspect}) {
		return InheritedModel.inheritFrom<PageTheme>(context, aspect: aspect);
	}

	static Color bgColorOf(BuildContext context) {
		return of(context, aspect: ThemeKey.BgColor).bgColor;
	}
}
