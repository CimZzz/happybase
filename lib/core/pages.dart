import 'package:flutter/material.dart';
import 'package:taskpipeline/taskpipeline.dart';
import 'package:quicklibs/quicklibs.dart';
import 'scope.dart';

part 'pages_manager.dart';
part 'theme_widgets.dart';
part 'page_work.dart';
part 'page_root.dart';

enum PageScopeMessageKey {
    Theme,
}

mixin PageInterface {
    TaskPipeline get taskPipeline;
    GeneralScope get scope;
    void updateTheme(ThemeBundle bundle);
    void updateWidget();
    Future<T> showPageDialog<T>({
        bool barrierDismissible = true,
        WidgetBuilder builder,
    });
    void backPage();
}


abstract class Page extends ScopeWidget {
    Page(this.name);
    final String name;

    void show(BuildContext context) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => this));
    }
}

abstract class PageState<WidgetType extends Page> extends GeneralScopeState<WidgetType> {
    PageState.create(Scope parentScope) : super.create(parentScope);

    TaskPipeline _taskPipeline;
    TaskPipeline get taskPipeline => this._taskPipeline ??= TaskPipeline();

    PageWork _pageWork;
    PageWork get pageWork {
        return this._pageWork ?? createPageWork();
    }

    ThemeBundle _themeBundle = ThemeBundle();

    @override
    void initState() {
        super.initState();
        PageManager._addPageContext(this);
        pageWork?.init();
    }

    @override
    void dispose() {
        super.dispose();
        PageManager._removePageContext(this);
        _taskPipeline?.destroy();
        pageWork?.destroy();
    }

    @override
    Widget build(BuildContext context) {
        return createChild(context);
    }

    PageWork createPageWork() {
        return null;
    }

    void updateTheme(ThemeBundle bundle) {
        scope.proxySync(() {
            setState(() {
                _themeBundle = _themeBundle.and(bundle);
            });
        });
    }

    void updateWidget() {
        scope.proxySync(() {
            setState((){});
        });
    }

    Future<T> showPageDialog<T>({
        bool barrierDismissible = true,
        WidgetBuilder builder,
    }) {
        return scope.proxyAsync(() {
            return taskPipeline.execInnerTask(
                leafExec: () => showDialog<T>(
                    context: this.context,
                    barrierDismissible: barrierDismissible,
                    builder: builder
                )
            );
        });
    }
    
    void backPage() {
        scope.proxySync((){
            PageManager.popUntil(this.widget.name, this.context);
        });
    }
}

