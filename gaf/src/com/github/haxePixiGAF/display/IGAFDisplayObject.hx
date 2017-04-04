package com.github.haxePixiGAF.display;
import com.github.haxePixiGAF.data.config.CFilter;
import pixi.core.display.Container;
import pixi.core.math.Matrix;

/**
 * AS3 TODO
 * @author Mathieu Anthoine
 * @private
 */
interface IGAFDisplayObject
{
	function setFilterConfig(value:CFilter, scale:Float=1):Void;
	function invalidateOrientation():Void;
	
	function destroy():Void;

	public var alpha:Float;

	//public var parent(get_parent,null):Container;
	//private function get_parent():Container;

	//public var visible(get_visible,set_visible):Float;
	//private function get_visible():Float;
	//private function set_visible(value:Float):Float;

	public var transformationMatrix(get_transformationMatrix,set_transformationMatrix):Matrix;
	private function get_transformationMatrix():Matrix;
	private function set_transformationMatrix(matrix:Matrix):Matrix;

	public var pivotMatrix(get_pivotMatrix,null):Matrix;
	private function get_pivotMatrix():Matrix;

	public var name:String;

}
