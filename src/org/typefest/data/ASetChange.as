/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	public class ASetChange extends AChange {
		static public const ADD:String    = "ASetChange.ADD";
		static public const REMOVE:String = "ASetChange.REMOVE";
		
		protected var _adds:Array    = null;
		protected var _removes:Array = null;

		public function get adds():Array {
			return _adds && _adds.concat();
		}
		public function get removes():Array {
			return _removes && _removes.concat();
		}
		
		public function ASetChange(type:String, adds:Array, removes:Array) {
			super(type);
			
			_adds    = adds;
			_removes = removes;
		}
	}
}