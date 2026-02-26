import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.group.FlxSpriteGroup;
import karaoke.util.ColorExtension;

using ColorExtension;

var titleGroup:FlxSpriteGroup;
var textGroup:FlxSpriteGroup;

var titleText:Array<String> = [];

var people:FunkinSprite;
var enterThingy:FunkinSprite;
var logo:FunkinSprite;

var finished:Bool = false;
var transitioning:Bool = false;

var splashText:FunkinText;

var markupRules:Array<FlxTextFormatMarkerPair> = [
	new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF9100, true), "||") // dx format
];

function create() {
	var bing:FunkinSprite = new FunkinSprite().loadSprite(Paths.image('menus/bing'));
	bing.alpha = 0.001;
	bing.scale.set(2, 2);
	bing.updateHitbox();
	bing.shader = new CustomShader('player/icon');
	bing.shader.favColor = 0xFFF1F471.vec4();
	add(bing);

	new FlxTimer().start(0.75, () -> {
		bing.alpha = 1;
		FlxG.sound.play(Paths.sound('menus/recordscratch'), 1, false, null, true, () -> {
			new FlxTimer().start(0.25, () -> {
				bing.alpha = 0.001;
				new FlxTimer().start(0.5, function() {playMenuMusic();});
			});
		});
	});

	titleGroup = new FlxSpriteGroup();
	textGroup = new FlxSpriteGroup();
	add(titleGroup);
	add(textGroup);

	var titleTextArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('titlescreen/titleText'));
	if (titleTextArray.contains('')) {
		titleTextArray.remove('');
	}

	titleText = titleTextArray[FlxG.random.int(0, titleTextArray.length-1)].split('--');

	var bg:FunkinSprite = new FunkinSprite().loadSprite(Paths.image('menus/backgrounds/nightwalk'));
	bg.scale.set(2, 2);
	bg.updateHitbox();
	bg.x = FlxG.width-bg.width;
	titleGroup.add(bg);

	people = new FunkinSprite().loadSprite(Paths.image('menus/titlescreen/people'));
	people.addAnim('idle', 'spr_menugf_', 12, false);
	people.addAnim('yeah', 'spr_menugfyeah', 12, false);
	people.playAnim('idle', true);
	people.scale.set(2, 2);
	people.updateHitbox();
	titleGroup.add(people);

	logo = new FunkinSprite(0, 20).loadSprite(Paths.image('menus/titlescreen/title'));
	logo.scale.set(2, 2);
	logo.updateHitbox();
	logo.screenCenter(FlxAxes.X);
	titleGroup.add(logo);

	enterThingy = new FunkinSprite().loadSprite(Paths.image('menus/titlescreen/titlewords'));
	enterThingy.scale.set(2, 2);
	enterThingy.updateHitbox();
	enterThingy.setPosition(5, FlxG.height-enterThingy.height-5);
	titleGroup.add(enterThingy);

	var splashTextArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('titlescreen/splashtext'));
	splashText = new FunkinText(185, logo.y + logo.height - 10, 200, splashTextArray[FlxG.random.int(0, splashTextArray.length-1)], 16, true);
	splashText.alignment = 'center';
	splashText.antialiasing = false;
	// lunarcleint figured this out thank u lunar holy shit 🙏
	splashText.textField.antiAliasType = 0; // advanced
	splashText.textField.sharpness = 400; // max i think idk thats what it says
	splashText.font = Paths.font("Pixellari.ttf");
	splashText.borderSize = 2;
	splashText.angle = -10;
	splashText.color = FlxG.random.color(0xFF8B8B8B, 0xFFFFFFFF, 1, false);
	splashText.applyMarkup(splashText.text, markupRules);
	titleGroup.add(splashText);

	titleGroup.visible = false;
}

function finishIntro() {
	finished = true;
	removeLines();
	flash(FlxG.camera, {color: 0xFFFFFFFF, time: 0.25, force: true}, null);
	titleGroup.visible = true;

	if (FlxG.sound.music.time < 8720) {
		FlxG.sound.music.time = 8720;
	}
}

var timer:Float = 0.0;
function update(elapsed:Float) {
	timer += elapsed;

	// tank you wizard 🙏
	enterThingy.alpha = FlxMath.bound((Math.sin(timer * 5) + 1) * 0.5, 0.2, 1);
	splashText.y = logo.y + logo.height - 10 + (Math.sin(timer * 4) + 1) * 2;
	splashText.x = 185 + (Math.sin(timer * 8) + 1) * 2;

	if (people.animation != null && people.animation.curAnim != null)
		people.animation.curAnim.frameRate = 12*(Conductor.bpm/150);

	if (FlxG.sound.music != null && controls.ACCEPT && !finished && !transitioning && FlxG.sound.music.playing)
		finishIntro();
	else if (FlxG.sound.music != null && controls.ACCEPT && finished && !transitioning && FlxG.sound.music.playing) {
		FlxG.sound.play(Paths.sound('menus/josh'), 0.8);
		transitioning = true;
		people.playAnim('yeah', true, 'LOCK');
		flash(FlxG.camera, {color: 0xFFFFFFFF, time: 0.25, force: true}, null);
		new FlxTimer().start(1, () -> {
			FlxG.switchState(new ModState('menus/MainMenu'));
		});
	}
}

function beatHit() {
	if (!transitioning) {
		people.playAnim('idle', true);
	}

	splashText.scale.set(1.25, 1.25);
	FlxTween.tween(splashText, {'scale.x': 1, 'scale.y': 1}, 0.5, {ease: FlxEase.backOut});

	FlxTween.cancelTweensOf(logo);
	logo.scale.set(2.15, 2.15);
	FlxTween.tween(logo, {'scale.x': 2, 'scale.y': 2}, 0.25, {ease: FlxEase.circOut});

	if (finished) {
		return;
	}

	switch(curBeat) {
		case 1: line(['ALIZA']);
		case 2: line(['PRESENTS']);

		case 4: line(['IN ASSOCIATION WITH']);
		case 6: newLine(['listen i\'ll get to the credits menu soon okay dude please just trust me']);

		case 8: line([titleText[0]]);
		case 10: newLine([titleText[1]]);

		case 12: line(['FNF']);
		case 14: newLine(['FREE']);
		case 15: newLine(['DOWNLOAD (cne edition)']);

		case 16: finishIntro();
	}
}

function line(lines:Array<String>) {
	removeLines();
	newLine(lines);
}

function newLine(lines:Array<String>) {
	for (line in lines) {
		var lastHeight:Float = CoolUtil.last(textGroup.members) == null ? 0 : CoolUtil.last(textGroup.members).height;
		var text:FunkinText = new FunkinText(0, 125 + (lastHeight*(textGroup.length)), FlxG.width, line, 32, false);
		text.alignment = 'center';
		text.antialiasing = false;
		text.textField.antiAliasType = 0;
		text.textField.sharpness = 400;
		text.font = Paths.font("Pixellari.ttf");
		textGroup.add(text);
	}
}

function removeLines() {
	while (textGroup.members.length > 0) {
		textGroup.members[0].destroy();
		textGroup.remove(textGroup.members[0], true);
	}
}