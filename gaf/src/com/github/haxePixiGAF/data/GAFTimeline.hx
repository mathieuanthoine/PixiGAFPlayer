package com.github.haxePixiGAF.data;

import com.github.haxePixiGAF.data.config.CAnimationObject;
import com.github.haxePixiGAF.data.config.CTextureAtlas;
import com.github.haxePixiGAF.data.config.CTextureAtlasCSF;
import com.github.haxePixiGAF.data.config.CTextureAtlasScale;
import com.github.haxePixiGAF.data.converters.ErrorConstants;
import com.github.haxePixiGAF.data.textures.TextureWrapper;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.sound.GAFSoundData;


/**
 *<p>GAFTimeline represents converted GAF file. It is like a library symbol in Flash IDE that contains all information about GAF animation.
 * It is used to create<code>GAFMovieClip</code>that is ready animation object to be used in starling display list</p>
 */
/**
 * TODO
 * @author Mathieu Anthoine
 */
@:expose("GAF.GAFTimeline")
class GAFTimeline
{
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	public static inline var CONTENT_ALL:String="contentAll";
	public static inline var CONTENT_DEFAULT:String="contentDefault";
	public static inline var CONTENT_SPECIFY:String="contentSpecify";

	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------

	private var _config:GAFTimelineConfig;

	private var _gafSoundData:GAFSoundData;
	
	private var _gafgfxData:GAFGFXData;
	private var _gafAsset:GAFAsset;

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------

