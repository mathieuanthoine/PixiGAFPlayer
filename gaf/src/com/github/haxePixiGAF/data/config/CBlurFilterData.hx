package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CBlurFilterData implements ICFilterData
{
	public var blurX:Float;
	public var blurY:Float;
	public var color:Int;
	public var angle:Float=0;
	public var distance:Float=0;
	public var strength:Float=0;
	public var alpha:Float=1;
	public var inner:Bool=false;
	public var knockout:Bool=false;
	public var resolution:Float=1;
	
	public function new () {}
	
	public function clone():ICFilterData
	{
		
		var copy:CBlurFilterData=new CBlurFilterData();
		
		copy.blurX=blurX;
		copy.blurY=blurY;
		copy.color=color;
		copy.angle=angle;
		copy.distance=distance;
		copy.strength=strength;
		copy.alpha=alpha;
		copy.inner=inner;
		copy.knockout=knockout;
		copy.resolution=resolution;
		
		return copy;
	}

}