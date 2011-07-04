/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.gui {
	import flash.events.Event;
	
	import org.typefest.data.ASet;
	
	
	
	
	
	public class CheckboxGroup extends ASet {
		///// button
		protected var _button:Checkbox = null;
		
		public function get button():Checkbox { return _button }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function CheckboxGroup(init:* = null) {
			super(init);
		}
		
		
		
		
		
		//---------------------------------------
		// check type
		//---------------------------------------
		protected function _checkType(...values:Array):void {
			for each (var value:* in values) {
				if (!(value is Checkbox)) {
					throw new ArgumentError("error");
				}
			}
		}
		override public function add(...values:Array):void {
			_checkType.apply(null, values);
			
			super.add.apply(null, values);
		}
		
		
		
		
		
		//---------------------------------------
		// dispatch
		//---------------------------------------
		override protected function _dispatch(
			type:String,
			adds:Array,
			removes:Array
		):void {
			var button:Checkbox;
			
			for each (button in removes) {
				button.removeEventListener(GUIEvent.SELECT, _buttonSelect, false);
			}
			
			if (removes.indexOf(_button) >= 0) {
				_button = null;
			}
			
			for each (button in adds) {
				if (_button) {
					if (button.selected) {
						button.selected = false;
					}
				} else {
					if (button.selected) {
						_button = button;
					}
				}
			}
			
			for each (button in adds) {
				button.addEventListener(GUIEvent.SELECT, _buttonSelect, false, 0, true);
			}
			
			super._dispatch(type, adds, removes);
		}
		
		
		
		
		
		//---------------------------------------
		// listener
		//---------------------------------------
		protected function _buttonSelect(e:Event):void {
			var button:Checkbox;
			
			for each (button in this) {
				button.removeEventListener(GUIEvent.SELECT, _buttonSelect, false);
			}
			
			if (e.currentTarget === _button) {
				_button = null;
			} else {
				if (_button) {
					_button.selected = false;
				}
				_button = e.currentTarget as Checkbox;
			}
			
			for each (button in this) {
				button.addEventListener(GUIEvent.SELECT, _buttonSelect, false, 0, true);
			}
			
			dispatchEvent(new GUIEvent(GUIEvent.SELECT));
		}
	}
}