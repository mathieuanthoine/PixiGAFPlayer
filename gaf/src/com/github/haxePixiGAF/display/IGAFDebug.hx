package com.github.haxePixiGAF.display;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
interface IGAFDebug
{
	public var debugColors(null, set_debugColors):Array<Int>;
	private function set_debugColors(value:Array<Int>):Array<Int>;
}