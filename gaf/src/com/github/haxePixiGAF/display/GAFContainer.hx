package com.github.haxePixiGAF.display;

import com.github.haxePixiGAF.data.config.CFilter;
import pixi.core.display.Container;
import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.math.Matrix;
import pixi.core.math.Point;
import haxe.extern.EitherType;

/**
 * ...
 * @author Mathieu Anthoine
 */
class GAFContainer extends Container implements IGAFDisplayObject implements IMaxSize
{

	private static var HELPER_MATRIX:Matrix=new Matrix();
	
	private var _maxSize:Point;

	//private var _filterChain:GAFFilterChain;
	private var _filterConfig:CFilter;
	private var _filterScale:Float;
	
	public function new() 
	{
		super();
		
	}
	
	public var transformationMatrix(get_transformationMatrix,set_transformationMatrix):Matrix;
	private function get_transformationMatrix():Matrix {
		return localTransform;
		
	}
	private function set_transformationMatrix(matrix:Matrix):Matrix {
		return localTransform=matrix;
	}
	
	public var maxSize(get_maxSize, set_maxSize):Point;
 	private function get_maxSize():Point
	{
		return _maxSize;
	}

	private function set_maxSize(value:Point):Point
	{
		return _maxSize=value;
	}
	
		/**  */
	public function setFilterConfig(value:CFilter, scale:Float=1):Void
	{
		//TODO: setFilterConfig
		//trace ("TODO: setFilterConfig");
		
		//if(!Starling.current.contextValid)
		//{
			//return;
		//}
//
		//if(_filterConfig !=value || _filterScale !=scale)
		//{
			//if(value!=null)
			//{
				//_filterConfig=value;
				//_filterScale=scale;
//
				//if(_filterChain)
				//{
					//_filterChain.dispose();
				//}
				//else
				//{
					//_filterChain=new GAFFilterChain();
				//}
//
				//_filterChain.setFilterData(_filterConfig);
//
				//filter=_filterChain;
			//}
			//else
			//{
				//if(filter)
				//{
					//filter.dispose();
					//filter=null;
				//}
//
				//_filterChain=null;
				//_filterConfig=null;
				//_filterScale=NaN;
			//}
		//}
	}
	
	public function invalidateOrientation():Void
	{
		//_orientationChanged=true;
	}
	
	public var pivotMatrix(get_pivotMatrix, null):Matrix;
 	private function get_pivotMatrix():Matrix
	{
		//HELPER_MATRIX.copyFrom(_pivotMatrix);
		HELPER_MATRIX.identity();

		//if(_pivotChanged)
		//{
			//HELPER_MATRIX.tx=pivotX;
			//HELPER_MATRIX.ty=pivotY;
		//}

		return HELPER_MATRIX;
	}
	
}