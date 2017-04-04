package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
class CStage
{
	public var fps:Int;
	//public var color:Int;
	public var color:Float;
	public var width:Int;
	public var height:Int;
	
	public function new() {}
	
	public function clone(source:Dynamic):CStage
	{
		fps=source.fps;
		color=source.color;
		width=source.width;
		height=source.height;
		
		return this;
	}
}