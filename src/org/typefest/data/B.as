package org.typefest.data {
	internal class B extends Object {
		static public const TRUE:*  = {};
		static public const FALSE:* = {};
		
		static public function wrap(_:*):* {
			return (_ is Boolean) ? (_ ? TRUE : FALSE) : _;
		}
		static public function unwrap(_:*):* {
			return (_ === TRUE) ? true : (_ === FALSE) ? false : _;
		}
	}
}