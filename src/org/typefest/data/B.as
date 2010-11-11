/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	internal class B extends Object {
		static public const TRUE:*              = {};
		static public const FALSE:*             = {};
		static public const NAN:*               = {};
		static public const NULL:*              = {};
		static public const UNDEFINED:*         = {};
		static public const POSITIVE_INFINITY:* = {};
		static public const NEGATIVE_INFINITY:* = {};
		
		static public function wrap(_:*):* {
			if (_ === true) {
				return TRUE;
			} else if (_ === false) {
				return FALSE;
			} else if (isNaN(_)) {
				return NAN;
			} else if (_ === null) {
				return NULL;
			} else if (_ === undefined) {
				return UNDEFINED;
			} else if (_ === Number.POSITIVE_INFINITY) {
				return POSITIVE_INFINITY;
			} else if (_ === Number.NEGATIVE_INFINITY) {
				return NEGATIVE_INFINITY;
			} else {
				return _;
			}
		}
		static public function unwrap(_:*):* {
			if (_ === TRUE) {
				return true;
			} else if (_ === FALSE) {
				return false;
			} else if (_ === NAN) {
				return NaN;
			} else if (_ === NULL) {
				return null;
			} else if (_ === UNDEFINED) {
				return undefined;
			} else if (_ === POSITIVE_INFINITY) {
				return Number.POSITIVE_INFINITY;
			} else if (_ === NEGATIVE_INFINITY) {
				return Number.NEGATIVE_INFINITY;
			} else {
				return _;
			}
		}
	}
}