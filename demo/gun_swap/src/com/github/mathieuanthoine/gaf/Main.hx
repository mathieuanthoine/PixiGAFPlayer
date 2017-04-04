package com.github.mathieuanthoine.gaf;

import com.github.haxePixiGAF.core.GAFLoader;
import com.github.haxePixiGAF.core.ZipToGAFAssetConverter;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFMovieClip;
import com.github.haxePixiGAF.events.GAFEvent;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import js.Browser;
import pixi.core.display.Container;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.interaction.EventTarget;
import pixi.loaders.LoaderOptions;
import pixi.loaders.Resource;

/**
 * ...
 * @author Mathieu Anthoine
 */

class Main
{

	/**
	 * instance unique de la classe Main
	 */
	private static var instance: Main;

	private var renderer:WebGLRenderer;
	private var stage:Container;
	
	private var gafMovieClip: GAFMovieClip;
	
	private static inline var FILE_NAME:String = "gun_swap";

	/**
	 * initialisation générale
	 */
	private static function main ():Void
	{
		Main.getInstance();
	}

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Main
	{
		if (instance == null) instance = new Main();
		return instance;
	}

	private var urlsList:Array<String> = [];
	private var assetsList:AssetsList = [];
	private var assetsID:Int = 0;

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(960, 640, {backgroundColor : 0x000000});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();

		//
		//var lBob:BytesOutput = new BytesOutput();
		//lBob.bigEndian = false;
		//lBob.writeFloat(1000002);
		////lBob.position = 0;
		//var lBill:BytesInput = new BytesInput(lBob.getBytes());
		//trace (lBill.readInt32());
		//
		//// 1232348192
		//// 1232348192
		//
		//return;

		urlsList.push("gun_swap/gun_swap.gaf");
		//urlsList.push("gun_swap/gun_swap.png");
		//urlsList.push("gun_swap/gun_swap_2.png");
		//urlsList.push("gun_swap/gun_swap_3.png");

		load();

		//Browser.window.requestAnimationFrame(gameLoop);
	}

	private function load():Void
	{
		//trace (assetsID, urlsList.length);

		if (assetsID>= urlsList.length)
		{
			trace ("END OF LOADING");
			var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
			converter.on(GAFEvent.COMPLETE, onConverted);
			converter.convert(assetsList);
		}
		else {
			//trace (assetsID);
			var lLoader:GAFLoader = new GAFLoader();
			var lOptions:LoaderOptions = {loadType: 1/*LOAD_TYPE.XHR*/,xhrType:'arraybuffer'/*XHR_RESPONSE_TYPE.BUFFER*/};
			lLoader.add(urlsList[assetsID],lOptions);
			lLoader.once("complete", onLoad);
			lLoader.load();
		}
	}

	private function onLoad (pLoader:GAFLoader):Void
	{
		trace ("onLoad");
		//trace (pLoader.name);
		//trace (pLoader.content);
		assetsList.push(pLoader);
		assetsID++;
		load();
	}
	
	private function onConverted (pEvent:EventTarget):Void {
		trace ("YEAH");
		
		var gafBundle: GAFBundle = cast(pEvent.target,ZipToGAFAssetConverter).gafBundle;
		//"gun_swap" - the name of the SWF which was converted to GAF
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline(FILE_NAME, "rootTimeline");

		gafMovieClip = new GAFMovieClip(gafTimeline);
		//gafMovieClip.play(true);
		//addChild(gafMovieClip);

		
		
	}

	/**
	 * game loop
	 */
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy (): Void
	{
		instance = null;
	}

}