import 'package:flutter/material.dart';
import 'package:quicklibs/quicklibs.dart';


mixin ScopeMixin<ScopeType extends Scope> {
    ScopeType _scope;
    ScopeType get scope {
        if(_scope == null)
            _scope = createScope();

        return _scope;
    }

    ScopeType createScope();

    void forkFrom(Scope parent) {
        if(parent != null) {
            parent.fork(scope);
        }
    }

    void activateScope() {
        if(scope.currentStatus == ScopeStatus.activated) {
            return;
        }
        Scope.activate(scope);
    }

    void deactivateScope() {
        if(scope.currentStatus == ScopeStatus.deactivated) {
            return;
        }
        Scope.deactivate(scope);
    }

    void destroyScope() {
        if(_scope != null) {
            if(scope.currentStatus == ScopeStatus.deactivated) {
                return;
            }
            Scope.destroy(_scope);
        }
    }

    void resetActiveDelay() {
        if(_scope != null)
            _scope.resetActiveDelay();
    }
}


abstract class ScopeWidget extends StatefulWidget {
    const ScopeWidget({Key key, this.parentScope}) : super(key: key);
    final Scope parentScope;

    @override
    ScopeState createState();
}


abstract class ScopeState<WidgetType extends ScopeWidget, ScopeType extends Scope> extends State<WidgetType> with ScopeMixin<ScopeType> {
    ScopeState._();
    ScopeState.create(Scope parentScope) {
        forkFrom(parentScope ?? Scope.rootScope);
    }

    @override
    @mustCallSuper
    void initState() {
        super.initState();
        this.scope.registerActiveDelayCallback(onReceiverActiveDelayMessage);
        activateScope();
    }


    @override
    void dispose() {
        super.dispose();
        destroyScope();
    }

    @override
    @mustCallSuper
    Widget build(BuildContext context) {
        return createChild(context);
    }

    Widget createChild(BuildContext context);

    void postActiveDelayMessage(dynamic key, [dynamic value]) {
        this.scope.postActiveDelayMessage(key, value);
    }

    void onReceiverActiveDelayMessage(Map<dynamic, dynamic> activeMessageMap) {

    }
}

abstract class GeneralScopeState<WidgetType extends ScopeWidget> extends ScopeState<WidgetType, GeneralScope> {
    GeneralScopeState.create(Scope parentScope, { this.scopeName, this.scopeId }) : super.create(parentScope);

    final String scopeName;
    final dynamic scopeId;

    @override
    GeneralScope createScope() {
        return GeneralScope(scopeName: this.scopeName, scopeId: this.scopeId);
    }
}