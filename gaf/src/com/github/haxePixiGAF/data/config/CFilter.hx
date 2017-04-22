package com.github.haxePixiGAF.data.config;
import com.github.haxePixiGAF.utils.VectorUtility;


/**
 * AS3 Conversion
 * @author Mathieu Anthoine
 * 
 */
class CFilter
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	private var _filterConfigs:Array<ICFilterData>=new Array<ICFilterData>();

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	public function new () {}
	
	public function clone():CFilter
	{
		var result:CFilter=new CFilter();

		for(filterData in _filterConfigs)
		{
			result.filterConfigs.push(filterData.clone());
		}

		return result;
	}

	public function addBlurFilter(blurX:Float, blurY:Float):String
	{
		var filterData:CBlurFilterData=new CBlurFilterData();
		filterData.blurX=blurX;
		filterData.blurY=blurY;
		filterData.color=-1;

		_filterConfigs.push(filterData);

		return "";
	}

	public function addGlowFilter(blurX:Float, blurY:Float, color:Int, alpha:Float,
								  strength:Float=1, inner:Bool=false, knockout:Bool=false):String
	{
		var filterData:CBlurFilterData=new CBlurFilterData();
		filterData.blurX=blurX;
		filterData.blurY=blurY;
		filterData.color=color;
		filterData.alpha=alpha;
		filterData.strength=strength;
		filterData.inner=inner;
		filterData.knockout=knockout;

		_filterConfigs.push(filterData);

		return "";
	}

	public function addDropShadowFilter(blurX:Float, blurY:Float, color:Int, alpha:Float, angle:Float, distance:Float,
										strength:Float=1, inner:Bool=false, knockout:Bool=false):String
	{
		var filterData:CBlurFilterData=new CBlurFilterData();
		filterData.blurX=blurX;
		filterData.blurY=blurY;
		filterData.color=color;
		filterData.alpha=alpha;
		filterData.angle=angle;
		filterData.distance=distance;
		filterData.strength=strength;
		filterData.inner=inner;
		filterData.knockout=knockout;

		_filterConfigs.push(filterData);

		return "";
	}

	public function addColorTransform(params:Array<Float>):Void
	{
		if(getColorMatrixFilter()!=null)
		{
			return;
		}

		var filterData:CColorMatrixFilterData=new CColorMatrixFilterData();
		VectorUtility.fillMatrix(filterData.matrix,
				params[1], 0, 0, 0, params[2],
				0, params[3], 0, 0, params[4],
				0, 0, params[5], 0, params[6],
							   0, 0, 0, 1, 0);
		_filterConfigs.push(filterData);
	}

	public function addColorMatrixFilter(params:Array<Float>):String
	{
		var i:Int;

		for(i in 0...params.length)
		{
			if(i % 5==4)
			{
				params[i]=params[i] / 255;
			}
		}

//			var colorMatrixFilterConfig:CColorMatrixFilterData=getColorMatrixFilter();
//
//			if(colorMatrixFilterConfig)
//			{
//				return WarningConstants.CANT_COLOR_ADJ_CT;
//			}
//			else
//			{
			var colorMatrixFilterConfig:CColorMatrixFilterData=new CColorMatrixFilterData();
			VectorUtility.copyMatrix(colorMatrixFilterConfig.matrix, params);
			_filterConfigs.push(colorMatrixFilterConfig);
//			}

		return "";
	}

	public function getBlurFilter():CBlurFilterData
	{
		for(filterConfig in _filterConfigs)
		{
			if(Std.is(filterConfig, CBlurFilterData))
			{
				return cast(filterConfig,CBlurFilterData);
			}
		}

		return null;
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function getColorMatrixFilter():CColorMatrixFilterData
	{
		for(filterConfig in _filterConfigs)
		{
			if(Std.is(filterConfig, CColorMatrixFilterData))
			{
				return cast(filterConfig,CColorMatrixFilterData);
			}
		}

		return null;
	}

	//--------------------------------------------------------------------------
	//
	// OVERRIDDEN METHODS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  EVENT HANDLERS
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------

	public var filterConfigs(get_filterConfigs, null):Array<ICFilterData>;
 	private function get_filterConfigs():Array<ICFilterData>
	{
		return _filterConfigs;
	}

}