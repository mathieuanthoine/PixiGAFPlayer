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
import haxe.ds.ObjectMap;
import js.Browser;
import js.Lib;
import js.html.CanvasElement;
import js.html.MouseEvent;
import pixi.core.display.Container;
import pixi.core.math.Matrix;
import pixi.core.renderers.Detector;
import pixi.core.renderers.webgl.WebGLRenderer;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.interaction.InteractionEvent;
import pixi.loaders.LoaderOptions;

/**
 * @author Mathieu Anthoine
 */

class Main
{

	private var renderer:WebGLRenderer;
	private var stage:Container;
	
	private var gafBundle: GAFBundle;
	private var gafMovieClip: GAFMovieClip;
	private var currentAsset: String;

	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(400, 400, {backgroundColor : 0x8F8B83});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onConverted);		
		converter.convert(["bundle/skeleton.gaf","bundle/ufo-monster.gaf"]);
		
	}
	
	private function onConverted (pEvent:Dynamic):Void {

		gafBundle = cast(pEvent.target,ZipToGAFAssetConverter).gafBundle;
		initGAFMovieClip("skeleton");
		
		Browser.window.addEventListener("click", onClick);		
		Browser.window.requestAnimationFrame(gameLoop);
		
	}
	
	private function onClick(pEvent: MouseEvent): Void
	{
		if (!Std.is(pEvent.target,CanvasElement)) return;
		
		if (currentAsset == "skeleton")
		{
			initGAFMovieClip("ufo-monster");
		}
		else
		{
			initGAFMovieClip("skeleton");
		}
	}
	
	private function initGAFMovieClip(swfName: String): Void
	{
		currentAsset = swfName;

		gafMovieClip!=null ? gafMovieClip.destroy() : null;

		stage.removeChildren();

		var timeline: GAFTimeline = gafBundle.getGAFTimeline(swfName, "rootTimeline");

		gafMovieClip = new GAFMovieClip(timeline);
		gafMovieClip.play();
		
		stage.addChild(gafMovieClip);
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}