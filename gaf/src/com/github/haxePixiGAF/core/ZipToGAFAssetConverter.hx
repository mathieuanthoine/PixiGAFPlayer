package com.github.haxePixiGAF.core;
import com.github.haxePixiGAF.data.GAFAsset;
import com.github.haxePixiGAF.data.GAFAssetConfig;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFGFXData;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.data.GAFTimelineConfig;
import com.github.haxePixiGAF.data.config.CSound;
import com.github.haxePixiGAF.data.converters.BinGAFAssetConfigConverter;
import com.github.haxePixiGAF.data.tagfx.TAGFXBase;
import com.github.haxePixiGAF.data.tagfx.TAGFXsourcePixi;
import com.github.haxePixiGAF.events.GAFEvent;
import com.github.haxePixiGAF.sound.GAFSoundData;
import com.github.haxePixiGAF.utils.GAFBytesInput;
import com.github.haxePixiGAF.utils.MathUtility;
import pixi.interaction.EventEmitter;
import pixi.loaders.Loader;

using com.github.haxePixiGAF.utils.EventEmitterUtility;

/**
 * TODO
 * @author Mathieu Anthoine
 */

typedef AssetsList = Array<GAFLoader>; 
 
class ZipToGAFAssetConverter extends EventEmitter
{
	
	//--------------------------------------------------------------------------
	//
	//  PUBLIC VARIABLES
	//
	//--------------------------------------------------------------------------

	/**
	 * In process of conversion doesn't create textures (doesn't load in GPU memory).
	 * Be sure to set up <code>Starling.handleLostContext = true</code> when using this action, otherwise Error will occur
	 */
	public static inline var ACTION_DONT_LOAD_IN_GPU_MEMORY: String = "actionDontLoadInGPUMemory";

	/**
	 * In process of conversion create textures (load in GPU memory).
	 */
	public static inline var ACTION_LOAD_ALL_IN_GPU_MEMORY: String = "actionLoadAllInGPUMemory";

	/**
	 * In process of conversion create textures (load in GPU memory) only atlases for default scale and csf
	 */
	public static inline var ACTION_LOAD_IN_GPU_MEMORY_ONLY_DEFAULT: String = "actionLoadInGPUMemoryOnlyDefault";
	
	/**
	 * Action that should be applied to atlases in process of conversion. Possible values are action constants.
	 * By default loads in GPU memory only atlases for default scale and csf
	 */
	public static var actionWithAtlases: String = ACTION_LOAD_IN_GPU_MEMORY_ONLY_DEFAULT;
	
	
	//--------------------------------------------------------------------------
	//
	//  PRIVATE VARIABLES
	//
	//--------------------------------------------------------------------------	
	private var _id:String;

	//private var _zip:FZip;
	//private var _zipLoader:FZipLibrary;

	private var _currentConfigIndex:Int;
	private var _configConvertTimeout:Float;

	private var _gafAssetsIDs:Array<String>;
	private var _gafAssetConfigs:Map<String,GAFAssetConfig>;
	private var _gafAssetConfigSources:Map<String,GAFBytesInput>;

	private var _sounds:Array<CSound>;
	//private var _taGFXs:Map<String,TAGFXSourcePNGBA>;
	private var _taGFXs:Map<String,TAGFXBase>;

	private var _gfxData:GAFGFXData;
	private var _soundData:GAFSoundData;

	private var _gafBundle:GAFBundle;

	private var _defaultScale:Float;
	private var _defaultContentScaleFactor:Float;

	private var _parseConfigAsync:Bool=false;
	private var _ignoreSounds:Bool=false;

	///////////////////////////////////

	private var _gafAssetsConfigURLs:Array<Dynamic>;
	private var _gafAssetsConfigIndex:Int;

	private var _atlasSourceURLs:Array<Dynamic>;
	//private var _atlasSourceIndex:Int;
	
	//////////////////////////////////
	
	private var _loader:Loader;
	
	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------
		
	/** Creates a new<code>ZipToGAFAssetConverter</code>instance.
	 * @param id The id of the converter.
	 * If it is not empty<code>ZipToGAFAssetConverter</code>sets the<code>name</code>of produced bundle equal to this id.
	 */
	public function new(id:String=null)
	{
		super();
		_id=id;
	}

