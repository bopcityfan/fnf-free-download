import karaoke.backend.utils.ColorExtension;
import karaoke.backend.utils.SpriteExtension;
import karaoke.backend.utils.SpriteExtension.DrawPassType;
import karaoke.backend.utils.KaraokeUtil;
import flixel.tweens.misc.ColorTween;

using ColorExtension;
using SpriteExtension;

var ladyDance:FunkinSprite;
var dudeDance:FunkinSprite;

var danceBreak:FunkinSprite;
var tunnel:FunkinSprite;

var blueOverlay:FunkinSprite;

var inTunnel:Bool = false;
var funkyMode(default, set):Bool = false;
function set_funkyMode(value:Bool) {
	blueOverlay?.visible = value;
	return funkyMode = value;
}

function postCreate() {
	ladyDance = new FunkinSprite(boyfriend.x - 50, boyfriend.y - 65);
	dudeDance = new FunkinSprite(boyfriend.x - 20, boyfriend.y - 10);

	for (index => char in [ladyDance, dudeDance]) {
		char.loadSprite(Paths.image('game/stages/bus/girl-next-door/${['lady', 'dude'][index]}-dance'));

		char.animation.addByPrefix('danceDown', 'spr_${['lady', 'dude'][index]}dancedown', 12, false);
		char.animation.addByPrefix('danceUp', 'spr_${['lady', 'dude'][index]}danceup', 12, false);

		char.beatAnims = [{name: 'danceDown', forced: true}, {name: 'danceUp', forced: true}];
		char.beatInterval = 1;

		if (index == 0) {
			char.addOffset('danceUp', -2, -1);
		}

		insert(members.indexOf(boyfriend)-1, char);

		char.shader = [ladySkin, playerSkin][index];
		char.visible = false;
	}

	danceBreak = new FunkinSprite(0, 75);
	danceBreak.loadSprite(Paths.image('game/stages/bus/girl-next-door/dancebreak'));
	danceBreak.screenCenter(0x01);
	danceBreak.scrollFactor.set();
	add(danceBreak);
	danceBreak.visible = false;

	danceBreak.onDraw = (spr:FunkinSprite) -> {
		spr.offset.set(0, 0);
		spr.draw();

		spr.offset.set(0, (-2) + (Math.sin(timer * 4.5) + 1) * 2);
		spr.draw();
	}

	tunnel = new FunkinSprite(650, 66);
	tunnel.loadSprite(Paths.image('game/stages/bus/girl-next-door/bigfuckintunnel'));
	insert(5, tunnel);
	tunnel.visible = false;

	blueOverlay = new FunkinSprite().makeSolid(gameSize.X + 50, gameSize.Y + 50, 0xFFCEFAFF);
	blueOverlay.scrollFactor.set();
	blueOverlay.zoomFactor = 0;
	blueOverlay.screenCenter();
	blueOverlay.blend = 9;
	add(blueOverlay);
	blueOverlay.visible = false;
}

var timer:Float = 0;
function update(e:Float) {
	timer += e;

	if (inTunnel) {
		tunnel.x -= 175 * e; // because changing tunnel.velocity.x does nothing fsr
	}
}

function stepHit(step:Int) {
	switch(step) {
		case 128:
			ladyDance.visible = dudeDance.visible = danceBreak.visible = !(boyfriend.visible = gf.visible = false);
			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 192:
			ladyDance.visible = dudeDance.visible = danceBreak.visible = !(boyfriend.visible = gf.visible = true);
			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 568:
			camGame.fade(0xFFFFFFFF, KaraokeUtil.songTimeToSeconds(0, 2, 0), false, null, true);
		case 576:
			camGame.flash(0xFFFFFFFF, 0.001, null, true);
			camGame.fade(0xFFFFFFFF, KaraokeUtil.songTimeToSeconds(0, 1, 0), true, null, true);

			funkyMode = true;
			defaultCamZoom = 1.02;
		case 688:
			funkyMode = false;
			camGame.angle = 0;

			camera.lock(camera.data[0].x, camera.data[0].y);
			camera.snap();

			camGame.zoom = defaultCamZoom = 2;
		case 704:
			camera.unlock();
			funkyMode = true;

			defaultCamZoom = 1.02;
	}
}

