package com.github.haxePixiGAF.display;
import pixi.core.math.Point;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
interface IMaxSize
{	
	public var maxSize(get_maxSize, set_maxSize):Point;
 	private function get_maxSize(): Point;
 	private function set_maxSize(value:Point): Point;
	
}