import 'package:flutter/material.dart';
import 'package:quicklibs/quicklibs.dart';
import 'scope.dart';

part 'pages_manager.dart';
part 'theme_widgets.dart';
part 'background_widgets.dart';

enum PageScopeMessageKey {
    Theme,
}

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
        final themeBundle = castTo<ThemeBundle>(activeMessageMap.containsKey(PageScopeMessageKey.Theme));
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
        return PageThemeWidget (
            _themeBundle,
            child: widget.child,
        );
    }
}




abstract class Page extends ScopeWidget {
    Page(this.name);
    final String name;

    void show(BuildContext context) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => this));
    }
}

abstract class PageState<WidgetType extends ScopeWidget> extends GeneralScopeState<WidgetType> {
    PageState.create(Scope parentScope) : super.create(parentScope);

    ThemeBundle _themeBundle = ThemeBundle();

    @override
    void initState() {
        super.initState();
        PageManager._addPageContext(this);
    }

    @override
    void dispose() {
        super.dispose();
        PageManager._removePageContext(this);
    }

    @override
    Widget build(BuildContext context) {
        return Stack(
            children: <Widget>[
                _BackgroundWidget(),
                createChild(context)
            ],
        );
    }

    void updateTheme(ThemeBundle bundle) {
        setState(() {
            _themeBundle = _themeBundle.and(bundle);
        });
    }
}

