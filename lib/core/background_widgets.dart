part of 'pages.dart';


class BackgroundBundle {
    const BackgroundBundle({this.bgColor});
	final Color bgColor;
}

class _Background extends ScopeWidget {
	_Background({ Key key, Scope parentScope })
		: super(key: key, parentScope: parentScope);

	@override
	__BackgroundState createState() => __BackgroundState.create(parentScope);
}

class __BackgroundState extends GeneralScopeState<_Background> {
	__BackgroundState.create(Scope parentScope) : super.create(parentScope, scopeId: _PageScopeId.Background);
	BackgroundBundle _bundle;

	@override
	void initState() {
		super.initState();
		_bundle = scope.getStoredData(_PageScopeId.Background, fromParentIfNotExist: true) ?? BackgroundBundle();
		scope.registerMessageCallback(_PageScopeId.Background, (data) async {
			if(data is BackgroundBundle) {
				scope.postActiveDelayMessage(_PageScopeId.Background, data);
			}
		});
	}

	@override
	void deactivate() {
		scope.setParentStoredData(_PageScopeId.Background, _bundle);
		super.deactivate();
	}

	@override
	Widget createChild(BuildContext context) {
		return Container (
			color: _bundle.bgColor,
		);
	}

	@override
	void onReceiverActiveDelayMessage(Map activeMessageMap) {
		super.onReceiverActiveDelayMessage(activeMessageMap);
		if(activeMessageMap.containsKey(_PageScopeId.Background)) {
			setState(() {
				_bundle = activeMessageMap[_PageScopeId.Background];
			});
		}
	}
}