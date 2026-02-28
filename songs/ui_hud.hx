// shut up vsc

import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import funkin.savedata.FunkinSave;
import karaoke.game.KaraokeIcon;
import karaoke.backend.KaraokeText;
import karaoke.backend.utils.ColorExtension;

using ColorExtension;

public var flowBar:FlxBar;
public var flow:Float = 0;

public var scoreText:KaraokeText;
public var scoreTxtShadow:KaraokeText;

public var playerIcon:KaraokeIcon;
public var opponentIcon:KaraokeIcon;
public var playerIconShadow:KaraokeIcon;
public var opponentIconShadow:KaraokeIcon;

public var uiSkin:String = "default";

function onCountdown(event) {
	if (event.swagCounter != 4) {
		event.spritePath = "game/countdown" + event.swagCounter;
		event.soundPath = "game/countdown" + (event.swagCounter == 3 ? "Go" : FlxMath.remapToRange(event.swagCounter-1, -1, 3, 3, -1));
		event.scale = 2;
	}
}

function onPostCountdown(event) {
	if (event.sprite != null) {
		var spr = event.sprite;
		if (FunkinSave.save.data.epilepsy) {
			spr.visible = false;
		}
		spr.antialiasing = false;
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
			onComplete: (tween:FlxTween) -> {
				spr.destroy();
				remove(spr, true);
			}
		});
	}
}

function onSongStart() {
	canPause = true;
}

var outlineColor:FlxColor = 0xFF000000;
function outlineDraw(spr:FlxSprite) {
	var w:Int = 2;

	spr.setGraphicSize(spr.width+w, spr.height+w);
	spr.colorTransform.color = outlineColor;
	spr.offset.set(-2, -2);
	spr.draw();

	spr.offset.set();
	spr.draw();

	spr.setGraphicSize(spr.width-w, spr.height-w);
	spr.setColorTransform();
	spr.draw();
}

function new() {
	downscroll = false;
}

function postCreate() {
	canPause = false;
	for (sl in strumLines.members) {
        for (note in sl.notes.members) {
            note.alpha = 1;
		}
	}

	for (i in [iconP1, iconP2, healthBarBG, healthBar, scoreTxt, missesTxt, accuracyTxt])
		remove(i);

	healthBar = new FlxBar(0, 358, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.695, 15, this, 'health', 0, maxHealth);
	healthBar.scrollFactor.set();
	healthBar.createFilledBar(0xFF800080, 0xFFF1F471);
	healthBar.cameras = [camHUD];
	healthBar.screenCenter(FlxAxes.X);
	add(healthBar);
	healthBar.onDraw = outlineDraw;

	flowBar = new FlxBar(0, healthBar.y - 19, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.4, 8);
	flowBar.scrollFactor.set();
	flowBar.createFilledBar(0xFF12484B, 0xFF37949A);
	flowBar.cameras = [camHUD];
	flowBar.screenCenter(FlxAxes.X);
	add(flowBar);
	flowBar.onDraw = outlineDraw;

	scoreText = new KaraokeText(10, healthBar.y + healthBar.height + 2, FlxG.width-20, 'score: 0 | misses: 0 | accuracy: N/A', 16, true);
	scoreText.alignment = 'center';
	scoreText.scrollFactor.set();
	scoreText.borderSize = 2;
	scoreText.cameras = [camHUD];

	scoreText.onDraw = (spr:KaraokeText) -> {
		spr.colorTransform.color = outlineColor;
		spr.offset.set(-2, -2);
		spr.draw();

		spr.setColorTransform();
		spr.offset.set();
		spr.draw();
	};

	// var ref:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image('image'));
	// ref.zoomFactor = 0;
	// ref.scrollFactor.set();
	// ref.scale.set(0.5, 0.5);
	// ref.updateHitbox();
	// ref.cameras = [camHUD];
	// ref.alpha = 0.5;
	// ref.color = 0xFFFF0000;
	// insert(0, ref);

	playerIcon = new KaraokeIcon('${uiSkin}/dude');
	playerIcon.cameras = [camHUD];
	playerIcon.shader = new CustomShader('player/icon');
	playerIcon.shader.favColor = 0xFFF1F471.vec4();
	add(playerIcon);

	opponentIcon = new KaraokeIcon('${uiSkin}/strad');
	opponentIcon.cameras = [camHUD];
	add(opponentIcon);

	playerIcon.y = healthBar.y - (playerIcon.height/2.25);
	opponentIcon.y = healthBar.y - (opponentIcon.height/2.25);

	playerIconShadow = new KaraokeIcon('${uiSkin}/dude');
	playerIconShadow.cameras = [camHUD];
	playerIconShadow.color = 0xFF000000;
	insert(members.indexOf(healthBar), playerIconShadow);

	opponentIconShadow = new KaraokeIcon('${uiSkin}/strad');
	opponentIconShadow.cameras = [camHUD];
	opponentIconShadow.color = 0xFF000000;
	insert(members.indexOf(healthBar), opponentIconShadow);

	switch(uiSkin) {
		case "gaw":
			outlineColor = 0xFFFFFFFF;

			healthBar.createFilledBar(0xFF000000, 0xFF000000);
			flowBar.createFilledBar(0xFF000000, 0xFFFFFFFF);

			scoreText.onDraw = (spr:FunkinText) -> {
				spr.colorTransform.color = outlineColor;
				spr.offset.set(-2, -2);
				spr.draw();

				spr.setColorTransform();
				spr.color = 0xFF000000;
				spr.offset.set();
				spr.draw();
			};
			scoreText.setFormat(scoreText.font, scoreText.size, 0xFF000000, scoreText.alignment, scoreText.borderStyle, 0xFFFFFFFF);
	}

	add(scoreText);
}

var timer:Float = 0;
function postUpdate(elapsed:Float) {
	timer += elapsed;

	scoreText.text = 'score: ${songScore} | misses: ${misses}${FunkinSave.save.data.showAccuracy ? ' | accuracy: ${accuracy < 0 ? "N/A" : '${CoolUtil.quantize(accuracy * 100, 100)}%'}' : ''}';

	flowBar.y = Std.int((healthBar.y - 18) + (Math.sin(timer * 4.5) + 1) * 1.25); // tank you wizard 🙏

	playerIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0)) - 5);
	opponentIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0))) - (opponentIcon.width - 10);
	playerIconShadow.setPosition(playerIcon.x + 2, playerIcon.y + (downscroll ? -2 : 2));
	opponentIconShadow.setPosition(opponentIcon.x + 2, opponentIcon.y + (downscroll ? -2 : 2));

	playerIcon.health = playerIconShadow.health = healthBar.percent / 100;
	opponentIcon.health = opponentIconShadow.health = 1 - (healthBar.percent / 100);
}