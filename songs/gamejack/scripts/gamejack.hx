disableScript();

var blackOverlay:FunkinSprite;

function postCreate() {
	blackOverlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
	blackOverlay.zoomFactor = 0;
	blackOverlay.scrollFactor.set();
	add(blackOverlay);
}