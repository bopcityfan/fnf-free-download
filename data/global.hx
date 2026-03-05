import openfl.Lib;
import openfl.system.Capabilities;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.Main;
import funkin.backend.utils.MemoryUtil;
import funkin.backend.MusicBeatState;
import funkin.savedata.FunkinSave;
import karaoke.backend.debug.DebugInfo;

static var gameSize = {
	X: 400,
	Y: 400
};
final saveDataInitialValues = [
	"introSplash" => true,
	"epilepsy" => false,
	"fullscreenEasterEgg" => true,
	"autoHideFPS" => true,
	"dxStyledStrums" => true,
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
static var debugInfoToggle(default, set):Bool = false;
static function set_debugInfoToggle(value:Bool):Bool {
	if (value) {
		makeDebugInfo();
	} else {
		removeDebugInfo();
	}

	return debugInfoToggle = value;
}

static var fps:Float = 0;
static var memory:Float = 0;
static var memoryPeak:Float = 0;

static var debugInfo:DebugInfo;
static var debugCamera:FlxCamera;

private var frameCount:Int = 0;
private var accumulatedTime:Float = Lib.getTimer();

private final updateInterval:Float = 1 / 15;
private var lastUpdateTime:Float = 0;

//region UTILITY FUNCTIONS
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
//endregion

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

function onCamAdd(cam:FlxCamera) {
	if (debugCamera == null || cam == debugCamera || debugCamera.flashSprite == null) {
		return;
	}

	if (FlxG.cameras.list.contains(debugCamera)) {
		FlxG.cameras.remove(debugCamera, false);
	}

	FlxG.cameras.add(debugCamera, false);
}

function postStateSwitch() {
	if (Main.framerateSprite != null) {
		Main.instance.removeChild(Main.framerateSprite);
	}

	if (FlxG.cameras.list.contains(debugCamera)) {
		FlxG.cameras.remove(debugCamera);

		FlxG.state.remove(debugInfo);
		debugInfo?.destroy();
		debugInfo = null;
	}

	debugCamera = new FlxCamera();
	debugCamera.bgColor = 0;
	FlxG.cameras.add(debugCamera, false);

	if (debugInfoToggle) {
		makeDebugInfo();
	}

	FlxG.cameras.cameraAdded.add(onCamAdd);
}

function makeDebugInfo() {
	removeDebugInfo();

	debugInfo = new DebugInfo(4, 4);
	debugInfo.cameras = [debugCamera];
	FlxG.state.add(debugInfo);
}

function removeDebugInfo() {
	if (debugInfo == null) {
		return;
	}

	FlxG.state.remove(debugInfo);
	debugInfo.destroy();
	debugInfo = null;
}

function updateFPS() {
	final timer:Float = Lib.getTimer();
	final time:Float = timer - accumulatedTime;

	frameCount ++;
	lastUpdateTime += FlxG.rawElapsed;

	if (lastUpdateTime < updateInterval) {
		return;
	}

	accumulatedTime = timer;

	fps = FlxMath.lerp(fps, time <= 0 ? 0 : (1000 / time * frameCount), 1.0 - Math.pow(0.75, time * 0.06));
	lastUpdateTime = frameCount = 0;
}

function updateMemory() {
	final mem = MemoryUtil.currentMemUsage();
	if (mem == memory) {
		return;
	}

	memory = mem;
	if (memoryPeak < memory) {
		memoryPeak = memory;
	}
}

function update(elapsed:Float) {
	updateFPS();
	updateMemory();

	if (FlxG.state?.controls?.FPS_COUNTER) {
		debugInfoToggle = !debugInfoToggle;
	}
}

function postUpdate(elapsed:Float) {
	debugInfo?.update(elapsed);
}

function destroy() {
	initialized = null;
	gameSize = null;

	FlxG.cameras.remove(debugCamera);

	FlxG.state.remove(debugInfo);
	debugInfo.destroy();
	debugInfo = null;

	debugInfoToggle = null;
}