	//--------------------------------------------------------------------------
	//
	//  PUBLIC METHODS
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Converts GAF file(*.zip)into<code>GAFTimeline</code>or<code>GAFBundle</code>depending on file content.
	 * Because conversion process is asynchronous use<code>Event.COMPLETE</code>listener to trigger successful conversion.
	 * Use<code>ErrorEvent.ERROR</code>listener to trigger any conversion fail.
	 *
	 * @param data *.zip file binary or File object represents a path to a *.gaf file or directory with *.gaf config files
	 * @param defaultScale Scale value for<code>GAFTimeline</code>that will be set by default
	 * @param defaultContentScaleFactor Content scale factor(csf)value for<code>GAFTimeline</code>that will be set by default
	 */
	public function convert(data:Dynamic, ?defaultScale:Float, ?defaultContentScaleFactor:Float):Void
	{
		//TODO: revoir le format de data
		/*
		 * passer un tableau d'url vers des .gaf et gérer le chargement en interne ?
		 * un gaf plutot un tableau de GAFLoader ?
		 */
		
		/*
		if(ZipToGAFAssetConverter.actionWithAtlases==ZipToGAFAssetConverter.ACTION_DONT_LOAD_IN_GPU_MEMORY)
		{
			throw new Dynamic("Impossible parameters combination! Starling.handleLostContext=false and actionWithAtlases=ACTION_DONT_LOAD_ALL_IN_VIDEO_MEMORY One of the parameters must be changed!");
		}
		*/

		reset();
	
		_defaultScale=defaultScale;
		_defaultContentScaleFactor=defaultContentScaleFactor;

		if(_id!=null && _id.length>0)
		{
			_gafBundle.name=_id;
		}
		
		//TODO if (Std.is(data, ZipFile)) ; else
		if(Std.is(data, AssetsList)) parseVector(data);
		else
		{
			trace("ERROR");
			//zipProcessError(ErrorConstants.UNKNOWN_FORMAT, 6);
		}
		
	}
	
	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function reset():Void
	{
		//_zip=null;
		//_zipLoader=null;
		_currentConfigIndex=0;
		_configConvertTimeout=0;

		_sounds=new Array<CSound>();
		_taGFXs=new Map<String,TAGFXBase>();

		_gfxData=new GAFGFXData();
		//_soundData=new GAFSoundData();
		_gafBundle=new GAFBundle();
		_gafBundle.soundData=_soundData;

		_gafAssetsIDs=[];
		_gafAssetConfigs=new Map<String,GAFAssetConfig>();
		_gafAssetConfigSources=new Map<String,GAFBytesInput>();

		_gafAssetsConfigURLs=[];
		_gafAssetsConfigIndex=0;

		_atlasSourceURLs=[];
		//_atlasSourceIndex=0;
	}	
	
	private function findAllAtlasURLs():Void
	{
		
		_atlasSourceURLs=[];

		var url:String;
		var gafTimelineConfigs:Array<GAFTimelineConfig>;

		for(id in _gafAssetConfigs.keys())
		{
			gafTimelineConfigs=_gafAssetConfigs[id].timelines;

			for(config in gafTimelineConfigs)
			{
				var folderURL:String=getFolderURL(id);

				for(scale in config.allTextureAtlases)
				{
					if(Math.Math.isNaN(_defaultScale)|| MathUtility.equals(scale.scale, _defaultScale))
					{
						for(csf in scale.allContentScaleFactors)
						{
							if(Math.Math.isNaN(_defaultContentScaleFactor)|| MathUtility.equals(csf.csf, _defaultContentScaleFactor))
							{
								for(source in csf.sources)
								{
									url=folderURL + source.source;

									if(source.source !="no_atlas"
											&& _atlasSourceURLs.indexOf(url)==-1)
									{
										_atlasSourceURLs.push(url);
									}
								}
							}
						}
					}
				}
			}
		}

		if(_atlasSourceURLs.length>0)
		{
			_loader = new Loader();
			_loader.on(GAFEvent.COMPLETE, createGAFTimelines);
			
			var url:String;
			var fileName:String;
			var taGFX:TAGFXBase;
			
			for (_atlasSourceIndex in 0..._atlasSourceURLs.length) {
				url=_atlasSourceURLs[_atlasSourceIndex];
				fileName = url.substring(url.lastIndexOf("/") + 1);
				// TODO: verifier s'il ne faut pas plutot le faire à la fin
				taGFX = new TAGFXsourcePixi(url);
				_taGFXs[fileName] = taGFX;
				_loader.add(url);
			}
			_loader.load();
		}
		//else
		//{
			//createGAFTimelines();
		//}
	}
	
	private static function getFolderURL(url:String):String
	{
		var cutURL:String=url.split("?")[0];

		var lastIndex:Int=cutURL.lastIndexOf("/");
		
		return cutURL.substring(0, lastIndex + 1);
	}	
	
