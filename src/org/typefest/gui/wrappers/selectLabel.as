/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui.wrappers {
	import org.typefest.data.Set;
	
	
	
	
	
	public function selectLabel(
		labels:Array,
		over:Boolean,
		pressed:Boolean,
		mouseEnabled:Boolean,
		selected:Boolean
	):* {
		var list:Array;
		
		if (over) {
			if (pressed) {
				if (selected) {
					list = [
						"press*",  "press",
						"over*",   "over",
						"normal*", "normal"
					];
				} else {
					list = ["press", "over", "normal"];
				}
			} else {
				if (selected) {
					list = ["over*", "over", "normal*", "normal"];
				} else {
					list = ["over", "normal"];
				}
			}
		} else {
			if (selected) {
				list = ["normal*", "normal"];
			} else {
				list = ["normal"];
			}
		}
		
		var set:Set = new Set(labels);
		var label:*;
		
		while (list.length) {
			label = list.shift();
			
			if (set.has(label)) {
				return label;
			}
		}
		
		return null;
	}
}