import Xml;
import funkin.backend.utils.XMLUtil;
import funkin.backend.scripting.Script;
import funkin.backend.scripting.DummyScript;
import karaoke.backend.KaraokeText;
import karaoke.backend.utils.ColorExtension;
import karaoke.backend.utils.XMLHelper;
import flixel.group.FlxSpriteGroup;

using ColorExtension;
using StringTools;

public var weekndData:Array<{xml:Xml, name:String, color:FlxColor, rating:String, songs:Array<{name:String, display:Null<String>}>}> = [];

public var songsTxt:KaraokeText;
public var ratingTxt:KaraokeText;
public var playTxt:KaraokeText;

public var curSelected(default, set):Int = 0;
function set_curSelected(val:Int):Int {
	var newVal:Int = FlxMath.wrap(val, 0, weekndData.length-1);
	updateSelection(newVal);
	return curSelected = newVal;
}

function create() {
	playMenuMusic();

	var bg:FunkinSprite = new FunkinSprite(-250).loadSprite(Paths.image('menus/backgrounds/mint'));
	bg.scrollFactor.set();
	bg.scale.set(2,2);
	bg.updateHitbox();
	bg.y = -690;
	add(bg);

	for (i in 0...2) {
		var bar:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, 0xFF000000);
		bar.y = i == 0 ? 250 : -344;
		bar.scrollFactor.set();
		add(bar);

		var shadow:FunkinSprite = new FunkinSprite().makeSolid(FlxG.width, 5, 0xFF000000);
		shadow.y = i == 0 ? bar.y - shadow.height : bar.y + bar.height;
		shadow.scrollFactor.set();
		shadow.alpha = 0.45;
		add(shadow);
	}

	var weekndFiles = Paths.getFolderContent('data/weeknds');
	for (fileName in weekndFiles) {
		if (!fileName.endsWith('.xml')) {
			weekndFiles.remove(fileName);
			continue;
		}
	}

	for (weeknd in weekndFiles) {
		weeknd = weeknd.split('.')[0];
		var xml:Xml = Xml.parse(Assets.getText(Paths.xml('weeknds/${weeknd}'))).firstElement();

		final index:Int = Std.parseInt(xml.get('index')) ?? 0;

		var data = {
			xml: xml,
			name: xml.get('name'),
			color: FlxColor.fromString(xml.get('color')) ?? 0xFFFFFFFF,
			rating: xml.get('rating'),
			songs: [
				for (song in xml.elementsNamed('song')) {
					{
						name: song.get('name'),
						display: song.exists('display') ? song.get('display') : null
					}
				}
			]
		};
		weekndData.insert(index, data);

		var spriteGroup:FlxSpriteGroup = new FlxSpriteGroup();
		spriteGroup.x = FlxG.width*index;
		spriteGroup.y = 66;
		add(spriteGroup);

		var weekndScript:Script = Script.create(Paths.script('data/weeknds/${weeknd}'));
		weekndScript.setParent(spriteGroup);
		weekndScript.set('weekndData', data);
		weekndScript.load();

		weekndScript.call('create');

		var composition:Map<String, FunkinSprite> = [];
		weekndScript.set('composition', composition);

		for (node in xml.elementsNamed('composition')) {
			var spriteFunc:(sprNode:Xml)->Void = (sprNode:Xml) -> {
				if (!sprNode.exists('sprite') || !sprNode.exists('name')) continue;

				var spr:FunkinSprite = XMLUtil.createSpriteFromXML(sprNode, node.get('folder') ?? 'menus/storyMode/');
				composition[spr.name] = spr;
				spriteGroup.add(spr);
			};

			for (sprNode in node.elementsNamed("sprite")) spriteFunc(sprNode);
			for (sprNode in node.elementsNamed("spr")) spriteFunc(sprNode);
			for (sprNode in node.elementsNamed("sparrow")) spriteFunc(sprNode);
		}

		var weekndTitle:KaraokeText = new KaraokeText(0, 12 - spriteGroup.y, FlxG.width, data.name, 32);
		weekndTitle.alignment = 'center';
		weekndTitle.antialiasing = false;
		weekndTitle.color = data.color;
		weekndTitle.gradient = [
			weekndTitle.color,
			FlxColor.fromRGB(
				weekndTitle.color.red() - 64,
				weekndTitle.color.green() - 64,
				weekndTitle.color.blue() - 64,
				255
			)
		];
		weekndTitle.gradientEnabled = true;
		spriteGroup.add(weekndTitle);
		weekndScript.set('weekndTitle', weekndTitle);

		weekndScript.call('postCreate');
	}

	songsTxt = new KaraokeText(10, 260, FlxG.width-20, 'Songs\n', 16);
	songsTxt.alignment = 'left';
	songsTxt.scrollFactor.set();
	add(songsTxt);

	ratingTxt = new KaraokeText(10, 260, FlxG.width-20, 'Rating\n', 16);
	ratingTxt.alignment = 'right';
	ratingTxt.scrollFactor.set();
	add(ratingTxt);

	playTxt = new KaraokeText(10, 275, FlxG.width-20, 'PLAY', 32);
	playTxt.alignment = 'center';
	playTxt.scrollFactor.set();
	add(playTxt);

	updateSelection();
}

function updateSelection(selected:Int = curSelected) {
	if (selected == null) {
		selected = curSelected;
	}

	songsTxt.text = 'Songs\n';
	for (song in weekndData[selected].songs) {
		songsTxt.text += (song.display == null ? song.name : song.display) + '\n';
	}

	ratingTxt.text = 'Rating\n${weekndData[selected].rating}';
}

var timer:Float = 0.0;
function update(elapsed:Float) {
	timer += elapsed;

	if (controls.ACCEPT) {
		// if (FlxG.keys.pressed.F) {
		// 	noteskin = "fump";
		// }

		FlxG.sound.play(Paths.sound("menus/josh")).persist = true;

		var convertedData = {
			name: weekndData[curSelected].name,
			id: curSelected,
			sprite: '',
			chars: [],
			songs: [
				for (song in weekndData[curSelected].songs)
					song // 😭
			],
			difficulties: [weekndData[curSelected].rating]
		};

		PlayState.playCutscenes = true;
		PlayState.loadWeek(convertedData, weekndData[curSelected].rating);
		FlxG.switchState(new PlayState());
	}

	if (controls.BACK) {
		FlxG.switchState(new ModState('menus/MainMenu'));
	}

	if (controls.LEFT_P) {
		curSelected -= 1;
	} if (controls.RIGHT_P) {
		curSelected += 1;
	}

	playTxt.y = 275 + (Math.sin(timer * 7) + 1) * 0.75;

	FlxG.camera.scroll.x = CoolUtil.fpsLerp(FlxG.camera.scroll.x, FlxG.width*curSelected, 0.12);
}