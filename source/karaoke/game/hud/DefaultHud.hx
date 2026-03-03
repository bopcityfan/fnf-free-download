import karaoke.game.hud.HudBase;

import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import funkin.game.PlayState;

import karaoke.game.KaraokeIcon;
import karaoke.backend.KaraokeText;
import karaoke.backend.utils.ColorExtension;

using ColorExtension;

class DefaultHud extends HudBase {
	public var healthBar:FlxBar;

	public var flowBar:FlxBar;
	public var flowBarY:Float;

	public var scoreText:KaraokeText;
	public var scoreTxtShadow:KaraokeText;

	public var playerIcon:KaraokeIcon;
	public var opponentIcon:KaraokeIcon;
	public var playerIconShadow:KaraokeIcon;
	public var opponentIconShadow:KaraokeIcon;

	public static function new() {
		super();
	}

	override function create() {
		final outlineColor:FlxColor = 0xFF000000;
		final outlineDraw:(spr:FlxSprite)->Void = (spr:FlxSprite) -> {
			var size:Int = 2;

			spr.setGraphicSize(spr.width + size, spr.height + size);
			spr.colorTransform.color = outlineColor;
			spr.offset.set(-size, -size);
			spr.draw();

			spr.offset.set();
			spr.draw();

			spr.setGraphicSize(spr.width - size, spr.height - size);
			spr.setColorTransform();
			spr.draw();
		}

		healthBar = new FlxBar(0, 358, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.695, 15, PlayState.instance, 'health', 0, PlayState.instance.maxHealth);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFF800080, 0xFFF1F471);
		healthBar.screenCenter(FlxAxes.X);
		add(healthBar);
		healthBar.onDraw = outlineDraw;

		flowBarY = downscroll ? healthBar.y + 24 : healthBar.y - 18;

		flowBar = new FlxBar(0, healthBar.y - 18, FlxBarFillDirection.RIGHT_TO_LEFT, FlxG.width*0.4, 8);
		flowBar.scrollFactor.set();
		flowBar.createFilledBar(0xFF12484B, 0xFF37949A);
		flowBar.screenCenter(FlxAxes.X);
		add(flowBar);
		flowBar.onDraw = outlineDraw;

		final scoreTextY:Float = downscroll ? healthBar.y - healthBar.height - 8 : healthBar.y + healthBar.height + 2;

		scoreText = new KaraokeText(10, scoreTextY, FlxG.width-20, 'score: 0 | misses: 0 | accuracy: N/A', 16, true);
		scoreText.alignment = 'center';
		scoreText.scrollFactor.set();
		scoreText.borderSize = 2;

		scoreText.onDraw = (spr:KaraokeText) -> {
			spr.colorTransform.color = outlineColor;
			spr.offset.set(-2, -2);
			spr.draw();

			spr.setColorTransform();
			spr.offset.set();
			spr.draw();
		};

		playerIcon = new KaraokeIcon('${hudSkin}/dude');
		playerIcon.shader = new CustomShader('player/icon');
		playerIcon.shader.favColor = 0xFFF1F471.vec4();
		add(playerIcon);

		opponentIcon = new KaraokeIcon('${hudSkin}/strad');
		add(opponentIcon);

		playerIcon.y = downscroll ? healthBar.y - (playerIcon.height*0.35) : healthBar.y - (playerIcon.height/2.25);
		opponentIcon.y = downscroll ? healthBar.y - (opponentIcon.height*0.35) : healthBar.y - (opponentIcon.height/2.25);

		// playerIcon.y = healthBar.y - (playerIcon.height/2.25);
		// opponentIcon.y = healthBar.y - (opponentIcon.height/2.25);

		playerIconShadow = new KaraokeIcon('${hudSkin}/dude');
		playerIconShadow.color = 0xFF000000;
		insert(members.indexOf(healthBar), playerIconShadow);

		opponentIconShadow = new KaraokeIcon('${hudSkin}/strad');
		opponentIconShadow.color = 0xFF000000;
		insert(members.indexOf(healthBar), opponentIconShadow);

		add(scoreText);
		updateScoreText();
	}

	public function updateScoreText() {
		var info:Array<String> = [
			'score: ${songScore}',
			'misses: ${misses}'
		];

		if (FunkinSave.save.data.showAccuracy) {
			info.push(
				'accuracy: ${accuracy < 0 ? "N/A" : '${CoolUtil.quantize(accuracy * 100, 100)}%'}'
			);
		}

		scoreText.text = info.join(' | ');
	}

	public function updateIcons() {
		var center:Float = healthBar.x + healthBar.width * FlxMath.remapToRange(healthBar.percent, 0, 100, 1, 0);

		playerIcon.x = center - 5;
		opponentIcon.x = center - (opponentIcon.width - 10);

		playerIconShadow?.setPosition(playerIcon.x + 2, playerIcon.y + (downscroll ? -2 : 2));
		opponentIconShadow?.setPosition(opponentIcon.x + 2, opponentIcon.y + (downscroll ? -2 : 2));

		playerIcon.health = healthBar.percent * 0.01;
		opponentIcon.health = (healthBar.percent * 0.01);

		playerIconShadow?.health = playerIcon.health;
		opponentIconShadow?.health = opponentIcon.health;
	}

	override function onCountdown(event) {
		if (event.swagCounter >= 4) {
			return;
		}

		event.spritePath = "game/countdown" + event.swagCounter;
		event.soundPath = "game/countdown" + (event.swagCounter == 3 ? "Go" : FlxMath.remapToRange(event.swagCounter-1, -1, 3, 3, -1));
		event.scale = 2;
	}

	override function onPostCountdown(event) {
		if (event.sprite == null) {
			return;
		}

		var spr = event.sprite;
		if (FunkinSave.save.data.epilepsy) {
			FlxG.state.remove(spr, true);
			return;
		}

		spr.antialiasing = false;
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
			onComplete: (tween:FlxTween) -> {
				spr.destroy();
				FlxG.state.remove(spr, true);
			}
		});
	}

	override function onNoteHit(event) {
		if (!event.player) {
			return;
		}

		updateScoreText();
	}

	override function onPlayerMiss(event) {
		if (event.note.strumLine.cpu) {
			return;
		}

		updateScoreText();
	}

	override function onFlowUpdate(flow:Float) {
		flowBar.percent = flow * 100;
	}

	var timer:Float = 0;
	override function postUpdate(elapsed:Float) {
		timer += elapsed;

		updateIcons();

		flowBar.y = Std.int(flowBarY + (Math.sin(timer * 4.5) + 1) * 1.25); // tank you wizard 🙏
	}
}