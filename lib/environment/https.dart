import 'package:flutter/foundation.dart';
import 'package:happypass/happypass.dart';

RequestPrototype baseApiPrototype = RequestPrototype()
	.setRequestRunProxy(<T, Q>(asyncCallback, message) async {
	return await compute(asyncCallback, message);
});