import flixel.addons.display.FlxBackdrop;

var colorOverlay:FunkinSprite;
var scanlines:FlxBackdrop;

var busbackOutline:FunkinSprite;

var cdpun:Character;
var tv:Character;
var msladyandwatch:Character;
var dw:Character;

var cdboyHack:FunkinSprite;
var cdboyExplode:FunkinSprite;

var explodeSound:FlxSound;

function postCreate() {
	colorOverlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFFFFFFFF);
	colorOverlay.color = 0xFF000000;
	colorOverlay.zoomFactor = 0;
	colorOverlay.scrollFactor.set();
	add(colorOverlay);

	scanlines = new FlxBackdrop(null, FlxAxes.XY, 0, 25).makeGraphic(FlxG.width, 4, 0xFF0C330E);
	scanlines.velocity.y = 15;
	scanlines.visible = false;
	add(scanlines);

	busbackOutline = new FunkinSprite(stage.stageSprites["busback"].x, stage.stageSprites["busback"].y).loadSprite(Paths.image('game/events/gamejack/busbackOutline'));
	add(busbackOutline);

	cdpun = new Character(dad.x + 30, dad.y + 210, "cdpun");
	cdpun.color = 0xFF1A7219;
	cpu.characters.push(cdpun);
	cdpun.visible = false;
	add(cdpun);

	tv = new Character(415, 130, "TV");
	tv.color = 0xFF1A7219;
	tv.visible = false;
	add(tv);

	msladyandwatch = new Character(566, cdpun.y + 2, "msladyandwatch");
	msladyandwatch.color = 0xFF1A7219;
	player.characters.push(msladyandwatch);
	msladyandwatch.visible = false;
	add(msladyandwatch);

	dw = new Character(517, 97, "dw", true);
	dw.color = 0xFF1A7219;
	player.characters.push(dw);
	dw.visible = false;
	add(dw);

	cdboyHack = new FunkinSprite(dad.x + dad.globalOffset.x - 27, dad.y + dad.globalOffset.y - 6).loadSprite(Paths.image("game/events/gamejack/cdboyHack"));
	cdboyHack.addAnim("hack", "spr_cdboyhack_", 12, false);
	cdboyHack.visible = false;
	add(cdboyHack);

	cdboyExplode = new FunkinSprite(dad.x + dad.globalOffset.x - 32, dad.y + dad.globalOffset.y - 57).loadSprite(Paths.image("game/events/gamejack/cdboyExplode"));
	cdboyExplode.addAnim("explode", "spr_cdboyexplode_", 12, false);
	cdboyExplode.visible = false;
	add(cdboyExplode);

	explodeSound = FlxG.sound.load(Paths.sound('game/weeknd2/explode'));

	gf.alpha = 0.001;

	camera.data[1].x -= 10;
	camera.data[1].y -= 14;
}

var funkyMode:Int = 0;
function beatHit(beat:Int) {
	switch(beat) {
		case 32:
			funkyMode = 1;
		case 192:
			funkyMode = 2;
	}

	if (funkyMode == 0) {
		return;
	}

	switch(funkyMode) {
		case 1:
			if (beat % 2 != 0) {
				return;
			}

			camGame.zoom += 0.015;
		case 2:
			camGame.zoom += 0.035;
	}
}

//region hscript call events
function showGAW() {
	colorOverlay.color = 0xFF071B05;
	scanlines.visible = true;

	cdpun.visible = true;
}

function showTV() {
	tv.visible = true;
}

function showPlayers() {
	msladyandwatch.visible = true;
	dw.visible = true;
}

function hideGAW() {
	remove(colorOverlay);
	remove(scanlines);

	remove(busbackOutline);

	cpu.characters.remove(cdpun);
	remove(cdpun);

	remove(tv);

	player.characters.remove(msladyandwatch);
	remove(msladyandwatch);
	player.characters.remove(dw);
	remove(dw);
}

function hacked() {
	dad.visible = false;
	cdboyHack.visible = true;

	cdboyHack.playAnim("hack", true);
}

function hackEnd() {
	dad.visible = true;
	cdboyHack.visible = false;

	remove(cdboyHack);
}

function createPain(frameIndex:String) {
	var index:Int = Std.parseInt(frameIndex);

	var pain:FunkinSprite = new FunkinSprite().loadSprite(Paths.image('game/events/gamejack/cdboyOw'));
	pain.addAnim("anim", "spr_cdboyow_", 0, false, false, [index]);
	add(pain);
	pain.playAnim("anim", true);

	pain.setPosition(
		(dad.getGraphicMidpoint().x - (pain.width*0.5)) + dad.globalOffset.x + FlxG.random.float(-75, 75),
		(dad.getGraphicMidpoint().y - (pain.height*0.5)) + dad.globalOffset.y + FlxG.random.float(-75, 75)
	);

	FlxTween.shake(pain, 0.0225, 1);
	FlxTween.tween(pain, {alpha: 0}, 1, {onComplete: () -> {
		remove(pain);
	}});
}

function explode() {
	dad.visible = false;
	cdboyExplode.visible = true;

	cdboyExplode.playAnim("explode", true);
	explodeSound.play();
}
//endregion