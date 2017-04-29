package com.github.haxePixiGAF.data;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.sound.GAFSoundData;

/**
 * GAFBundle is utility class that used to save all converted GAFTimelines from bundle in one place with easy access after conversion complete
 */
/**
 * TODO
 * @author Mathieu Anthoine
 */
@:expose("GAF.GAFBundle")
 class GAFBundle
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

	private var _name:String;
	private var _soundData:GAFSoundData;
	private var _gafAssets:Array<GAFAsset>;
	private var _gafAssetsDictionary:Map<String,GAFAsset>;// GAFAsset by SWF name

	//--------------------------------------------------------------------------
	//
	//  CONSTRUCTOR
	//
	//--------------------------------------------------------------------------
	
	public function new()
	{
		_gafAssets=new Array<GAFAsset>();
		_gafAssetsDictionary=new Map<String,GAFAsset>();
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
		if(_gafAssets!=null)
		{
			//GAFSoundManager.getInstance().stopAll();
			//_soundData.dispose();
			_soundData=null;

			for (gafAsset in _gafAssets)
			{
				gafAsset.dispose();
			}
			_gafAssets=null;
			_gafAssetsDictionary=null;
		}
	}

	/**
	 * Returns<code>GAFTimeline</code>from bundle by<code>swfName</code>and<code>linkage</code>.
	 * @param swfName is the name of SWF file where original timeline was located(or the name of the *.gaf config file where it is located).
	 * @param linkage is the linkage name of the timeline. If you need to get the Main Timeline from SWF use the "rootTimeline" linkage name.
	 * @return<code>GAFTimeline</code>from bundle
	 */
	public function getGAFTimeline(swfName:String, linkage:String="rootTimeline"):GAFTimeline
	{

		var gafTimeline:GAFTimeline=null;
		var gafAsset:GAFAsset = _gafAssetsDictionary[swfName];
		
		if(gafAsset!=null)
		{
			gafTimeline=gafAsset.getGAFTimelineByLinkage(linkage);
		}
		
		return gafTimeline;
	}

	/**
	 * Returns<code>IGAFTexture</code>(custom image)from bundle by<code>swfName</code>and<code>linkage</code>.
	 * Then it can be used to replace animation parts or create new animation parts.
	 * @param swfName is the name of SWF file where original Bitmap/Sprite was located(or the name of the *.gaf config file where it is located)
	 * @param linkage is the linkage name of the Bitmap/Sprite
	 * @param scale Texture atlas Scale that will be used for<code>IGAFTexture</code>creation. Possible values are values from converted animation config.
	 * @param csf Texture atlas content scale factor(CSF)that will be used for<code>IGAFTexture</code>creation. Possible values are values from converted animation config.
	 * @return<code>IGAFTexture</code>(custom image)from bundle.
	 * @see com.catalystapps.gaf.display.GAFImage
	 * @see com.catalystapps.gaf.display.GAFImage#changeTexture()
	 */
	public function getCustomRegion(swfName:String, linkage:String, ?scale:Float, ?csf:Float):IGAFTexture
	{
		
		var gafTexture:IGAFTexture=null;
		var gafAsset:GAFAsset = _gafAssetsDictionary[swfName];
		if(gafAsset!=null)
		{
			gafTexture = gafAsset.getCustomRegion(linkage, scale, csf);
		}

		return gafTexture;
	}

	//--------------------------------------------------------------------------
	//
	//  PRIVATE METHODS
	//
	//--------------------------------------------------------------------------

	private function getGAFTimelineBySWFNameAndID(swfName:String, id:String):GAFTimeline
	{
		var gafTimeline:GAFTimeline=null;
		var gafAsset:GAFAsset=_gafAssetsDictionary[swfName];
		if(gafAsset!=null)
		{
			gafTimeline=gafAsset.getGAFTimelineByID(id);
		}

		return gafTimeline;
	}

	public function addGAFAsset(gafAsset:GAFAsset):Void
	{
		
		if(_gafAssetsDictionary[gafAsset.id]==null)
		{
			_gafAssetsDictionary[gafAsset.id]=gafAsset;
			_gafAssets.push(gafAsset);
		}
		else
		{
			throw "Bundle error. More then one gaf asset use id:'" + gafAsset.id + "'";
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

	public var soundData(get_soundData, set_soundData):GAFSoundData;
	
 	private function get_soundData():GAFSoundData
	{
		return _soundData;
	}

	/**
	 * 
	 * @param soundData
	 */
	private function set_soundData(soundData:GAFSoundData):GAFSoundData
	{
		return _soundData=soundData;
	}

	public var gafAssets(get_gafAssets, null):Array<GAFAsset>;
 	private function get_gafAssets():Array<GAFAsset>
	{
		return _gafAssets;
	}

	/**
	 * The name of the bundle. Used in GAFTimelinesManager to identify specific bundle.
	 * Should be specified by user using corresponding setter or by passing the name as second parameter in GAFTimelinesManager.addGAFBundle().
	 * The name can be auto-setted by ZipToGAFAssetConverter in two cases:
	 * 1)If ZipToGAFAssetConverter.id is not empty ZipToGAFAssetConverter sets the bundle name equal to it's id;
	 * 2)If ZipToGAFAssetConverter.id is empty, but gaf package(zip or folder)contain only one *.gaf config file,
	 * ZipToGAFAssetConverter sets the bundle name equal to the name of the *.gaf config file.
	 */
	public var name(get_name, set_name):String;
 	
	//@:keep
	private function get_name():String
	{
		return _name;
	}

	//@:keep
	private function set_name(name:String):String
	{
		return _name=name;
	}
	
	static function __init__():Void {
        #if js
        untyped Object.defineProperty(GAFBundle.prototype, "name", { get: untyped GAFBundle.prototype.get_name, set: GAFBundle.prototype.set_name });
        #end
    }
}