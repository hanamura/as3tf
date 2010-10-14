/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.errors {
	public class StopIteration extends Error {
		public function StopIteration(message:String = "", id:int = 0) {
			super(message, id);
		}
	}
}