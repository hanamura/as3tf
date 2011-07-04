/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.proc.page {
	import flash.utils.getQualifiedClassName;
	
	import org.typefest.proc.Proc;
	import org.typefest.proc.ProcEvent;
	import org.typefest.proc.store;
	
	
	
	
	
	public class Page extends Proc {
		///// parent
		protected var _parent:Page = null;
		protected var _query:Query = null;
		protected var _$:Storage   = null;
		
		public function get parent():Page { return _parent }
		public function get query():Query { return _query }
		public function get $():Storage { return _$ }
		public function get pageName():String { return getQualifiedClassName(this) }
		
		///// child
		protected var _child:Page = null;
		
		public function get child():Page { return _child }
		
		///// closed
		store var _closed:Function = null;
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function Page(
			parent:Page    = null,
			start:Function = null,
			end:Function   = null
		) {
			_parent = parent;
			
			if (_parent) {
				_query = _parent.query.down(pageName);
				_$     = new Storage(_parent.$);
			} else {
				_query = new Query(null, pageName);
				_$     = new Storage();
			}
			
			super(start, end);
		}
		
		
		
		
		
		//---------------------------------------
		// to child
		//---------------------------------------
		protected function _toChild(child:Page):void {
			_child = child;
			_child.start();
			
			_onToChild();
			
			listen(_child, PageEvent.INIT, _childInit);
			listen(_child, PageEvent.WILL_CLOSE, _childWillClose);
		}
		protected function _onToChild():void {}
		
		
		
		
		
		//---------------------------------------
		// child init
		//---------------------------------------
		protected function _childInit(e:PageEvent):void {
			_onChildInit();
			
			listen(_child, PageEvent.WILL_CLOSE, _childWillClose);
		}
		protected function _onChildInit():void {}
		
		
		
		
		
		//---------------------------------------
		// child will close
		//---------------------------------------
		protected function _childWillClose(e:PageEvent):void {
			if (_query.equal(e.query)) {
				_onTarget(e.query);
				_child.close();
				listen(_child, ProcEvent.END, _childEnd);
			} else {
				_onThrough(e.query);
				_willClose(e.query);
			}
		}
		protected function _onTarget(query:Query):void {}
		protected function _onThrough(query:Query):void {}
		
		
		
		
		
		//---------------------------------------
		// child close
		//---------------------------------------
		protected function _childEnd(e:ProcEvent):void {
			_child = null;
			_onChildEnd();
		}
		protected function _onChildEnd():void {}
		
		
		
		
		
		//---------------------------------------
		// will close
		//---------------------------------------
		protected function _willClose(query:Query):void {
			_onWillClose(query);
			
			dispatchEvent(new PageEvent(PageEvent.WILL_CLOSE, false, false, query));
		}
		protected function _onWillClose(query:Query):void {}
		
		
		
		
		
		//---------------------------------------
		// close
		//---------------------------------------
		public function close():void {
			var fn:Function = store::_closed || _onClose;
			
			drop();
			
			fn.call(this);
		}
		protected function _onClose():void {
			sleep("1", end);
		}
		
		
		
		
		
		//---------------------------------------
		// closed
		//---------------------------------------
		public function closed(fn:Function):void {
			store::_closed = fn;
		}
		
		
		
		
		
		//---------------------------------------
		// drop
		//---------------------------------------
		override public function drop():void {
			super.drop();
			
			store::_closed = null;
		}
		
		
		
		
		
		//---------------------------------------
		// end
		//---------------------------------------
		override public function end():void {
			if (_child) {
				_child.stop();
				_child = null;
			}
			
			super.end();
		}
	}
}