function beatHit(beat:Int) {
	if (!funkyMode) {
		return;
	}

	camGame.angle = camGame.angle == 0 ? 1 : -camGame.angle;
	camGame.zoom += 0.02;
}

function exitTunnel() {
	flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
	tunnel.visible = inTunnel = false;

	for (sprite in stage.stageSprites) {
		sprite.onDraw = null;
		sprite.setColorTransform();
	}

	dad.onDraw = null;
	gf.onDraw = null;
	boyfriend.onDraw = null;

	gf.shader = ladySkin;
	boyfriend.shader = playerSkin;

	for (sL in strumLines.members) {
		for (character in sL.characters) {
			character.setColorTransform();
		}
	}

	speakerLight = false;
	speakerAuto = true;

	ladySpeaker.color = 0xFFFFFFFF;
}

function enterTunnel() {
	tunnel.visible = inTunnel = true;

	for (sprite in stage.stageSprites) {
		FlxTween.color(sprite, 0.25, 0xFFFFFFFF, 0xFF000000);
	}

	FlxTween.color(null, 0.25, 0xFF201E28, 0xFFFFFFFF, {
		onUpdate: (tween:ColorTween) -> {
			playerEyes.colorReplaceEyes = tween.color.vec3();
		},
		onComplete: (tween:ColorTween) -> {
			tween.destroy();
		}
	});

	boyfriend.onDraw = (spr:FlxSprite) -> {
		spr.shader = playerSkin;
		spr.draw();

		spr.shader = playerEyes;
		spr.draw();
	}

	for (sL in strumLines.members) {
		for (character in sL.characters) {
			FlxTween.color(character, 0.25, 0xFFFFFFFF, 0xFF000000);
		}
	}

	speakerLight = true;
	speakerAuto = false;

	ladySpeaker.animation.curAnim.curFrame = speakerLightSpr.animation.curAnim.curFrame = 0;
	FlxTween.color(ladySpeaker, 0.25, 0xFFFFFFFF, 0xFF000000);
}

var lightingColor:FlxColor = 0xFF204C4E;
function setupLighting() {
	for (sprite in stage.stageSprites) {
		sprite.setDrawPasses([
			DrawPassType.LIGHTING({x: 0, y: -2}, 0xFF5C5C5C.vec3(), 0xFF000000.vec4())
		]);
	}

	final shadowColor:Array<Float> = [0, 0, 0, 0.25];

	dad.onDraw = (spr:FlxSprite) -> {
		SpriteExtension.doDrawPass(spr,
			DrawPassType.LIGHTING({x: 4, y: 0}, lightingColor.vec3(), shadowColor)
		);
	}

	gf.onDraw = (spr:FlxSprite) -> {
		SpriteExtension.doDrawPass(spr,
			DrawPassType.SHADER(false, null, ladySkin)
		);

		SpriteExtension.doDrawPass(spr,
			DrawPassType.LIGHTING({x: 0, y: 2}, lightingColor.vec3(), shadowColor)
		);
	}

	boyfriend.onDraw = (spr:FlxSprite) -> {
		SpriteExtension.doDrawPass(spr,
			DrawPassType.SHADER(false, null, playerSkin)
		);

		SpriteExtension.doDrawPass(spr,
			DrawPassType.LIGHTING({x: -4, y: 0}, lightingColor.vec3(), shadowColor)
		);

		SpriteExtension.doDrawPass(spr,
			DrawPassType.SHADER(true, null, playerEyes)
		);
	}
}

var colorTween:ColorTween = null;
function onNoteHit(event) {
	if (!inTunnel || event.note.isSustainNote) {
		return;
	}

	colorTween?.cancel();

	lightingColor = event.note.strumLine.opponentSide ? 0xFF204C4E : 0xFF4E4720;
	ladySpeaker.animation.curAnim.curFrame = speakerLightSpr.animation.curAnim.curFrame = event.note.strumLine.opponentSide ? 0 : 2;

	final options = {
		ease: FlxEase.cubeIn,
		onUpdate: (tween:ColorTween) -> {
			lightingColor = tween.color;
		}
	};

	colorTween = FlxTween.color(null, 1, lightingColor, 0xFF000000, options);
}