	private function parseVector(pData:AssetsList):Void
	{
		
		var length:Int=pData.length;

		var fileName:String;
		//var taGFX:TAGFXBase;

		//_taGFXs=new Map<TAGFXSourcePNGBA>();

		_gafAssetConfigSources=new Map<String,GAFBytesInput>();
		_gafAssetsIDs=[];

		for(i in 0...length)
		{
			fileName=pData[i].name;

			switch(fileName.substr(fileName.toLowerCase().lastIndexOf(".")))
			{
				case ".png":
					trace ("TODO PNG");
					//fileName=fileName.substring(fileName.lastIndexOf("/")+ 1);
					//var pngBA:Bytes=pData[i].content;
					//var pngSize:Point=FileUtils.getPNGBASize(pngBA);
					//taGFX=new TAGFXSourcePNGBA(pngBA, pngSize, textureFormat);
					//_taGFXs[fileName]=taGFX;	
				case ".gaf":									
					_gafAssetsIDs.push(fileName);
					_gafAssetConfigSources[fileName]=pData[i].content;
			}
		}

		convertConfig();
	}

	private function convertConfig():Void
	{
		//clearTimeout(_configConvertTimeout);
		//_configConvertTimeout=null;

		var configID:String = _gafAssetsIDs[_currentConfigIndex];		
		var configSource:GAFBytesInput=_gafAssetConfigSources[configID];
		var gafAssetID:String=getAssetId(_gafAssetsIDs[_currentConfigIndex]);
		
		if(Std.is(configSource, GAFBytesInput))
		{
			var converter:BinGAFAssetConfigConverter=new BinGAFAssetConfigConverter(gafAssetID, cast(configSource,GAFBytesInput));
			converter.defaultScale=_defaultScale;
			converter.defaultCSF=_defaultContentScaleFactor;
			converter.ignoreSounds = _ignoreSounds;
			converter.on(GAFEvent.COMPLETE, onConverted);
			converter.on(GAFEvent.ERROR, onConvertError);
			converter.convert(_parseConfigAsync);
		}
		else
		{
			throw "Error";
		}
	}
	
	private function createGAFTimelines(event:Dynamic=null):Void
	{
		
		if (event != null) {
			_loader.off(GAFEvent.COMPLETE, createGAFTimelines);
		}
		
		//if(event)
		//{
			//Starling.current.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, createGAFTimelines);
		//}
		//if(!Starling.current.contextValid)
		//{
			//Starling.current.stage3D.addEventListener(Event.CONTEXT3D_CREATE, createGAFTimelines);
		//}

		var gafTimelineConfigs:Array<GAFTimelineConfig>;
		var gafAssetConfigID:String;
		var gafAssetConfig:GAFAssetConfig=null;
		var gafAsset:GAFAsset=null;
		var i:Int;

		//for(taGFX in _taGFXs)
		//{
			//taGFX.clearSourceAfterTextureCreated=false;
		//}
		
		for(i in 0..._gafAssetsIDs.length)
		{
			gafAssetConfigID=_gafAssetsIDs[i];
			gafAssetConfig=_gafAssetConfigs[gafAssetConfigID];
			gafTimelineConfigs=gafAssetConfig.timelines;

			gafAsset=new GAFAsset(gafAssetConfig);
			for(config in gafTimelineConfigs)
			{
				gafAsset.addGAFTimeline(createTimeline(config, gafAsset));
			}

			_gafBundle.addGAFAsset(gafAsset);
		}

		if(gafAsset==null || gafAsset.timelines.length==0)
		{
			//zipProcessError(ErrorConstants.TIMELINES_NOT_FOUND);
			return;
		}

		if(_gafAssetsIDs.length==1)
		{
			if (_gafBundle.name==null) _gafBundle.name =gafAssetConfig.id;
		}

		//if(_soundData.gaf_internal::hasSoundsToLoad && !_ignoreSounds)
		//{
			//_soundData.gaf_internal::loadSounds(finalizeParsing, onSoundLoadIOError);
		//}
		//else
		//{
			finalizeParsing();
		//}
	}
	
	private function finalizeParsing():Void
	{
		_taGFXs=null;
		_sounds=null;

		emit(GAFEvent.COMPLETE,{target:this});
		
		return;
		
		//TODO: a supprimer si ca marche
		
		//if(_zip && !ZipToGAFAssetConverter.keepZipInRAM)
		//{
			//var file:FZipFile;
			//var count:Int=_zip.getFileCount();
			//for(i in 0...count)
			//{
				//file=_zip.getFileAt(i);
				//if(file.filename.toLowerCase().indexOf(".atf")==-1
						//&& file.filename.toLowerCase().indexOf(".png")==-1)
				//{
					//file.content.clear();
				//}
			//}
			//_zip.close();
			//_zip=null;
		//}

		if(_gfxData.isTexturesReady)
		{
			//TODO: isTextureready utile ?
			emit(GAFEvent.COMPLETE,{target: this});
		}
		else
		{
			_gfxData.on(GAFGFXData.EVENT_TYPE_TEXTURES_READY, onTexturesReady);
		}
	}
	
