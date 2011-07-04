/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc.page {
	public class Query extends Object {
		///// parent & name
		protected var _parent:Query = null;
		protected var _name:String  = null;
		
		public function get parent():Query {
			return _parent;
		}
		public function get name():String {
			return _name;
		}
		public function get root():Query {
			return _parent ? _parent.root : this;
		}
		public function get path():String {
			return (_parent ? _parent.path : "") + "/" + (_name || "");
		}
		public function get level():int {
			var query:Query = this;
			var count:int   = 0;
			
			while (query.parent) {
				query = query.parent;
				count++;
			}
			return count;
		}
		
		///// data
		protected var _data:* = null;
		
		public function get data():* { return _data }
		public function set data(_:*):void { _data = _ }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Query(parent:Query = null, name:String = null, data:* = null) {
			super();
			
			_parent = parent;
			_name   = name;
			_data   = data;
		}
		
		
		
		
		
		//---------------------------------------
		// create
		//---------------------------------------
		public function up(count:int):Query {
			var query:Query = this;
			
			while (count-- && query.parent) { query = query.parent }
			
			return query.clone();
		}
		public function down(name:String = null, data:* = null):Query {
			return new Query(this, name, data);
		}
		public function clone():Query {
			return new Query(_parent && _parent.clone(), _name, _data);
		}
		
		
		
		
		
		//---------------------------------------
		// pred
		//---------------------------------------
		public function equal(query:Query):Boolean {
			if (level === query.level && name === query.name) {
				return parent ? parent.equal(query.parent) : true;
			} else {
				return false;
			}
		}
		public function descendant(query:Query):Boolean {
			if (level < query.level) {
				return equal(query.up(query.level - level));
			} else {
				return false;
			}
		}
		public function ancestor(query:Query):Boolean {
			return query.descendant(this);
		}
		
		
		
		
		
		//---------------------------------------
		// to string
		//---------------------------------------
		public function toString():String {
			return path;
		}
	}
}