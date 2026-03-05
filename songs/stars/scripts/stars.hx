import karaoke.backend.utils.SpriteExtension;
import karaoke.backend.utils.SpriteExtension.DrawPassType;

using SpriteExtension;

var leftLightShadow:FunkinSprite;
var rightLightShadow:FunkinSprite;
var spotlightCircle:FunkinSprite;

var ladyDance:Character;
var cyan:FunkinSprite;

function create() {
	isNightTime = true;

	spotlightCircle = new FunkinSprite().loadGraphic(Paths.image("game/stages/house/ididntwanttomakethisasprite"));
	spotlightCircle.screenCenter();
	spotlightCircle.x += 140;
	spotlightCircle.y += 80;
	spotlightCircle.antialiasing = false;
	spotlightCircle.alpha = 0.5;
	insert(5, spotlightCircle);

	leftLightShadow = new FunkinSprite().makeSolid(300, 500, 0xFF000000);
	leftLightShadow.screenCenter();
	leftLightShadow.x -= 120;
	leftLightShadow.y -= 25;
	leftLightShadow.angle = 12.5;
	add(leftLightShadow);

	rightLightShadow = new FunkinSprite().makeSolid(300, 500, 0xFF000000);
	rightLightShadow.screenCenter();
	rightLightShadow.x += 400;
	rightLightShadow.y -= 25;
	rightLightShadow.angle = -12.5;
	add(rightLightShadow);

	spotlightCircle.alpha = leftLightShadow.alpha = rightLightShadow.alpha = 0;

	cyan = new FunkinSprite(95, 104).loadGraphic(Paths.image("game/stages/house/cyan"));
	insert(6, cyan);
	cyan.kill();

	ladyDance = new Character(boyfriend.x + 75, boyfriend.y - 55, "ladydance", true);
	player.characters.push(ladyDance);
	insert(members.indexOf(boyfriend)+1, ladyDance);
	ladyDance.kill();
}

// switch statement in stephit because life isnt good var hate
function stepHit(step:Int) {
	switch(step) {
		case 448:
			gf.visible = houseLights.visible = false;
			ladySpeaker?.visible = speakerLight = false;

			for (name => spr in stage.stageSprites) {
				spr.visible = false;
			}

			dad.setDrawPasses([
				DrawPassType.COLOR(true, {x: 0, y: 0}, [0,0,0])
			]);

			boyfriend.setDrawPasses([
				DrawPassType.SHADER(false, {x: 0, y: 0}, playerSkin),
				DrawPassType.COLOR(true, {x: 0, y: 0}, [0,0,0])
			]);

			dad.scale.set(2, 2);
			dad.updateHitbox();
			boyfriend.scale.set(2, 2);
			boyfriend.updateHitbox();

			dad.x -= 80;
			dad.y += 80;

			boyfriend.x += 20;
			boyfriend.y += 60;

			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 512:
			gf.visible = houseLights.visible = true;
			ladySpeaker?.visible = speakerLight = true;

			for (name => spr in stage.stageSprites) {
				spr.visible = true;
			}

			dad.scale.set(1, 1);
			dad.updateHitbox();
			boyfriend.scale.set(1, 1);
			boyfriend.updateHitbox();

			dad.x += 120;
			dad.y -= 80;

			boyfriend.x -= 60;
			boyfriend.y -= 60;

			camera.lock(camera.data[2].x, camera.data[2].y);
			camera.snap();

			dad.setDrawPasses([
				DrawPassType.LIGHTING({x: 0, y: -4}, [1,1,1,1], [0,0,0,0.5])
			]);

			boyfriend.setDrawPasses([
				DrawPassType.SHADER(false, {x: 0, y: 0}, playerSkin),
				DrawPassType.LIGHTING({x: 0, y: -4}, [1,1,1,1], [0,0,0,0.5])
			]);

			spotlightCircle.alpha = (leftLightShadow.alpha = rightLightShadow.alpha = 1) * 0.5;

			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 528:
			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 576:
			gf.visible = false;
			dad.x += 40;
			boyfriend.x -= 40;

			ladyDance.revive();
			ladyDance.x -= 85;
			ladyDance.setDrawPasses([
				DrawPassType.SHADER(false, {x: 0, y: 0}, ladySkin),
				DrawPassType.LIGHTING({x: 0, y: -4}, [1,1,1,1], [0,0,0,0.5])
			]);

			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
		case 640:
			dad.setDrawPasses([
				DrawPassType.LIGHTING({x: 4, y: 0}, nightLightingColor, nightShadowColor)
			]);

			playerEyes.colorReplaceEyes = [1, 1, 1];
			boyfriend.setDrawPasses([
				DrawPassType.SHADER(false, {x: 0, y: 0}, playerSkin),
				DrawPassType.LIGHTING({x: -4, y: 0}, nightLightingColor, nightShadowColor),
				DrawPassType.SHADER(true, {x: 0, y: 0}, playerEyes)
			]);

			spotlightCircle.alpha = leftLightShadow.alpha = rightLightShadow.alpha = 0;

			dad.x = 232;
			boyfriend.x = 503;

			gf.visible = true;
			ladyDance.kill();

			cyan.revive();

			camera.unlock();
			flash(camGame, {color: 0xFFFFFFFF, time: 0.1, force: true}, null);
	}
}

function onEvent(e) {
	if (e.event.name != "go off") {
		return;
	}

	if (e.event.params[0] != 2) {
		var positions:Array<Float> = switch e.event.params[0] {
			case 0: [220, -61, 458];
			case 1: [365, 84, 603];
		};
		spotlightCircle.x = positions[0];
		spotlightCircle.y = 261;
		spotlightCircle.setGraphicSize(257, spotlightCircle.height);
		spotlightCircle.updateHitbox();

		leftLightShadow.x = positions[1];
		leftLightShadow.y = -70;

		rightLightShadow.x = positions[2];
		rightLightShadow.y = -70;
	} else {
		spotlightCircle.x = 229;
		spotlightCircle.y = 261;
		spotlightCircle.setGraphicSize(385, spotlightCircle.height);
		spotlightCircle.updateHitbox();

		leftLightShadow.x = -52;
		leftLightShadow.y = -70;

		rightLightShadow.x = 595;
		rightLightShadow.y = -70;
	}
}