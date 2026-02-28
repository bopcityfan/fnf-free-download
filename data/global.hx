import openfl.system.Capabilities;
import funkin.savedata.FunkinSave;
import funkin.backend.MusicBeatState;
import funkin.backend.system.framerate.Framerate;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxGradient;

static var gameSize = {
	X: 400,
	Y: 400
};
final saveDataInitialValues = [
	"introSplash" => true,
	"epilepsy" => false,
	"fullscreenEasterEgg" => true,
	"autoHideFPS" => true,
	"dxStyledStrums" => false,
	"botplay" => false,
	"noteskin" => "default",
	"showAccuracy" => false
];
final redirectStates = [
	MainMenuState => 'menus/MainMenu',
	StoryMenuState => 'menus/StoryMenu',
	FreeplayState => 'menus/Freeplay'
];

static var initialized:Bool = false;

static function resizeGame(width:Int, height:Int, winWidth:Int, winHeight:Int, center:Bool = true, resizable:Bool = true) {
	FlxG.width = FlxG.initialWidth = width;
	FlxG.height = FlxG.initialHeight = height;
	window.resize(winWidth, winHeight);
	if (resizable == null) {
		window.resizable = true;
	} else {
		window.resizable = resizable;
	}

	for (camera in FlxG.cameras.list) {
		camera.setSize(width, height);
	}

	if (center == null) {
		center = true;
	} else if (!center) {
		return;
	}

	window.x = (Capabilities.screenResolutionX / 2) - (window.width / 2);
	window.y = (Capabilities.screenResolutionY / 2) - (window.height / 2);
}

static function flash(cam:FlxCamera, data:{color:FlxColor, time:Float, force:Bool}, onComplete:Void->Void) {
	if (!FunkinSave.save.data.epilepsy) {
		cam.flash(data.color, data.time, onComplete, data.force);
	} else {
		if (onComplete != null) {
			new FlxTimer().start(data.time, null, onComplete);
		}
	}
}

static function playMenuMusic() {
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music('menu'), true, 1, true, 110);
		FlxG.sound.music.persist = true;
	}
}

function new() {
	if (FlxG.camera != null) {
		FlxG.camera.bgColor = 0xFF000000;
	}

	for (name => value in saveDataInitialValues) {
		if (Reflect.field(FunkinSave.save.data, name) == null) {
			Reflect.setProperty(FunkinSave.save.data, name, value);
		}
	}

	resizeGame(gameSize.X, gameSize.Y, gameSize.X*2, gameSize.Y*2);

	FlxG.mouse.useSystemCursor = true;
	FlxG.mouse.visible = true;
}

function preStateSwitch() {
	if (!initialized) {
		initialized = true;
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.game._requestedState = FunkinSave.save.data.introSplash ? new ModState('menus/SplashScreen') : new ModState('TitleScreen');
	}
}

function postStateSwitch() {
	if (FunkinSave.save.data.autoHideFPS) {
		Framerate.debugMode = 0;
	}
}

function destroy() {
	initialized = null;
	gameSize = null;
}