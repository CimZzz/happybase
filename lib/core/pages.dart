import 'package:flutter/material.dart';
import 'package:taskpipeline/taskpipeline.dart';
import 'package:quicklibs/quicklibs.dart';
import 'scope.dart';

part 'pages_manager.dart';
part 'theme_widgets.dart';
part 'page_work.dart';
part 'page_root.dart';

mixin InnerPageInterface {
    TaskPipeline get taskPipeline;
    GeneralScope get scope;
    BuildContext get context;
    void updateWidget();
    Future<T> showPageDialog<T>({
        bool barrierDismissible = true,
        WidgetBuilder builder,
    });
}

abstract class InnerPage extends ScopeWidget {
    InnerPage({Key key, Scope parentScope}) : super(key: key, parentScope: parentScope);

    @override
    InnerPageState createState();
}

abstract class InnerPageState<WidgetType extends InnerPage> extends GeneralScopeState<WidgetType> {
    InnerPageState.create(Scope parentScope, { String scopeName, dynamic scopeId }) : super.create(parentScope, scopeName: scopeName, scopeId: scopeId);

    TaskPipeline _taskPipeline;
    TaskPipeline get taskPipeline => this._taskPipeline ??= TaskPipeline();

    PageWork _pageWork;
    PageWork get pageWork {
        return this._pageWork ?? createPageWork();
    }

    @override
    @mustCallSuper
    void initState() {
        pageWork?.init();
        super.initState();
    }

    @override
    @mustCallSuper
    void dispose() {
        _taskPipeline?.destroy();
        pageWork?.destroy();
        super.dispose();
    }

    PageWork createPageWork() {
        return null;
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
}

mixin PageInterface implements InnerPageInterface {
    void backPage();
    void closeDirectly({dynamic result});
}

abstract class Page extends InnerPage {
    Page(this.name, {Key key, Scope parentScope}) : super(key: key, parentScope: parentScope);
    final String name;

    @override
    PageState createState();
}

abstract class PageState<WidgetType extends Page> extends InnerPageState<WidgetType> {
    PageState.create(Scope parentScope, { String scopeName, dynamic scopeId }) : super.create(parentScope, scopeName: scopeName, scopeId: scopeId);

    @override
    @mustCallSuper
    void initState() {
        PageManager._addPageContext(this);
        super.initState();
    }

    @override
    @mustCallSuper
    void dispose() {
        PageManager._removePageContext(this);
        super.dispose();
    }
    
    void backPage() {
        scope.proxySync((){
            PageManager.popUntil(this.widget.name, this.context);
        });
    }

    void closeDirectly({dynamic result}) {
        scope.proxySync((){
            PageManager.pop(this.context, result);
        });
    }
}

