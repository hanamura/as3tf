/*
Copyright (c) 2010 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.data {
	import flash.utils.flash_proxy;
	import flash.utils.Proxy;
	
	public class Tree extends Proxy {
		/*
		
		// usage
		
		var tree:Tree = new Tree();
		
		tree.set(["hello", "world", "foo", "bar"], 1);
		tree.set(["hello", "world"], 2);
		tree.set(["hello"], 4);
		tree.set(["hi", "globe", "fu"], 5);
		
		trace(tree.get(["hello"]));
		// 4
		
		trace(tree.get(["hello", "world"]));
		// 2
		
		trace(tree.get(["hello", "world", "foo"]));
		// undefined
		
		tree.del(["hello"]);
		
		trace(tree.get(["hello"]))
		// undefined
		
		for each (var value:* in tree) {
			trace(value);
		}
		// 2
		// 1
		// 5
		
		trace(tree.dump());
		// [key]: hello
		// 	[key]: world
		// 		[value]: 2
		// 		[key]: foo
		// 			[key]: bar
		// 				[value]: 1
		// [key]: hi
		// 	[key]: globe
		// 		[key]: fu
		// 			[value]: 5
		
		*/
		
		
		
		///// alt boolean
		static private const TRUE:Object  = {};
		static private const FALSE:Object = {};
		static private function filter(key:*):* {
			return (key is Boolean) ? (key ? TRUE : FALSE) : key;
		}
		static private function unfilter(key:*):* {
			return (key === TRUE) ? true : (key === FALSE) ? false : key;
		}
		
		
		
		
		
		//---------------------------------------
		// instance
		//---------------------------------------
		///// weakkeys
		protected var _weakKeys:Boolean = false;
		
		///// node
		protected var _node:Node = null;
		
		///// temporary array for for-loop
		protected var _values:Array = null;
		
		
		
		///// length
		public function get length():int { return _count(_node) }
		protected function _count(node:Node):int {
			var count:int = node.has() ? 1 : 0;
			
			for each (var child:Node in node) {
				count += _count(child);
			}
			return count;
		}
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Tree(weakKeys:Boolean = false) {
			_weakKeys = weakKeys;
			_node     = new Node(weakKeys);
		}
		
		
		
		
		
		//---------------------------------------
		// set / get / del / clear
		//---------------------------------------
		public function set(keys:Array, value:*):void {
			keys = keys.concat();
			
			var node:Node = _node;
			var key:*;
			
			while (keys.length) {
				key  = filter(keys.shift());
				node = node[key] ||= new Node(_weakKeys);
			}
			node.set(value);
		}
		public function get(keys:Array):* {
			var node:Node = _getNode(keys.concat());
			
			return node ? node.get() : undefined;
		}
		public function del(keys:Array):Boolean {
			var node:Node = _getNode(keys.concat());
			
			return !!node && node.del();
		}
		public function has(keys:Array):Boolean {
			var node:Node = _getNode(keys.concat());
			
			return !!node && node.has();
		}
		public function clear():void {
			_node = new Node(_weakKeys);
		}
		
		///// get node
		protected function _getNode(keys:Array):Node {
			var node:Node = _node;
			
			try {
				while (keys.length) {
					node = node[filter(keys.shift())];
				}
			} catch (e:Error) {
				return null;
			}
			return node;
		}
		
		
		
		
		
		//---------------------------------------
		// to array
		//---------------------------------------
		public function toArray():Array {
			return _collect(_node, []);
		}
		protected function _collect(node:Node, values:Array):Array {
			if (node.has()) {
				values.push(node.get());
			}
			for each (var child:Node in node) {
				_collect(child, values);
			}
			return values;
		}
		
		
		
		
		
		//---------------------------------------
		// proxy
		//---------------------------------------
		override flash_proxy function nextNameIndex(index:int):int {
			if (!index) {
				_values = toArray();
			}
			if (index < _values.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		override flash_proxy function nextValue(index:int):* {
			return _values[index - 1];
		}
		
		
		
		
		
		//---------------------------------------
		// iteration
		//---------------------------------------
		public function each(fn:Function):void {
			_each([], _node, fn);
		}
		protected function _each(keys:Array, node:Node, fn:Function):void {
			if (node.has()) {
				fn(keys, node.get());
			}
			for (var key:* in node) {
				_each(keys.concat([unfilter(key)]), node[key], fn);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// dump
		//---------------------------------------
		public function dump():String {
			return (function(node:Node, indent:int = 0):String {
				var tab:String = "";
				var count:int  = indent;
				
				while (count--) {
					tab += "\t";
				}
				
				var str:String = "";
				
				if (node.has()) {
					str += tab + "[value]: " + String(node.get()) + "\n";
				}
				for (var key:* in node) {
					str += tab + "[key]: " + String(key) + "\n";
					str += arguments.callee(node[key], indent + 1);
				}
				return str;
			})(_node);
		}
	}
}





//---------------------------------------
// node
//---------------------------------------
import flash.utils.Dictionary;

dynamic internal class Node extends Dictionary {
	protected var _hasValue:Boolean = false;
	protected var _value:*          = undefined;
	
	public function Node(weakKeys:Boolean = false) {
		super(weakKeys);
	}
	
	public function set(value:*):void {
		_hasValue = true;
		_value    = value;
	}
	public function get():* {
		return _hasValue ? _value : undefined;
	}
	public function del():Boolean {
		if (_hasValue) {
			_hasValue = false;
			_value    = undefined;
			return true;
		} else {
			return false;
		}
	}
	public function has():Boolean {
		return _hasValue;
	}
}