/*
Copyright (c) 2009 Taro Hanamura
See LICENSE.txt for full license information.
*/

package org.typefest.display.shape {
	import flash.display.Sprite;
	import org.typefest.utils.Col;
	
	public class RectShape extends Sprite {
		public static const INSIDE:String  = "inside";
		public static const CENTER:String  = "center";
		public static const OUTSIDE:String = "outside";
		
		protected var _line:int         = 0x000000;
		protected var _lineA:Number     = 1;
		protected var _fill:int         = 0xffffff;
		protected var _fillA:Number     = 1;
		protected var _lineWidth:Number = 1;
		protected var _side:String      = INSIDE;
		
		protected var _width:Number  = 0;
		protected var _height:Number = 0;
		
		/* ============== */
		/* = Line Color = */
		/* ============== */
		public function get line():int {
			return this._line;
		}
		public function set line(num:int):void {
			if(this._line !== num) {
				this._line = num;
				this._update();
			}
		}
		public function get lineA():Number {
			return this._lineA;
		}
		public function set lineA(num:Number):void {
			if(this._lineA !== num) {
				this._lineA = num;
				this._update();
			}
		}
		
		/* ================== */
		/* = Line Color RGB = */
		/* ================== */
		public function get lineR():int {
			return Col.splitRGB(this._line)[0];
		}
		public function get lineG():int {
			return Col.splitRGB(this._line)[1];
		}
		public function get lineB():int {
			return Col.splitRGB(this._line)[2];
		}
		public function set lineR(num:int):void {
			var rgb:Array = Col.splitRGB(this._line);
			rgb[0]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._line !== color) {
				this._line = color;
				this._update();
			}
		}
		public function set lineG(num:int):void {
			var rgb:Array = Col.splitRGB(this._line);
			rgb[1]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._line !== color) {
				this._line = color;
				this._update();
			}
		}
		public function set lineB(num:int):void {
			var rgb:Array = Col.splitRGB(this._line);
			rgb[2]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._line !== color) {
				this._line = color;
				this._update();
			}
		}
		
		/* ============== */
		/* = Fill Color = */
		/* ============== */
		public function get fill():int {
			return this._fill;
		}
		public function set fill(num:int):void {
			if(this._fill !== num) {
				this._fill = num;
				this._update();
			}
		}
		public function get fillA():Number {
			return this._fillA;
		}
		public function set fillA(num:Number):void {
			if(this._fillA !== num) {
				this._fillA = num;
				this._update();
			}
		}
		
		/* ================== */
		/* = Fill Color RGB = */
		/* ================== */
		public function get fillR():int {
			return Col.splitRGB(this._fill)[0];
		}
		public function get fillG():int {
			return Col.splitRGB(this._fill)[1];
		}
		public function get fillB():int {
			return Col.splitRGB(this._fill)[2];
		}
		public function set fillR(num:int):void {
			var rgb:Array = Col.splitRGB(this._fill);
			rgb[0]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._fill !== color) {
				this._fill = color;
				this._update();
			}
		}
		public function set fillG(num:int):void {
			var rgb:Array = Col.splitRGB(this._fill);
			rgb[1]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._fill !== color) {
				this._fill = color;
				this._update();
			}
		}
		public function set fillB(num:int):void {
			var rgb:Array = Col.splitRGB(this._fill);
			rgb[2]        = num;
			var color:int = Col.joinRGB.apply(null, rgb);
			
			if(this._fill !== color) {
				this._fill = color;
				this._update();
			}
		}
		
		/* =================== */
		/* = Line Attributes = */
		/* =================== */
		public function get lineWidth():Number {
			return this._lineWidth;
		}
		public function set lineWidth(num:Number):void {
			if(this._lineWidth !== num) {
				this._lineWidth = num;
				this._update();
			}
		}
		public function get side():String {
			return this._side;
		}
		public function set side(str:String):void {
			if(this._side !== str) {
				this._side = str;
				this._update();
			}
		}
		
		/* ======== */
		/* = Size = */
		/* ======== */
		public override function get width():Number {
			return this._width;
		}
		public override function get height():Number {
			return this._height;
		}
		public override function set width(num:Number):void {
			if(this._width !== num) {
				this._width = num;
				this._update();
			}
		}
		public override function set height(num:Number):void {
			if(this._height !== num) {
				this._height = num;
				this._update();
			}
		}
		
		/* =============== */
		/* = Constructor = */
		/* =============== */
		public function RectShape() {}
		
		protected function _update():void {
			this.graphics.clear();
			
			if(this._width <= 0 || this._height <= 0) {
				return;
			}
			
			var outerX:Number;
			var outerY:Number;
			var outerWidth:Number;
			var outerHeight:Number;
			var innerX:Number;
			var innerY:Number;
			var innerWidth:Number;
			var innerHeight:Number;
			
			switch(this._side) {
				case INSIDE:
					outerX      = 0;
					outerY      = 0;
					outerWidth  = this._width;
					outerHeight = this._height;
					innerX      = this._lineWidth;
					innerY      = this._lineWidth;
					innerWidth  = this._width - (this._lineWidth * 2);
					innerHeight = this._height - (this._lineWidth * 2);
					break;
				case CENTER:
					outerX      = -(this._lineWidth / 2);
					outerY      = -(this._lineWidth / 2);
					outerWidth  = this._width + this._lineWidth;
					outerHeight = this._height + this._lineWidth;
					innerX      = this._lineWidth / 2;
					innerY      = this._lineWidth / 2;
					innerWidth  = this._width - this._lineWidth;
					innerHeight = this._height - this._lineWidth;
					break;
				case OUTSIDE:
					outerX      = -this._lineWidth;
					outerY      = -this._lineWidth;
					outerWidth  = this._width + (this._lineWidth * 2);
					outerHeight = this._height + (this._lineWidth * 2);
					innerX      = 0;
					innerY      = 0;
					innerWidth  = this._width;
					innerHeight = this._height;
					break;
			}
			
			if(this._line === this._fill && this._lineA === this._fillA) {
				this.graphics.beginFill(this._line, this._lineA);
				this.graphics.drawRect(outerX, outerY, outerWidth, outerHeight);
				this.graphics.endFill();
			} else {
				if(this._lineWidth !== 0) {
					this.graphics.beginFill(this._line, this._lineA);
					this.graphics.drawRect(outerX, outerY, outerWidth, outerHeight);
					if(this._fillA < 1) {
						this.graphics.drawRect(innerX, innerY, innerWidth, innerHeight);
					}
					this.graphics.endFill();
				}
				
				this.graphics.beginFill(this._fill, this._fillA);
				this.graphics.drawRect(innerX, innerY, innerWidth, innerHeight);
				this.graphics.endFill();
			}
		}
	}
}