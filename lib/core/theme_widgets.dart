part of 'pages.dart';

enum ThemeKey {
	BgColor,
}

class ThemeBundle {
    ThemeBundle({this.bgColor});
    ThemeBundle and(ThemeBundle otherBundle) {
    	if(otherBundle == null) {
    		return otherBundle;
	    }

    	return ThemeBundle(
		    bgColor: otherBundle.bgColor ?? this.bgColor
	    );
    }
	final Color bgColor;
}

class PageThemeWidget extends InheritedModel<ThemeKey> {
	PageThemeWidget(ThemeBundle bundle, {Widget child}):
		bgColor = bundle?.bgColor,
		super(child: child);

	final Color bgColor;

	@override
	bool updateShouldNotify(PageThemeWidget oldWidget) {
		return this.bgColor != oldWidget.bgColor;
	}

	@override
	bool updateShouldNotifyDependent(PageThemeWidget oldWidget, Set<ThemeKey> dependencies) {
		if(dependencies.contains(ThemeKey.BgColor) && bgColor != oldWidget.bgColor) {
			return true;
		}
		return false;
	}


	static PageThemeWidget of(BuildContext context, {ThemeKey aspect}) {
		return InheritedModel.inheritFrom<PageThemeWidget>(context, aspect: aspect);
	}
}
