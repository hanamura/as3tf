/*
Copyright (c) 2011 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.display.Graphics;
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsData;
	import flash.display.IGraphicsFill;
	
	import flash.geom.Rectangle;
	
	import org.typefest.display.containers.Container;
	
	
	
	
	
	public class ShapeBase extends Container {
		///// fill data
		protected var _fillData:GraphicsSolidFill = new GraphicsSolidFill(0xffffff, 1);
		
		///// fill color
		public function get fill():uint { return _fillData.color }
		public function set fill(_:uint):void {
			if (_fillData.color !== _) {
				_fillData.color = _;
				_render();
			}
		}
		public function get fillR():uint { return _fillData.color >> 16 }
		public function set fillR(_:uint):void {
			if (fillR !== _) {
				_fillData.color = (_ << 16) | (_fillData.color % 65536);
				_render();
			}
		}
		public function get fillG():uint { return (_fillData.color >> 8) % 256 }
		public function set fillG(_:uint):void {
			if (fillG !== _) {
				_fillData.color =
					((_fillData.color >> 16) << 16) |
					(_ << 8)                        |
					(_fillData.color % 256);
				_render();
			}
		}
		public function get fillB():uint { return _fillData.color % 256 }
		public function set fillB(_:uint):void {
			if (fillB !== _) {
				_fillData.color = ((_fillData.color >> 8) << 8) | _;
				_render();
			}
		}
		
		///// fill alpha
		public function get fillAlpha():Number { return _fillData.alpha }
		public function set fillAlpha(_:Number):void {
			if (_fillData.alpha !== _) {
				_fillData.alpha = _;
				_render();
			}
		}
		
		///// fill graphics fill
		protected var _fillCustomData:IGraphicsFill = null;

		public function get fillCustomData():IGraphicsFill { return _fillCustomData }
		public function set fillCustomData(_:IGraphicsFill):void {
			if (_fillCustomData !== _) {
				_fillCustomData = _;
				_render();
			}
		}
		
		///// fill enabled
		protected var _fillEnabled:Boolean = true;
		
		public function get fillEnabled():Boolean { return _fillEnabled }
		public function set fillEnabled(_:Boolean):void {
			if (_fillEnabled !== _) {
				_fillEnabled = _;
				_render();
			}
		}
		
		
		
		///// line data
		protected var _lineData:GraphicsSolidFill = new GraphicsSolidFill(0x000000, 1);
		
		///// line color
		public function get line():uint { return _lineData.color }
		public function set line(_:uint):void {
			if (_lineData.color !== _) {
				_lineData.color = _;
				_render();
			}
		}
		public function get lineR():uint { return _lineData.color >> 16 }
		public function set lineR(_:uint):void {
			if (lineR !== _) {
				_lineData.color = (_ << 16) | (_lineData.color % 65536);
				_render();
			}
		}
		public function get lineG():uint { return (_lineData.color >> 8) % 256 }
		public function set lineG(_:uint):void {
			if (lineG !== _) {
				_lineData.color =
					((_lineData.color >> 16) << 16) |
					(_ << 8)                        |
					(_lineData.color % 256);
				_render();
			}
		}
		public function get lineB():uint { return _lineData.color % 256 }
		public function set lineB(_:uint):void {
			if (lineB !== _) {
				_lineData.color = ((_lineData.color >> 8) << 8) | _;
				_render();
			}
		}
		
		///// line alpha
		public function get lineAlpha():Number { return _lineData.alpha }
		public function set lineAlpha(_:Number):void {
			if (_lineData.alpha !== _) {
				_lineData.alpha = _;
				_render();
			}
		}
		
		///// line graphics fill
		protected var _lineCustomData:IGraphicsFill = null;

		public function get lineCustomData():IGraphicsFill { return _lineCustomData }
		public function set lineCustomData(_:IGraphicsFill):void {
			if (_lineCustomData !== _) {
				_lineCustomData = _;
				_render();
			}
		}
		
		///// line width
		protected var _lineWidth:Number = 0;
		
		public function get lineWidth():Number { return _lineWidth }
		public function set lineWidth(_:Number):void {
			if (_lineWidth !== _) {
				_lineWidth = _;
				_updateBounds();
				_render();
			}
		}
		
		///// line side
		protected var _lineSide:String = LineSide.INSIDE;
		
		public function get lineSide():String { return _lineSide }
		public function set lineSide(_:String):void {
			if (_lineSide !== _) {
				_lineSide = _;
				_updateBounds();
				_render();
			}
		}
		
		
		
		///// inner / outer
		protected var _inner:Rectangle = null;
		protected var _outer:Rectangle = null;
		
		
		
		///// position
		protected var _positionX:Number = 0;
		protected var _positionY:Number = 0;
		
		public function get positionX():Number { return _positionX }
		public function set positionX(_:Number):void {
			if (_positionX !== _) {
				_positionX = _;
				_updateBounds();
				_render();
			}
		}
		public function get positionY():Number { return _positionY }
		public function set positionY(_:Number):void {
			if (_positionY !== _) {
				_positionY = _;
				_updateBounds();
				_render();
			}
		}
		
		
		
		///// graphics
		public function get canvas():Graphics { return graphics }
		
		
		
		
		
		//---------------------------------------
		// constructor
		//---------------------------------------
		public function ShapeBase() {
			super();
			
			_init();
		}
		
		
		
		
		
		//---------------------------------------
		// init
		//---------------------------------------
		protected function _init():void {
			_outer = new Rectangle();
			_inner = new Rectangle();
			
			_onInit();
		}
		protected function _onInit():void {}
		
		
		
		
		
		//---------------------------------------
		// on resize
		//---------------------------------------
		override protected function _onResize():void {
			_updateBounds();
			_render();
		}
		
		
		
		
		
		//---------------------------------------
		// update bounds
		//---------------------------------------
		protected function _updateBounds():void {
			if (_lineSide === LineSide.OUTSIDE) {
				_outer.x      = -_lineWidth;
				_outer.y      = -_lineWidth;
				_outer.width  = width + (_lineWidth * 2);
				_outer.height = height + (_lineWidth * 2);
				_inner.x      = 0;
				_inner.y      = 0;
				_inner.width  = width;
				_inner.height = height;
			} else if (_lineSide === LineSide.CENTER) {
				_outer.x      = -(_lineWidth * 0.5);
				_outer.y      = -(_lineWidth * 0.5);
				_outer.width  = width + _lineWidth;
				_outer.height = height + _lineWidth;
				_inner.x      = _lineWidth * 0.5;
				_inner.y      = _lineWidth * 0.5;
				_inner.width  = width - _lineWidth;
				_inner.height = height - _lineWidth;
			} else { ///// LineSide.INSIDE
				_outer.x      = 0;
				_outer.y      = 0;
				_outer.width  = width;
				_outer.height = height;
				_inner.x      = _lineWidth;
				_inner.y      = _lineWidth;
				_inner.width  = width - (_lineWidth * 2);
				_inner.height = height - (_lineWidth * 2);
			}
			
			var offsetX:Number = -width * _positionX;
			var offsetY:Number = -height * _positionY;
			
			_outer.offset(offsetX, offsetY);
			_inner.offset(offsetX, offsetY);
		}
		
		
		
		
		
		//---------------------------------------
		// render
		//---------------------------------------
		protected function _render():void {
			///// clear
			canvas.clear();
			
			///// empty
			if (_outer.isEmpty()) {
				return;
			}
			
			///// data
			var data:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			
			///// outer data
			var outerFill:IGraphicsFill = (_lineCustomData || _lineData) as IGraphicsFill;
			var outerPath:GraphicsPath  = _getOuterPath();
			var innerFill:IGraphicsFill = (_fillCustomData || _fillData) as IGraphicsFill;
			var innerPath:GraphicsPath  = _getInnerPath();
			
			///// push
			if (_outer.equals(_inner)) {
				if (_fillEnabled) {
					data.push(innerFill, innerPath, new GraphicsEndFill());
				}
			} else {
				if (_fillEnabled) {
					if (
						!_fillCustomData && !_lineCustomData &&
						_fillData.color === _lineData.color &&
						_fillData.alpha === _lineData.alpha
					) {
						data.push(outerFill, outerPath, new GraphicsEndFill());
					} else {
						data.push(
							outerFill, outerPath, innerPath, new GraphicsEndFill(),
							innerFill, innerPath, new GraphicsEndFill()
						);
					}
				} else {
					data.push(outerFill, outerPath, innerPath, new GraphicsEndFill());
				}
			}
			
			///// draw
			if (data.length) {
				canvas.drawGraphicsData(data);
			}
		}
		
		
		
		
		
		//---------------------------------------
		// get path
		//---------------------------------------
		protected function _getOuterPath():GraphicsPath {
			///// override
			return null;
		}
		protected function _getInnerPath():GraphicsPath {
			///// override
			return null;
		}
	}
}