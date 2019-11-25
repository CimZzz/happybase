import 'package:flutter/material.dart';
import 'package:quicklibs/quicklibs.dart';
import 'scope.dart';

part 'pages_manager.dart';
part 'background_widgets.dart';

enum _PageScopeId {
    Background,
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
                // background
                _Background(
                    parentScope: scope,
                ),
                super.build(context),
            ],

        );
    }

    void updateConstant(BackgroundBundle bundle) {
        if(bundle != null) {
            scope.dispatchSpecifiedMessage(_PageScopeId.Background, _PageScopeId.Background, bundle);
        }
    }
}

