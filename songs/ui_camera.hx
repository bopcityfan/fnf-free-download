import Xml;
import flixel.addons.util.FlxSimplex;

function onSongStart() {
	camZooming = true;
}

public var camera = {
	data: [-1 => {}],


	lock: function(x:Float, y:Float, zoom:Float) {
		_lockData.enabled = true;

		_lockData.x = x;
		_lockData.y = y;
		_lockData.zoom = zoom;
	},

	unlock: function() {
		_lockData.enabled = false;
	},

	snap: () -> {
		if (_lockData.enabled)
			camGame.scroll.set(_lockData.x - camGame.width * 0.5, _lockData.y - camGame.height * 0.5);
		else
			camGame.scroll.set(camera.data[curCameraTarget].x - camGame.width * 0.5, camera.data[curCameraTarget].y - camGame.height * 0.5);
	}
};

public var _lockData:{x:Float, y:Float, zoom:Float, enabled:Bool} = {
	x: 0,
	y: 0,
	zoom: 0,
	enabled: false
};

function postCreate() {
	for (index => sl in strumLines.members) {
		createCamData(index, getCamValues(sl));
	}

	camera.snap();
	camGame.followLerp = 0.02;
}

function postUpdate(elapsed:Float) {
	camGame.scroll.set(FlxMath.roundDecimal(camGame.scroll.x, 2), FlxMath.roundDecimal(camGame.scroll.y, 2));
}

public function createCamData(index:Int, data:{x:Float, y:Float, zoom:Float})
	camera.data[index] = {
		x: data.x,
		y: data.y,
		zoom: data.zoom,
		set: function(x:Float, y:Float, zoom:Float) {
			camera.data[index].x = x;
			camera.data[index].y = y;
			camera.data[index].zoom = zoom;
		}
	};

public function getCamValues(sl:StrumLine):{x:Float, y:Float, zoom:Float} {
	var values = switch(sl.data.position) {
		default: {
			x: 0,
			y: 0,
			zoom: 1
		};
		case 'dad': {
			x: 265,
			y: 171,
			zoom: 1
		};
		case 'girlfriend': {
			x: 420,
			y: 172,
			zoom: 1
		};
		case 'boyfriend': {
			x: 450,
			y: 171,
			zoom: 1
		};
	};

	function doCheck(node:Xml, data:{x:Float, y:Float, zoom:Float}) {
		if (node.exists('camx')) data.x = Std.parseFloat(node.get('camx'));
		if (node.exists('camy')) data.y = Std.parseFloat(node.get('camy'));
		if (node.exists('zoom')) data.zoom = Std.parseFloat(node.get('zoom'));

		return data;
	}

	for (node in Xml.parse(Assets.getText(stage.stagePath)).firstElement().elements()) {
		switch(node.nodeName) {
			case 'character':
				if (node.exists('name') && [for (i in sl.characters) i].contains(node.get('name')))
					values = doCheck(node, values);
				else continue;
			case 'dad' | 'opponent':
				if (sl.data.position != 'dad') continue;
				values = doCheck(node, values);
			case 'boyfriend' | 'bf' | 'player':
				if (sl.data.position != 'boyfriend') continue;
				values = doCheck(node, values);
			case 'girlfriend' | 'gf':
				if (sl.data.position != 'girlfriend') continue;
				values = doCheck(node, values);
		};
	}

	return values;
}

function onCameraMove(event) {
	if (startingSong) {
		camGame.snapToTarget();
	}

	if (!_lockData.enabled) {
		var curTarget = camera.data[curCameraTarget];
		event.position.set(curTarget.x, curTarget.y);
		defaultCamZoom = curTarget.zoom;
	} else {
		event.position.set(_lockData.x, _lockData.y);
		defaultCamZoom = _lockData.zoom;
	}
}