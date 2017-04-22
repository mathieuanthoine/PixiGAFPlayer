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
 * Simple Example of GAF Animation in PixiJs v4
 * @author Mathieu Anthoine
 */

class Main
{

	private var renderer:WebGLRenderer;
	private var stage:Container;
	
	private static inline var FILE_NAME:String = "first_test";

	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(800, 600, {backgroundColor : 0x999999});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.on(GAFEvent.COMPLETE, onConverted);		
		converter.convert(FILE_NAME+"/" + FILE_NAME+".gaf");
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		var gafBundle: GAFBundle = cast(pEvent.target,ZipToGAFAssetConverter).gafBundle;
		var gafTimeline: GAFTimeline = gafBundle.getGAFTimeline(FILE_NAME, "rootTimeline");

		var gafMovieClip:GAFMovieClip = new GAFMovieClip(gafTimeline);
		gafMovieClip.play(true);
		stage.addChild(gafMovieClip);

		Browser.window.requestAnimationFrame(gameLoop);
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}