	private function createTimeline(config:GAFTimelineConfig, asset:GAFAsset):GAFTimeline
	{
		for(cScale in config.allTextureAtlases)
		{
			
			if(_defaultScale==null || MathUtility.equals(_defaultScale, cScale.scale))
			{
				for(cCSF in cScale.allContentScaleFactors)
				{
					
					if(_defaultContentScaleFactor==null || MathUtility.equals(_defaultContentScaleFactor, cCSF.csf))
					{
						for(taSource in cCSF.sources)
						{
							if(taSource.source=="no_atlas")
							{
								continue;
							}
							
							if(_taGFXs[taSource.source]!=null)
							{
								var taGFX:TAGFXBase=_taGFXs[taSource.source];
								taGFX.textureScale=cCSF.csf;
								_gfxData.addTAGFX(cScale.scale, cCSF.csf, taSource.id, taGFX);
							}
							else
							{
								//zipProcessError(ErrorConstants.ATLAS_NOT_FOUND + taSource.source + "' in zip", 3);
							}
						}
					}
				}
			}
		}

		var timeline:GAFTimeline=new GAFTimeline(config);
		
		timeline.gafgfxData=_gfxData;
		timeline.gafSoundData=_soundData;
		timeline.gafAsset=asset;
		
		switch(ZipToGAFAssetConverter.actionWithAtlases)
		{
			case ZipToGAFAssetConverter.ACTION_LOAD_ALL_IN_GPU_MEMORY:
				timeline.loadInVideoMemory(GAFTimeline.CONTENT_ALL);
			case ZipToGAFAssetConverter.ACTION_LOAD_IN_GPU_MEMORY_ONLY_DEFAULT:
				timeline.loadInVideoMemory(GAFTimeline.CONTENT_DEFAULT);
		}

		return timeline;
	}
	
	private function getAssetId(configName:String):String
	{
		var startIndex:Int=configName.lastIndexOf("/");

		if(startIndex<0)
		{
			startIndex=0;
		}
		else
		{
			startIndex++;
		}

		var endIndex:Int=configName.lastIndexOf(".");

		if(endIndex<0)
		{
			endIndex=0x7fffffff;
		}

		return configName.substring(startIndex, endIndex);
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

	private function onConvertError(event:Dynamic):Void
	{
		throw "ZipToGAFAssetConverter: " + event.type;
		
		if(hasEventListener(GAFEvent.ERROR))
		{
			emit(event);
		}
		else
		{
			throw event.text;
		}
	}

	private function onConverted(event:Dynamic):Void
	{
		//*use namespace gaf_internal;*/

		var configID:String=_gafAssetsIDs[_currentConfigIndex];
		var folderURL:String=getFolderURL(configID);
		
		var converter:BinGAFAssetConfigConverter=cast(event.target,BinGAFAssetConfigConverter);
		
		converter.off(GAFEvent.COMPLETE, onConverted);
		converter.off(GAFEvent.ERROR, onConvertError);

		_gafAssetConfigs[configID]=converter.config;
		
		var sounds:Array<CSound>=converter.config.sounds;
		if(sounds!=null && !_ignoreSounds)
		{
			for(i in 0...sounds.length)
			{
				sounds[i].source=folderURL + sounds[i].source;
				//_soundData.addSound(sounds[i], converter.config.id, _sounds[Std.parseInt(sounds[i].source)]);
			}
		}

		_currentConfigIndex++;
		
		if(_currentConfigIndex>=_gafAssetsIDs.length)
		{
			
			findAllAtlasURLs();
			
			return;
			
			// TODO ? Version AS3
			//if(_gafAssetsConfigURLs!=null && _gafAssetsConfigURLs.length>0)
			//{
				//findAllAtlasURLs();
			//}
			//else
			//{
				//createGAFTimelines();
			//}
		}
		else
		{
			convertConfig();
			// TODO ? Version AS3
			//_configConvertTimeout=setTimeout(convertConfig, 40);
		}
	}
	
	private function onTexturesReady(event:Dynamic):Void
	{
		_gfxData.off(GAFGFXData.EVENT_TYPE_TEXTURES_READY, onTexturesReady);

		//TODO: onTextureReady utilisé ?
		emit(GAFEvent.COMPLETE,{target:this});
	}
	
	//--------------------------------------------------------------------------
	//
	//  GETTERS AND SETTERS
	//
	//--------------------------------------------------------------------------	
	
	/**
	 * Return converted<code>GAFBundle</code>. If GAF asset file created as single animation - returns null.
	 */
	public var gafBundle(get_gafBundle, null):GAFBundle;
 	private function get_gafBundle():GAFBundle
	{
		return _gafBundle;
	}
	
	
}