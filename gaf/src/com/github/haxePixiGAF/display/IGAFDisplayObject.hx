package com.github.haxePixiGAF.display;
import com.github.haxePixiGAF.data.config.CFilter;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.math.Matrix;
import haxe.extern.EitherType;

/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * @private
 */
interface IGAFDisplayObject
{
	function setFilterConfig(value:CFilter, scale:Float=1):Void;
	function invalidateOrientation():Void;
	
	function destroy(?options:EitherType<Bool, DestroyOptions>):Void;

	public var alpha:Float;

	public var transformationMatrix(get_transformationMatrix,set_transformationMatrix):Matrix;
	private function get_transformationMatrix():Matrix;
	private function set_transformationMatrix(matrix:Matrix):Matrix;

	public var pivotMatrix(get_pivotMatrix,null):Matrix;
	private function get_pivotMatrix():Matrix;

	public var name:String;

}
