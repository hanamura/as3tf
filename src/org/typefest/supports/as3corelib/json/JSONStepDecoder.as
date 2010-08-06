/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.supports.as3corelib.json {
	import com.adobe.serialization.json.JSONToken;
	import com.adobe.serialization.json.JSONTokenizer;
	import com.adobe.serialization.json.JSONTokenType;
	
	import org.typefest.data.Set;
	import org.typefest.errors.StopIteration;
	
	
	
	
	
	public class JSONStepDecoder extends Object {
		///// values
		static public const VALUE_TYPES:Set = new Set([
			JSONTokenType.STRING,
			JSONTokenType.NUMBER,
			JSONTokenType.TRUE,
			JSONTokenType.FALSE,
			JSONTokenType.NULL
		]);
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// data
		protected var _data:String = null;
		
		public function get data():String {
			return _data;
		}
		
		
		
		///// object
		protected var _object:* = null;
		
		public function get object():* {
			return _object;
		}
		
		
		
		///// stack
		protected var _tokenizer:JSONTokenizer = null;
		protected var _stack:Array             = null;
		protected var _cont:Function           = null;
		protected var _token:JSONToken         = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function JSONStepDecoder(data:String) {
			super();
			
			_data = data;
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_stack     = [];
			_tokenizer = new JSONTokenizer(_data, true);
			_cont      = _addFirstValue;
			_token     = _tokenizer.getNextToken();
		}
		
		
		
		
		
		//---------------------------------------
		// step
		//---------------------------------------
		public function step():void {
			_cont();
		}
		
		
		
		
		
		//---------------------------------------
		// add value
		//---------------------------------------
		///// add first value
		protected function _addFirstValue():void {
			if (_token.type === JSONTokenType.LEFT_BRACE) {
				
				_stack.push(new Target(_object = {}));
				_next(_objectBegin);
				
			} else if (_token.type === JSONTokenType.LEFT_BRACKET) {
				
				_stack.push(new Target(_object = []));
				_next(_arrayBegin);
				
			} else {
				throw new Error();
			}
		}
		///// add value
		protected function _addValue():void {
			var target:Target = _peek();
			var value:*;
			
			if (_token.type === JSONTokenType.LEFT_BRACE) {
				
				_stack.push(new Target(_setValue({})));
				_next(_objectBegin);
				
			} else if (_token.type === JSONTokenType.LEFT_BRACKET) {
				
				_stack.push(new Target(_setValue([])));
				_next(_arrayBegin);
				
			} else if (VALUE_TYPES.has(_token.type)) {
				_setValue(_token.value);
				
				if (target.isArray) {
					_next(_arrayInside);
				} else {
					_next(_objectInside);
				}
			} else {
				throw new Error();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// parse object
		//---------------------------------------
		///// object begin
		protected function _objectBegin():void {
			if (_token.type === JSONTokenType.RIGHT_BRACE) {
				_pop();
			} else {
				_objectKey();
			}
		}
		///// object inside
		protected function _objectInside():void {
			if (_token.type === JSONTokenType.RIGHT_BRACE) {
				_pop();
			} else if (_token.type === JSONTokenType.COMMA) {
				_next(_objectKey);
			} else {
				throw new Error();
			}
		}
		///// object key
		protected function _objectKey():void {
			if (_token.type === JSONTokenType.STRING) {
				var target:Target = _peek();
				var key:String    = _token.value as String;
				
				_token = _tokenizer.getNextToken();
				
				if (_token.type === JSONTokenType.COLON) {
					target.key = key;
					
					_next(_addValue);
				} else {
					throw new Error();
				}
			} else {
				throw new Error();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// parse array
		//---------------------------------------
		///// array begin
		protected function _arrayBegin():void {
			if (_token.type === JSONTokenType.RIGHT_BRACKET) {
				_pop();
			} else {
				_addValue();
			}
		}
		///// array inside
		protected function _arrayInside():void {
			if (_token.type === JSONTokenType.RIGHT_BRACKET) {
				_pop();
			} else if (_token.type === JSONTokenType.COMMA) {
				_next(_addValue);
			} else {
				throw new Error();
			}
		}
		
		
		
		
		
		//---------------------------------------
		// stop iteration
		//---------------------------------------
		protected function _stopIteration():void {
			throw new StopIteration();
		}
		
		
		
		
		
		//---------------------------------------
		// pop
		//---------------------------------------
		protected function _pop():void {
			_stack.pop();
			
			var target:Target = _peek();
			
			if (!target) {
				_next(_stopIteration);
			} else {
				if (target.isArray) {
					_next(_arrayInside);
				} else {
					_next(_objectInside);
				}
			}
		}
		
		
		
		
		
		//---------------------------------------
		// shortcuts
		//---------------------------------------
		///// set value
		protected function _setValue(value:*):* {
			var target:Target = _peek();
			
			if (target.isArray) {
				target.object.push(value);
			} else {
				target.object[target.key] = value;
				target.key = null;
			}
			return value;
		}
		///// peek
		protected function _peek():Target {
			return _stack.length ? _stack[_stack.length - 1] : null;
		}
		///// next
		protected function _next(cont:Function):void {
			_cont  = cont;
			_token = _tokenizer.getNextToken();
		}
	}
}



//---------------------------------------
// target
//---------------------------------------
internal class Target extends Object {
	public var object:*        = null;
	public var key:String      = null;
	public var isArray:Boolean = false;
	
	public function Target(object:*) {
		super();
		
		this.object = object;
		
		isArray = object is Array;
	}
}