package com.github.haxePixiGAF.data;

import com.github.haxePixiGAF.data.config.CTextureAtlasCSF;
import com.github.haxePixiGAF.data.config.CTextureAtlasElement;
import com.github.haxePixiGAF.data.config.CTextureAtlasScale;
import com.github.haxePixiGAF.data.textures.TextureWrapper;
import com.github.haxePixiGAF.display.GAFScale9Texture;
import com.github.haxePixiGAF.display.GAFTexture;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.utils.MathUtility;
import pixi.core.math.Matrix;

/**
 * TODO
 * @author Mathieu Anthoine
 * 
 */
class GAFAsset
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

	private var _config:GAFAssetConfig;

	private var _timelines:Array<GAFTimeline>;
	private var _timelinesDictionary:Map<String,GAFTimeline>=new Map<String,GAFTimeline>();
	private var _timelinesByLinkage:Map<String,GAFTimeline>=new Map<String,GAFTimeline>();

	private var _scale:Float;
	private var _csf:Float;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	public function new(config:GAFAssetConfig)
	{
		_config=config;

		_scale=config.defaultScale;
		_csf=config.defaultContentScaleFactor;

		_timelines=new Array<GAFTimeline>();
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------

	/**
	 * Disposes all assets in bundle
	 */
	public function dispose():Void
	{
		if(_timelines.length>0)
		{
			for(timeline in _timelines)
			{
				timeline.dispose();
			}
		}
		_timelines=null;

		_config.dispose();
		_config=null;
	}

	/**  */
	public function addGAFTimeline(timeline:GAFTimeline):Void
	{
		if(_timelinesDictionary[timeline.id]==null)
		{
			_timelinesDictionary[timeline.id]=timeline;
			_timelines.push(timeline);

			if(timeline.config.linkage!=null)
			{
				_timelinesByLinkage[timeline.linkage]=timeline;
			}
		}
		else
		{
			throw "Bundle error. More then one timeline use id:'" + timeline.id + "'";
		}
	}

	/**
	 * Returns<code>GAFTimeline</code>from gaf asset by linkage
	 * @param linkage linkage in a *.fla file library
	 * @return<code>GAFTimeline</code>from gaf asset
	 */
	public function getGAFTimelineByLinkage(linkage:String):GAFTimeline
	{
		var gafTimeline:GAFTimeline=_timelinesByLinkage[linkage];

		return gafTimeline;
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	/** 
	 * Returns<code>GAFTimeline</code>from gaf asset by ID
	 * @param id Internal timeline id
	 * @return<code>GAFTimeline</code>from gaf asset
	 */
	//gaf_private function getGAFTimelineByID(id:String):GAFTimeline
	public function getGAFTimelineByID(id:String):GAFTimeline
	{
		return _timelinesDictionary[id];
	}

	/** 
	 * Returns<code>GAFTimeline</code>from gaf asset bundle by linkage
	 * @param linkage linkage in a *.fla file library
	 * @return<code>GAFTimeline</code>from gaf asset
	 */
	///*gaf_private*/ function gaf_private_getGAFTimelineByLinkage(linkage:String):GAFTimeline
	//{
		//return _timelinesByLinkage[linkage];
	//}

	public function getCustomRegion(linkage:String, ?scale:Float, ?csf:Float):IGAFTexture
	{
		if(scale==null)scale=_scale;
		if(csf==null) csf=_csf;

		var gafTexture:IGAFTexture=null;
		var atlasScale:CTextureAtlasScale;
		var atlasCSF:CTextureAtlasCSF;
		var element:CTextureAtlasElement;
		
		var tasl:Int = _config.allTextureAtlases.length;
		
		for(i in 0...tasl)
		{
			atlasScale=_config.allTextureAtlases[i];
			if(atlasScale.scale==scale)
			{
				var tacsfl:Int = atlasScale.allContentScaleFactors.length;
				for(j in 0...tacsfl)
				{
					atlasCSF=atlasScale.allContentScaleFactors[j];
					if(atlasCSF.csf==csf)
					{
						element=atlasCSF.elements.getElementByLinkage(linkage);

						if(element!=null)
						{
							var texture:TextureWrapper=atlasCSF.atlas.getTextureByIDAndAtlasID(element.id, element.atlasID);
							var pivotMatrix:Matrix=element.pivotMatrix;
							if(element.scale9Grid !=null)
							{
								gafTexture=new GAFScale9Texture(id, texture, pivotMatrix, element.scale9Grid);
							}
							else
							{
								gafTexture=new GAFTexture(id, texture, pivotMatrix);
							}
						}

						break;
					}
				}
				break;
			}
		}

		return gafTexture;
	}

	public function getValidScale(value:Float):Float
	{
		var index:Int=MathUtility.getItemIndex(_config.scaleValues, value);
		if(index !=-1)
		{
			return _config.scaleValues[index];
		}
		return Math.NaN;
	}

	public function hasCSF(value:Float):Bool
	{
		return MathUtility.getItemIndex(_config.csfValues, value)>=0;
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

	/**
	 * Returns all<code>GAFTimeline's</code>from gaf asset as<code>Vector</code>
	 * @return<code>GAFTimeline's</code>from gaf asset
	 */
	public var timelines(get_timelines, null):Array<GAFTimeline>;
 	private function get_timelines():Array<GAFTimeline>
	{
		return _timelines;
	}

	public var id(get_id, null):String;
 	private function get_id():String
	{
		return _config.id;
	}

	public var scale(get_scale, set_scale):Float;
 	private function get_scale():Float
	{
		return _scale;
	}

	private function set_scale(value:Float):Float
	{
		return _scale=value;
	}

	public var csf(get_csf, set_csf):Float;
 	private function get_csf():Float
	{
		return _csf;
	}

	private function set_csf(value:Float):Float
	{
		return _csf=value;
	}
}