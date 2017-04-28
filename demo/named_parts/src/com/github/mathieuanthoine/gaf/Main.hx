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
import pixi.core.text.Text;
import pixi.core.text.TextStyle;
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
	
	private var robotPlain: GAFMovieClip;
	private var robotNesting: GAFMovieClip;

	private static function main ():Void
	{
		new Main();
	}

	/**
	 * création du jeu
	*/
	private function new ()
	{
		renderer = Detector.autoDetectRenderer(1024, 600, {backgroundColor : 0x999999});
		Browser.document.body.appendChild(renderer.view);

		stage = new Container();
		
		new Perf("TL");
		
		convertPlain();
		
	}
	
	private function convertPlain(): Void
	{
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onPlainConverted);		
		converter.convert("robot_plain/robot.gaf");
	}
	
	private function onPlainConverted(pEvent: Dynamic): Void
	{
		var gafTimeline: GAFTimeline = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle.getGAFTimeline("robot");

		robotPlain = new GAFMovieClip(gafTimeline);
		robotPlain.play();

		stage.addChild(robotPlain);

		convertNesting();
	}
	
	private function convertNesting(): Void
	{
		var converter: ZipToGAFAssetConverter = new ZipToGAFAssetConverter();
		converter.once(GAFEvent.COMPLETE, onNestingConverted);		
		converter.convert("robot_nesting/robot.gaf");
	}
	
	private function onNestingConverted(pEvent: Dynamic): Void
	{
		var gafTimeline: GAFTimeline = cast(pEvent.target, ZipToGAFAssetConverter).gafBundle.getGAFTimeline("robot");

		robotNesting = new GAFMovieClip(gafTimeline);
		robotNesting.x = robotNesting.width;
		robotNesting.play(true);

		stage.addChild(robotNesting);

		initTextFields();

		robotPlain.interactive = true;
		robotNesting.interactive = true;
		
		robotPlain.on("click", onClick);
		robotNesting.on("click", onClick);
		
		Browser.window.requestAnimationFrame(gameLoop);
	}

	private function onClick(pEvent: InteractionEvent): Void
	{
		// TODO: add description
		robotPlain.getChildByName("body_gun").visible = !robotPlain.getChildByName("body_gun").visible;

		// TODO: add description
		cast(robotNesting.getChildByName("body"),Container).getChildByName("gun").visible = !cast(robotNesting.getChildByName("body"),Container).getChildByName("gun").visible;
	}
	
	private function initTextFields(): Void
	{
		var textFormat:TextStyle = new TextStyle({fontFamily:"Arial", fontSize:24,align:"center"});

		var title: Text = new Text("Click the robots to show/hide guns", textFormat);
		title.anchor.set(0.5, 0.5);
		title.y = 50;
		title.x = renderer.width/2;
		
		var plain: Text = new Text("Plain", textFormat);
		plain.x = robotPlain.width / 2;
		plain.anchor.set(0.5, 0.5);
		
		var nesting: Text = new Text("Nesting", textFormat);
		nesting.anchor.set(0.5, 0.5);

		nesting.x = robotNesting.x+robotNesting.width/2;
		nesting.y = renderer.height - 100;
		plain.y = renderer.height - 100;

		stage.addChild(title);
		stage.addChild(plain);
		stage.addChild(nesting);
	}
	
	private function gameLoop(pIdentifier:Float)
	{
		Browser.window.requestAnimationFrame(gameLoop);
		renderer.render(stage);
	}

}