package com.github.mathieuanthoine.gaf;

import com.github.haxePixiGAF.core.GAFLoader;
import com.github.haxePixiGAF.core.ZipToGAFAssetConverter;
import com.github.haxePixiGAF.data.GAFBundle;
import com.github.haxePixiGAF.data.GAFGFXData;
import com.github.haxePixiGAF.data.GAFTimeline;
import com.github.haxePixiGAF.display.GAFImage;
import com.github.haxePixiGAF.display.GAFMovieClip;
import com.github.haxePixiGAF.display.GAFTexture;
import com.github.haxePixiGAF.display.IGAFTexture;
import com.github.haxePixiGAF.events.GAFEvent;
import haxe.Timer;
import js.Browser;
import js.Lib;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.loaders.LoaderOptions;

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
		renderer = Detector.autoDetectRenderer(960, 640, {backgroundColor : 0xCCCCCC});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();

		urlsList.push(FILE_NAME+"/"+FILE_NAME+".gaf");
		

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
	
	private function onConverted (pEvent:Dynamic):Void {
		trace ("YEAH");
		
		var gafBundle: GAFBundle = cast(pEvent.target,ZipToGAFAssetConverter).gafBundle;
		//"gun_swap" - the name of the SWF which was converted to GAF
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline(FILE_NAME, "rootTimeline");
		
		//var lTexture:IGAFTexture = new GAFTexture("a", gafTimeline.gafgfxData.getTexture(1, 1, "1"), new Matrix());
//
		//var lImage:GAFImage = new GAFImage(lTexture);
		//stage.addChild(lImage);
		//
		//var lTexture:IGAFTexture = gafTimeline.getTextureByName("GUN");
		//trace (lTexture);
		//
		//var lImage:GAFImage = new GAFImage(lTexture);
		//stage.addChild(lImage);
		//
		//return;
		
		//Lib.debug();
		gafMovieClip = new GAFMovieClip(gafTimeline);
		stage.addChild(gafMovieClip);

		gafMovieClip.play(true);
		//gafMovieClip.gotoAndStop(2);
		//renderer.render(stage);
		
		//var lGAFTexture:IGAFTexture = new GAFTexture("test", Texture.fromImage("gun_swap/gun_swap.png"), new Matrix());
		//var lImage:GAFImage = new GAFImage(lGAFTexture);		
		//stage.addChild(lImage);
		
		Browser.window.requestAnimationFrame(gameLoop);
	}
	
	/**
	 * game loop
	 */
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		gafMovieClip.advanceTime(0.02/*0.002*/);
		//gafMovieClip.gotoAndStop((gafMovieClip.currentFrame+1)%gafMovieClip.totalFrames);
		render();
	}
	
	public function render ():Void {
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