	/**
	 * Creates an GAFTimeline object
	 * @param timelineConfig GAF timeline config
	 */
	public function new(timelineConfig:GAFTimelineConfig)
	{
		_config=timelineConfig;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	// --------------------------------------------------------------------------

	/**
	 * Returns GAF Texture by name of an instance inside a timeline.
	 * @param animationObjectName name of an instance inside a timeline
	 * @return GAF Texture
	 */
	public function getTextureByName(animationObjectName:String):IGAFTexture
	{
		var instanceID:String=_config.getNamedPartID(animationObjectName);
		if(instanceID!=null)
		{
			var part:CAnimationObject=_config.animationObjects.getAnimationObject(instanceID);
			if(part!=null)
			{
				return textureAtlas.getTexture(part.regionID);
			}
		}
		return null;
	}

	/**
	 * Disposes the underlying GAF timeline config
	 */
	public function dispose():Void
	{
		_config.dispose();
		_config=null;
		_gafAsset=null;
		_gafgfxData=null;
		_gafSoundData=null;
	}

	/**
	 * Load all graphical data connected with this asset in device GPU memory. Used in case of manual control of GPU memory usage.
	 * Works only in case when all graphical data stored in RAM.
	 *
	 * @param content content type that should be loaded. Available types:<code>CONTENT_ALL, CONTENT_DEFAULT, CONTENT_SPECIFY</code>
	 * @param scale in case when specified content is<code>CONTENT_SPECIFY</code>scale and csf should be set in required values
	 * @param csf in case when specified content is<code>CONTENT_SPECIFY</code>scale and csf should be set in required values
	 */
	public function loadInVideoMemory(content:String="contentDefault", ?pScale:Float, ?csf:Float):Void
	{

		if(_config.textureAtlas==null || _config.textureAtlas.contentScaleFactor.elements==null)
		{
			return;
		}

		var textures:Map<String,TextureWrapper>;
		var csfConfig:CTextureAtlasCSF;

		switch(content)
		{
			case CONTENT_ALL:
				for(scaleConfig in _config.allTextureAtlases)
				{
					for(csfConfig in scaleConfig.allContentScaleFactors)
					{
						_gafgfxData.createTextures(scaleConfig.scale, csfConfig.csf);

						textures=_gafgfxData.getTextures(scaleConfig.scale, csfConfig.csf);
						if(csfConfig.atlas==null && textures!=null)
						{
							csfConfig.atlas=CTextureAtlas.createFromTextures(textures, csfConfig);
						}
					}
				}
				return;

			case CONTENT_DEFAULT:
				csfConfig=_config.textureAtlas.contentScaleFactor;

				if(csfConfig==null)
				{
					return;
				}
			
				if(csfConfig.atlas==null && _gafgfxData.createTextures(scale, contentScaleFactor))
				{
					csfConfig.atlas = CTextureAtlas.createFromTextures(_gafgfxData.getTextures(scale, contentScaleFactor), csfConfig);
				}

				return;

			case CONTENT_SPECIFY:
				csfConfig=getCSFConfig(pScale, csf);

				if(csfConfig==null)
				{
					return;
				}

				if(csfConfig.atlas==null && _gafgfxData.createTextures(pScale, csf))
				{
					csfConfig.atlas=CTextureAtlas.createFromTextures(_gafgfxData.getTextures(pScale, csf), csfConfig);
				}
				return;
		}
	}

	/**
	 * Unload all all graphical data connected with this asset from device GPU memory. Used in case of manual control of video memory usage
	 *
	 * @param content content type that should be loaded(CONTENT_ALL, CONTENT_DEFAULT, CONTENT_SPECIFY)
	 * @param scale in case when specified content is CONTENT_SPECIFY scale and csf should be set in required values
	 * @param csf in case when specified content is CONTENT_SPECIFY scale and csf should be set in required values
	 */
	public function unloadFromVideoMemory(content:String="contentDefault", ?pScale:Float, ?csf:Float):Void
	{
		if(_config.textureAtlas==null || _config.textureAtlas.contentScaleFactor.elements==null)
		{
			return;
		}

		var csfConfig:CTextureAtlasCSF;

		switch(content)
		{
			case CONTENT_ALL:
				_gafgfxData.disposeTextures();
				_config.dispose();
				return;
			case CONTENT_DEFAULT:
				_gafgfxData.disposeTextures(pScale, contentScaleFactor);
				_config.textureAtlas.contentScaleFactor.dispose();
				return;
			case CONTENT_SPECIFY:
				csfConfig=getCSFConfig(pScale, csf);
				if(csfConfig!=null)
				{
					_gafgfxData.disposeTextures(pScale, csf);
					csfConfig.dispose();
				}
				return;
		}
	}

	public function startSound(frame:Int):Void
	{
		//var frameSoundConfig:CFrameSound=_config.getSound(frame);
		//if(frameSoundConfig)
		//{
			//if(frameSoundConfig.action==CFrameSound.ACTION_STOP)
			//{
				//GAFSoundManager.getInstance().stop(frameSoundConfig.soundID, _config.assetID);
			//}
			//else
			//{
				//var sound:Sound;
				//if(frameSoundConfig.linkage)
				//{
					//sound=gafSoundData.getSoundByLinkage(frameSoundConfig.linkage);
				//}
				//else
				//{
					//sound=gafSoundData.getSound(frameSoundConfig.soundID, _config.assetID);
				//}
				//var soundOptions:Dynamic={};
				//soundOptions["continue"]=frameSoundConfig.action==CFrameSound.ACTION_CONTINUE;
				//soundOptions["repeatCount"]=frameSoundConfig.repeatCount;
				//GAFSoundManager.getInstance().play(sound, frameSoundConfig.soundID, soundOptions, _config.assetID);
			//}
		//}
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function getCSFConfig(scale:Float, csf:Float):CTextureAtlasCSF
	{
		var scaleConfig:CTextureAtlasScale=_config.getTextureAtlasForScale(scale);

		if(scaleConfig!=null)
		{
			var csfConfig:CTextureAtlasCSF=scaleConfig.getTextureAtlasForCSF(csf);
			
			if(csfConfig!=null)
			{
				return csfConfig;
			}
			else
			{
				return null;
			}
		}
		else
		{
			return null;
		}
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
	 * Timeline identifier(name given at animation's upload or assigned by developer)
	 */
	public var id(get_id, null):String;
 	private function get_id():String
	{
		return config.id;
	}

	/**
	 * Timeline linkage in a *.fla file library
	 */
	public var linkage(get_linkage, null):String;
 	private function get_linkage():String
	{
		return config.linkage;
	}

	/**
	 * Asset identifier(name given at animation's upload or assigned by developer)
	 */
	public var assetID(get_assetID, null):String;
 	private function get_assetID():String
	{
		return config.assetID;
	}

	public var textureAtlas(get_textureAtlas, null):CTextureAtlas;
 	private function get_textureAtlas():CTextureAtlas
	{
		
		if(_config.textureAtlas==null)
		{
			return null;
		}

		if(_config.textureAtlas.contentScaleFactor.atlas==null)
		{
			loadInVideoMemory(CONTENT_DEFAULT);
		}
		
		return _config.textureAtlas.contentScaleFactor.atlas;
	}

	public var config(get_config, null):GAFTimelineConfig;
 	private function get_config():GAFTimelineConfig
	{
		return _config;
	}

	////////////////////////////////////////////////////////////////////////////

	/**
	 * Texture atlas scale that will be used for<code>GAFMovieClip</code>creation. To create<code>GAFMovieClip's</code>
	 * with different scale assign appropriate scale to<code>GAFTimeline</code>and only after that instantiate<code>GAFMovieClip</code>.
	 * Possible values are values from converted animation config. They are depends from project settings on site converter
	 */
	private function set_scale(value:Float):Float
	{
		var scale:Float=_gafAsset.getValidScale(value);
		if(Math.isNaN(scale))
		{
			throw ErrorConstants.SCALE_NOT_FOUND;
		}
		else
		{
			_gafAsset.scale=scale;
		}

		if(_config.textureAtlas==null)
		{
			//return;
			return null;
		}

		var csf:Float=contentScaleFactor;
		var taScale:CTextureAtlasScale=_config.getTextureAtlasForScale(scale);
		if(taScale!=null)
		{
			_config.textureAtlas=taScale;

			var taCSF:CTextureAtlasCSF=_config.textureAtlas.getTextureAtlasForCSF(csf);

			if(taCSF!=null)
			{
				_config.textureAtlas.contentScaleFactor=taCSF;
			}
			else
			{
				throw "There is no csf " + csf + "in timeline config for scalse " + scale;
			}
		}
		else
		{
			throw "There is no scale " + scale + "in timeline config";
		}
		
		return _gafAsset.scale;
	}

	public var scale(get_scale, set_scale):Float;
 	private function get_scale():Float
	{
		return _gafAsset.scale;
	}

	/**
	 * Texture atlas content scale factor(csf)that will be used for<code>GAFMovieClip</code>creation. To create<code>GAFMovieClip's</code>
	 * with different csf assign appropriate csf to<code>GAFTimeline</code>and only after that instantiate<code>GAFMovieClip</code>.
	 * Possible values are values from converted animation config. They are depends from project settings on site converter
	 */
	private function set_contentScaleFactor(csf:Float):Void
	{
		if(_gafAsset.hasCSF(csf))
		{
			_gafAsset.csf=csf;
		}

		if(_config.textureAtlas==null)
		{
			return;
		}

		var taCSF:CTextureAtlasCSF=_config.textureAtlas.getTextureAtlasForCSF(csf);

		if(taCSF!=null)
		{
			_config.textureAtlas.contentScaleFactor=taCSF;
		}
		else
		{
			throw "There is no csf " + csf + "in timeline config";
		}
	}

	public var contentScaleFactor(get_contentScaleFactor, null):Float;
 	private function get_contentScaleFactor():Float
	{
		return _gafAsset.csf;
	}

	/**
	 * Graphical data storage that used by<code>GAFTimeline</code>.
	 */
	private function set_gafgfxData(gafgfxData:GAFGFXData):GAFGFXData
	{
		return _gafgfxData=gafgfxData;
	}

	public var gafgfxData(get_gafgfxData, set_gafgfxData):GAFGFXData;
 	private function get_gafgfxData():GAFGFXData
	{
		return _gafgfxData;
	}

	public var gafAsset(get_gafAsset, set_gafAsset):GAFAsset;
 	private function get_gafAsset():GAFAsset
	{
		return _gafAsset;
	}

	private function set_gafAsset(asset:GAFAsset):GAFAsset
	{
		return _gafAsset=asset;
	}

	public var gafSoundData(get_gafSoundData, set_gafSoundData):GAFSoundData;
 	private function get_gafSoundData():GAFSoundData
	{
		return _gafSoundData;
	}

	private function set_gafSoundData(gafSoundData:GAFSoundData):GAFSoundData
	{
		return _gafSoundData=gafSoundData;
	}

	//--------------------------------------------------------------------------
	//
	//  STATIC METHODS
	//
	//--------------------------------------------------------------------------
}