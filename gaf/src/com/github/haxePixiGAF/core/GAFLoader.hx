package com.github.haxePixiGAF.core;

import com.github.haxePixiGAF.utils.GAFBytesInput;
import haxe.io.Bytes;
import pixi.loaders.Loader;
import pixi.loaders.Resource;
import pixi.loaders.ResourceLoader;

/**
 * Loader of GAF resources
 * @author Mathieu Anthoine
 */
class GAFLoader extends Loader
{

	//TODO: encapsuler tout le chargement y compris les données binaires (LoaderOptions)
	
	public var name:String;
	public var content:GAFBytesInput;
	
	public function new() 
	{
		super();
		
	}
	
	override public function load (?cb:Void->Void):ResourceLoader {
		after(parseData);
		return super.load();
	}
	
	private function parseData (pResource:Resource, pNext:Void->Void): Void {		
		name = pResource.url;		
		var lBytes:Bytes = Bytes.ofData(pResource.data);
		content = new GAFBytesInput(lBytes, 0, lBytes.length);
		pNext();
	}
	
}