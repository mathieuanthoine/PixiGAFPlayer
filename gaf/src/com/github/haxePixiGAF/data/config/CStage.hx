package com.github.haxePixiGAF.data.config;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CStage
{
	public var fps:Int=0;
	//public var color:Int=0;
	public var color:Float=0;
	public var width:Int=0;
	public var height:Int=0;
	
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