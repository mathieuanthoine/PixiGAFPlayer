package com.github.haxePixiGAF.core;

import com.github.haxePixiGAF.utils.GAFBytesInput;
import haxe.io.Bytes;
import pixi.loaders.Loader;
import pixi.loaders.LoaderOptions;
import pixi.loaders.Resource;
import pixi.loaders.ResourceLoader;

/**
 * Loader of GAF resources
 * @author Mathieu Anthoine
 */
@:expose("GAF.GAFLoader")
class GAFLoader extends Loader
{

	public var names:Array<String>=[];
	public var contents:Array<GAFBytesInput>=[];


	public function new()
	{
		super();
	}

	public function addGAFFile (pUrl:String):Void
	{
		if (pUrl.substring(pUrl.length-4) != ".gaf") throw "GAFLoader supports only .gaf files";
		add(pUrl,{loadType: 1/*LOAD_TYPE.XHR*/,xhrType:'arraybuffer'/*XHR_RESPONSE_TYPE.BUFFER*/});
	}

	override public function load (?cb:Dynamic):ResourceLoader
	{
		use(parseData);
		return super.load();
	}

	private function parseData (pResource:Resource, pNext:Void->Void): Void
	{
		names.push(pResource.url);
		var lBytes:Bytes = Bytes.ofData(pResource.data);
		contents.push(new GAFBytesInput(lBytes, 0, lBytes.length));
		pNext();
	}

}