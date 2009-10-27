/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.layout.tables {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.typefest.layout.Area;
	import org.typefest.layout.IPositionable;
	import org.typefest.layout.Layout;
	import org.typefest.layout.Struct;
	
	public class VerticalTable extends Area {
		//---------------------------------------
		// length
		//---------------------------------------
		protected var _lengthX:int = 1;
		protected var _lengthY:int = 0;
		
		public function get lengthX():int {
			return _lengthX;
		}
		public function set lengthX(x:int):void {
			if (x < 1) {
				throw ArgumentError("lengthX must be larger than 1.");
			}
			if (_lengthX !== x) {
				_lengthX = x;
				_updateTable();
			}
		}
		public function get lengthY():int {
			return _lengthY;
		}
		public function set lengthY(y:int):void {
			throw new IllegalOperationError("Unable to set lengthY.");
		}
		
		public function get length():int {
			return _lengthX;
		}
		public function set length(x:int):void {
			lengthX = x;
		}
		
		//---------------------------------------
		// cell size
		//---------------------------------------
		protected var _cellWidth:Number  = 0;
		protected var _cellHeight:Number = 0;
		
		public function get cellWidth():Number {
			return _cellWidth;
		}
		public function set cellWidth(x:Number):void {
			if (_cellWidth !== x) {
				_cellWidth = x;
				_updateTable();
			}
		}
		public function get cellHeight():Number {
			return _cellHeight;
		}
		public function set cellHeight(y:Number):void {
			if (_cellHeight !== y) {
				_cellHeight = y;
				_updateTable();
			}
		}
		
		//---------------------------------------
		// margin
		//---------------------------------------
		protected var _marginX:Number       = 0;
		protected var _marginY:Number       = 0;
		protected var _paddingLeft:Number   = 0;
		protected var _paddingRight:Number  = 0;
		protected var _paddingTop:Number    = 0;
		protected var _paddingBottom:Number = 0;
		
		public function get marginX():Number {
			return _marginX;
		}
		public function set marginX(x:Number):void {
			if (_marginX !== x) {
				_marginX = x;
				_updateTable();
			}
		}
		public function get marginY():Number {
			return _marginY;
		}
		public function set marginY(y:Number):void {
			if (_marginY !== y) {
				_marginY = y;
				_updateTable();
			}
		}
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		public function set paddingLeft(x:Number):void {
			if (_paddingLeft !== x) {
				_paddingLeft = x;
				_updateTable();
			}
		}
		public function get paddingRight():Number {
			return _paddingRight;
		}
		public function set paddingRight(x:Number):void {
			if (_paddingRight !== x) {
				_paddingRight = x;
				_updateTable();
			}
		}
		public function get paddingTop():Number {
			return _paddingTop;
		}
		public function set paddingTop(y:Number):void {
			if (_paddingTop !== y) {
				_paddingTop = y;
				_updateTable();
			}
		}
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		public function set paddingBottom(y:Number):void {
			if (_paddingBottom !== y) {
				_paddingBottom = y;
				_updateTable();
			}
		}
		
		//---------------------------------------
		// forbidden setters
		//---------------------------------------
		override public function set width(x:Number):void {
			throw new IllegalOperationError("Unable to set width.");
		}
		override public function set height(x:Number):void {
			throw new IllegalOperationError("Unable to set height.");
		}
		override public function set apply(x:Function):void {
			throw new IllegalOperationError("Unable to set apply.");
		}
		
		//---------------------------------------
		// members
		//---------------------------------------
		protected var __sequence:Array                 = [];
		protected var __positionableMembers:Dictionary = new Dictionary(false);
		protected var __targetMembers:Dictionary       = new Dictionary(false);
		
		public function get members():Array {
			return __sequence.concat();
		}
		
		public function get rectangles():Array {
			var _:Array = [];
			for (var i:int = 0; i < __sequence.length; i++) {
				_.push(_getMemberArea(i));
			}
			return _;
		}
		
		//=======================================
		// 
		// Constructor
		// 
		//=======================================
		public function VerticalTable(lengthX:int = 1) {
			super();
			
			_layout = Layout.noScale;
			_apply  = _applyProperly;
			
			if (lengthX < 1) {
				throw new ArgumentError("lengthX must be larger than 1.");
			}
			_lengthX = lengthX;
		}
		
		//---------------------------------------
		// push / unshift
		//---------------------------------------
		public function push(
			target:*,
			layout:*           = "exactFit",
			original:Rectangle = null,
			positionX:*        = 0,
			positionY:*        = 0,
			apply:Function     = null
		):void {
			_addMember(target, layout, original, positionX, positionY, apply);
			
			__sequence.push(target);
			_updateTable(__sequence.length - 1);
		}
		public function unshift(
			target:*,
			layout:*           = "exactFit",
			original:Rectangle = null,
			positionX:*        = 0,
			positionY:*        = 0,
			apply:Function     = null
		):void {
			_addMember(target, layout, original, positionX, positionY, apply);
			
			__sequence.unshift(target);
			_updateTable(0);
		}
		
		//---------------------------------------
		// pop / shift
		//---------------------------------------
		public function pop():* {
			if (__sequence.length > 0) {
				var t:* = __sequence.pop();
				
				_removeMember(t);
				
				// passing __sequence.length to _updateTable means
				// to update nothing unless width or height changes
				_updateTable(__sequence.length);
				
				return t;
			} else {
				return null;
			}
		}
		public function shift():* {
			if (__sequence.length > 0) {
				var t:* = __sequence.shift();
				
				_removeMember(t);
				
				_updateTable(0);
				
				return t;
			} else {
				return null;
			}
		}
		
		//---------------------------------------
		// remove member
		//---------------------------------------
		public function removeMember(target:*):void {
			var inPos:Boolean = (target in __positionableMembers);
			var inTar:Boolean = (target in __targetMembers);
			
			if (inPos || inTar) {
				if (inPos) {
					target.parentArea = null;
					delete __positionableMembers[target];
				} else {
					delete __targetMembers[target];
				}
				
				var index:int = __sequence.indexOf(target);
				
				__sequence.splice(index, 1);
				
				_updateTable(index);
				
				dispatchEvent(new TableEvent(TableEvent.MEMBER_CHANGE));
			}
		}
		
		// search index for member
		public function index(target:*):int {
			return __sequence.indexOf(target);
		}
		// get member by index
		public function get(index:int):* {
			return __sequence[index];
		}
		// clear members
		public function clearMembers():void {
			for (var p:* in __positionableMembers) {
				p.parentArea = null;
			}
			__sequence            = [];
			__positionableMembers = new Dictionary(false);
			__targetMembers       = new Dictionary(false);
		}
		// overriden update
		override public function update(t:*):void {
			if (t in __positionableMembers || t in __targetMembers) {
				_updateCells(__sequence.indexOf(t), 1);
			} else {
				super.update(t);
			}
		}
		
		//---------------------------------------
		// internal shortcuts
		//---------------------------------------
		protected function _addMember(
			target:*,
			layout:*,
			original:Rectangle,
			positionX:*,
			positionY:*,
			apply:Function
		):void {
			if (target === this) {
				throw new ArgumentError("Unable to add itself.");
			}
			if (target is IPositionable) {
				var p:IPositionable = target as IPositionable;
				
				if (p.parentArea) {
					p.parentArea.remove(p);
				}
				p.parentArea = this;
				
				__positionableMembers[p] = true;
			} else {
				var $:Struct = new Struct(
					target,
					layout,
					original,
					positionX,
					positionY,
					apply
				);
				
				__targetMembers[target] = $;
			}
			
			dispatchEvent(new TableEvent(TableEvent.MEMBER_CHANGE));
		}
		protected function _removeMember(target:*):void {
			if (target in __positionableMembers) {
				target.parentArea = null;
				delete __positionableMembers[target];
			} else {
				delete __targetMembers[target];
			}
			
			dispatchEvent(new TableEvent(TableEvent.MEMBER_CHANGE));
		}
		
		//---------------------------------------
		// update before parentArea’s update
		//---------------------------------------
		protected function _updateTable(start:int = 0):void {
			var size:Rectangle = new Rectangle();
			
			size.width = 0
				+ _paddingLeft
				+ (
					  (_cellWidth * _lengthX)
					+ (_marginX * (_lengthX - 1))
				  )
				+ _paddingRight;
			
			_lengthY = Math.ceil(__sequence.length / _lengthX);
			
			if (_lengthY <= 0) {
				size.height = 0;
			} else {
				size.height = 0
					+ _paddingTop
					+ (
						  (_cellHeight * _lengthY)
						+ (_marginY * (_lengthY - 1))
					  )
					+ _paddingBottom;
			}
			
			// update type selection
			if (width === size.width && height === size.height) {
				_updateCells(start);
			} else {
				_rect.width  = size.width;
				_rect.height = size.height;
				
				if (_parentArea) {
					_parentArea.update(this);
				} else {
					_update();
				}
			}
		}
		
		//---------------------------------------
		// updates
		//---------------------------------------
		override protected function _update():void {
			_updateCells();
			
			super._update();
		}
		protected function _updateCells(start:int = 0, length:int = -1):void {
			var indexX:int;
			var indexY:int;
			var area:Rectangle = new Rectangle();
			var member:*;
			
			length = length < 0 ? __sequence.length : length;
			var len:int = Math.min(start + length, __sequence.length);
			
			for (var i:int = start; i < len; i++) {
				area = _getMemberArea(i);
				
				member = __sequence[i];
				
				if (member in __positionableMembers) {
					_position(member, member, area);
				} else if (member in __targetMembers) {
					_position(__targetMembers[member], member, area);
				}
			}
		}
		
		protected function _getMemberArea(i:int):Rectangle {
			var indexX:int = i % _lengthX;
			var indexY:int = Math.floor(i / _lengthX);
			
			var area:Rectangle = new Rectangle();
			area.x      = x + _paddingLeft + ((_cellWidth + _marginX) * indexX);
			area.y      = y + _paddingTop + ((_cellHeight + _marginY) * indexY);
			area.width  = _cellWidth;
			area.height = _cellHeight;
			
			return area;
		}
		
		//---------------------------------------
		// proper apply function to this object
		//---------------------------------------
		protected function _applyProperly(area:Rectangle, self:VerticalTable):void {
			_rect.x = area.x;
			_rect.y = area.y;
			
			_update();
		}
	}
}