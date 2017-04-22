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
	private var gunSlot: GAFImage;
	private var gun1: IGAFTexture;
	private var gun2: IGAFTexture;
	private var currentGun: IGAFTexture;
	
	private static inline var FILE_NAME:String = "first_test";

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

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(800, 600, {backgroundColor : 0x999999});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		//var lLoader:GAFLoader = new GAFLoader();
		//lLoader.addGAFFile(FILE_NAME+"/" + FILE_NAME+".gaf");
		//lLoader.addGAFFile("Bundle/"+FILE_NAME+".gaf");
		//lLoader.addGAFFile("Bundle/Test.gaf");
		//lLoader.once("complete", onLoad);
		//lLoader.load();
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.on(GAFEvent.COMPLETE, onConverted);		
		converter.convert(FILE_NAME+"/" + FILE_NAME+".gaf");
		
	}

	private function onLoad (pLoader:GAFLoader):Void
	{
		//var assetsList:Array<GAFLoader> = [];
		//assetsList.push(pLoader);
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.on(GAFEvent.COMPLETE, onConverted);		
		converter.convert(pLoader);
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var gafBundle: GAFBundle = cast(pEvent.target,ZipToGAFAssetConverter).gafBundle;
		//"gun_swap" - the name of the SWF which was converted to GAF
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline(FILE_NAME, "rootTimeline");

		gafMovieClip = new GAFMovieClip(gafTimeline);
		gafMovieClip.play(true);
		stage.addChild(gafMovieClip);

		//var lTestTimeline:GAFTimeline = gafBundle.getGAFTimeline("Test", "rootTimeline");
		//
		//var lTest:GAFMovieClip = new GAFMovieClip(lTestTimeline);
		//lTest.play(true);
		//stage.addChild(lTest);
		
		//gunSlot = cast(gafMovieClip.getChildByName("GUN"),GAFImage);
		
		//gun1 = gafBundle.getCustomRegion(FILE_NAME, "gun1");
		//gun2 = gafBundle.getCustomRegion(FILE_NAME, "gun2");
		
		//var lBob:GAFMovieClip = new GAFMovieClip(gafBundle.getGAFTimeline(FILE_NAME, "gun1"));
		//lBob.position.set(100, 100);
		//stage.addChild(lBob);
	//
		//var lBill:GAFMovieClip = new GAFMovieClip(gafBundle.getGAFTimeline(FILE_NAME, "gun2"));
		//lBill.position.set(100, 300);
		//stage.addChild(lBill);
		
		//trace (gun1);
		
		//"gun2" texture is made from Bitmap
		//thus we need to adjust its' pivot matrix
		//gun2.pivotMatrix.translate( -24.2, -41.55);
		
		//setGun(gun1);
		
		
		Browser.window.requestAnimationFrame(gameLoop);
	}
	
	private function setGun(gun: IGAFTexture): Void
	{
			currentGun = gun;
			gunSlot.changeTexture(gun);
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