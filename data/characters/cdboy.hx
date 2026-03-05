using StringTools;

static var cdboyBody:FunkinSprite;

final updateInterval:Float = 1 / 30;
var lastUpdateTime:Float = 0;

var baseSkew:Float = 0;
var baseHeight:Float = 1;

function postCreate() {
	cdboyBody = new FunkinSprite(x, y).loadSprite(Paths.image('characters/cdboy/cdboyBody'));
	cdboyBody.origin.set(cdboyBody.getGraphicMidpoint().x, cdboyBody.height);
}

var firstFrame:Bool = true;
var alternate:Bool = false;
var timer:Float = 0;
function update(elapsed:Float) {
	timer += elapsed;

	if (firstFrame) {
		firstFrame = false;
		FlxG.state.insert(FlxG.state.members.indexOf(this)+1, cdboyBody);
	}

	if (!cdboyBody.visible || cdboyBody.alpha <= 0.001) {
		return;
	}

	cdboyBody.setPosition(x + globalOffset.x, y + globalOffset.y + 80);

	cdboyBody.scale.set(1, (baseHeight) + -(Math.sin(timer * 2) + 0.75) * 0.05);
	cdboyBody.skew.set(
		baseSkew + (alternate ? 0.5 : -0.5),
		0
	);

	extraOffset.x = -cdboyBody.skew.x;
	extraOffset.y = baseHeight + (Math.sin(timer * 2) + 0.5) * 4.5;

	lastUpdateTime += FlxG.rawElapsed;
	if (lastUpdateTime < updateInterval) {
		return;
	}
	lastUpdateTime = 0;

	alternate = !alternate;

}

function onPlayAnim(event) {
	if (!event.animName.contains('sing')) {
		baseSkew = 0;
		baseHeight = 1;

		return;
	}

	final skewHeightMap:Map<String, {skew:Float, height:Float}> = [
		'left' => {skew: 7, height: 1},
		'down' => {skew: 0, height: 0.93},
		'up' => {skew: 0, height: 1.07},
		'right' => {skew: -7, height: 1}
	];

	final curSkewHeight:{skew:Float, height:Float} = skewHeightMap[event.animName.replace('sing', '').split('-')[0].toLowerCase()];

	baseSkew = curSkewHeight.skew;
	baseHeight = curSkewHeight.height;
}

function destroy() {
	cdboyBody = null;
}