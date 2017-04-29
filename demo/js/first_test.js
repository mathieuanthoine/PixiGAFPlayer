var app = new PIXI.Application(800, 600, {backgroundColor : 0x999999});
document.body.appendChild(app.view);

const FILE_NAME = "first_test";

var converter = new GAF.ZipToGAFAssetConverter();
converter.once(GAF.GAFEvent.COMPLETE, onConverted);
converter.convert(FILE_NAME+"/" + FILE_NAME+".gaf");

function onConverted (pEvent) {
	
	var gafBundle= pEvent.target.gafBundle;
	
	var gafTimeline = gafBundle.getGAFTimeline(FILE_NAME, "rootTimeline");

	var gafMovieClip = new GAF.GAFMovieClip(gafTimeline);
	gafMovieClip.play();
	app.stage.addChild(gafMovieClip);
}
