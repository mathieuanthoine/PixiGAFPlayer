package com.github.haxePixiGAF.display;

/**
 * TODO
 * @author Mathieu Anthoine
 * @private
 */
interface IGAFDebug
{
	public var debugColors(null, set_debugColors):Array<Int>;
	private function set_debugColors(value:Array<Int>):Array<Int>;
}