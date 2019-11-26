import 'package:flutter/material.dart';
import 'package:quicklibs/quicklibs.dart';
import 'scope.dart';

part 'pages_manager.dart';
part 'theme_widgets.dart';
part 'background_widgets.dart';

enum PageScopeMessageKey {
    Theme,
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
        scope.registerMessageCallback(PageScopeMessageKey.Theme, (data) async {
            if(data is ThemeBundle) {
                scope.proxySync(() {
                    updateConstant(data);
                });
            }
        });
    }

    @override
    void dispose() {
        super.dispose();
        PageManager._removePageContext(this);
    }

    @override
    Widget build(BuildContext context) {
        return PageThemeWidget (
            _themeBundle,
            child: _BackgroundWidget(
                builder: createChild,
            ),
        );
    }

    void updateConstant(ThemeBundle bundle) {
        setState(() {
            _themeBundle = _themeBundle.and(bundle);
        });
    }
}

