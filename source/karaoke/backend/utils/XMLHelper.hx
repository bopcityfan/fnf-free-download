package karaoke.backend.utils;

import Xml;
import funkin.backend.FunkinSprite.XMLAnimType;
import funkin.backend.utils.XMLUtil;

// copied from funkin.backend.utils.XMLUtil and modified
// cuz we CAN'T USE FUCKING ACCESS
class XMLHelper {
	static public function loadSpriteFromXML(spr:FunkinSprite, node:Xml, parentFolder:String = "", defaultAnimType:XMLAnimType = XMLAnimType.BEAT, loadSprite:Bool = true):FunkinSprite {
		parentFolder = parentFolder ?? "";
		defaultAnimType = defaultAnimType ?? XMLAnimType.BEAT;
		loadSprite = loadSprite ?? true;

		spr.name = node.get("name");
		spr.antialiasing = false;
		if (loadSprite) {
			spr.loadSprite(Paths.image('$parentFolder${node.get("sprite") ?? spr.name}', null, true));
		}

		spr.spriteAnimType = defaultAnimType;
		if (node.exists('type')) {
			spr.spriteAnimType = XMLAnimType.fromString(node.get('type'), spr.spriteAnimType);
		}

		if (node.exists('x')) spr.x = Std.parseFloat(node.get('x')) ?? spr.x;
		if (node.exists('y')) spr.y = Std.parseFloat(node.get('y')) ?? spr.y;
		if (node.exists('scrollx')) spr.scrollFactor.x = Std.parseFloat(node.get('scrollx')) ?? spr.scrollFactor.x;
		if (node.exists('scrolly')) spr.scrollFactor.y = Std.parseFloat(node.get('scrolly')) ?? spr.scrollFactor.y;
		if (node.exists('skewx')) spr.skew.x = Std.parseFloat(node.get('skewx')) ?? spr.skew.x;
		if (node.exists('skewy')) spr.skew.y = Std.parseFloat(node.get('skewy')) ?? spr.skew.y;
		if (node.exists('width')) spr.width = Std.parseFloat(node.get('width')) ?? spr.width;
		if (node.exists('height')) spr.height = Std.parseFloat(node.get('height')) ?? spr.height;
		if (node.exists('scalex')) spr.scale.x = Std.parseFloat(node.get('scalex')) ?? spr.scale.x;
		if (node.exists('scaley')) spr.scale.y = Std.parseFloat(node.get('scaley')) ?? spr.scale.y;
		if (node.exists('zoomfactor')) spr.zoomFactor = Std.parseFloat(node.get('zoomfactor')) ?? spr.zoomFactor;
		if (node.exists('alpha')) spr.alpha = Std.parseFloat(node.get('alpha')) ?? spr.alpha;
		if (node.exists('angle')) spr.angle = Std.parseFloat(node.get('angle')) ?? spr.angle;

		if (node.exists('beatInterval')) spr.beatInterval = Std.parseFloat(node.get('beatInterval')) ?? spr.beatInterval;
		if (node.exists('interval')) spr.beatInterval = Std.parseFloat(node.get('interval')) ?? spr.beatInterval;
		if (node.exists('beatOffset')) spr.beatOffset = Std.parseFloat(node.get('beatOffset')) ?? spr.beatOffset;

		if (node.exists('applyStageMatrix')) spr.applyStageMatrix = node.get('applyStageMatrix') == true;
		if (node.exists('useRenderTexture')) spr.useRenderTexture = node.get('useRenderTexture') == true;
		if (node.exists('antialiasing')) spr.antialiasing = node.get('antialiasing') == true;
		if (node.exists('flipX')) spr.flipX = node.get('flipX') == true;
		if (node.exists('flipY')) spr.flipY = node.get('flipY') == true;
		if (node.exists('playOnCountdown')) spr.skipNegativeBeats = node.get('playOnCountdown') == true;

		if (node.exists('updateHitbox') && node.get('updateHitbox') == "true") {
			spr.updateHitbox();
		}

		if (node.exists('scroll')) {
			var value:Float = Std.parseFloat(node.get('scroll'));
			if (value != null) {
				spr.scrollFactor.set(value, value);
			}
		}
		if (node.exists('scale')) {
			var value:Float = Std.parseFloat(node.get('scale'));
			if (value != null) {
				spr.scale.set(value, value);
			}
		}
		if (node.exists('graphicSize')) {
			var graphicSize:Int = Std.parseInt(node.get('graphicSize'));
			if (graphicSize != null) {
				spr.setGraphicSize(graphicSize, graphicSize);
			}
		}
		if (node.exists('graphicSizex')) {
			var graphicSizex:Int = Std.parseInt(node.get('graphicSizex'));
			if (graphicSizex != null) {
				spr.setGraphicSize(graphicSizex, 0);
			}
		}
		if (node.exists('graphicSizey')) {
			var graphicSizey:Int = Std.parseInt(node.get('graphicSizey'));
			if (graphicSizey != null) {
				spr.setGraphicSize(0, graphicSizey);
			}
		}

		if (node.exists('color')) {
			spr.color = FlxColor.fromString(node.get("color")) ?? 0xFFFFFFFF;
		}

		for (anim in node.elementsNamed('anim')) {
			addXMLAnimation(spr, anim);
		}

		if (spr.frames != null && spr.frames.frames != null) {
			addAnimToSprite(spr, {
				name: "idle",
				anim: null,
				fps: 24,
				loop: spr.spriteAnimType == XMLAnimType.LOOP,
				animType: spr.spriteAnimType,
				x: 0,
				y: 0,
				indices: [for(i in 0...spr.frames.frames.length) i],
				label: false
			});
		}

		return spr;
	}

	static public function createSpriteFromXML(node:Xml, parentFolder:String = "", defaultAnimType:XMLAnimType = XMLAnimType.BEAT, loadSprite:Bool = true):FunkinSprite {
		parentFolder = parentFolder ?? "";
		defaultAnimType = defaultAnimType ?? XMLAnimType.BEAT;
		loadSprite = loadSprite ?? true;

		return loadSpriteFromXML(new FunkinSprite(), node, parentFolder, defaultAnimType, loadSprite);
	}

	static public function addXMLAnimation(sprite:FlxSprite, anim:Xml, loop:Bool = false):Int {
		loop = loop ?? false;

		var animType:XMLAnimType = XMLAnimType.NONE;
		if (sprite is FunkinSprite) {
			animType = sprite.spriteAnimType;
		}

		return XMLUtil.addAnimToSprite(sprite, extractAnimFromXML(anim, animType, loop));
	}

	static public function extractAnimFromXML(anim:Xml, animType:XMLAnimType = XMLAnimType.NONE, loop:Bool = false):AnimData {
		animType = animType ?? XMLAnimType.NONE;
		loop = loop ?? false;

		var animData:AnimData = {
			name: null,
			anim: null,
			fps: 24,
			loop: loop,
			animType: animType,
			x: 0,
			y: 0,
			indices: [],
			label: false
		};

		if (anim.exists('name')) animData.name = anim.get('name');
		if (anim.exists('type')) animData.animType = XMLAnimType.fromString(anim.get('type'), animData.animType);
		if (anim.exists('anim')) animData.anim = anim.get('anim');
		if (anim.exists('fps')) animData.fps = Std.parseFloat(anim.get('fps')) ?? animData.fps;
		if (anim.exists('x')) animData.x = Std.parseFloat(anim.get('x')) ?? animData.x;
		if (anim.exists('y')) animData.y = Std.parseFloat(anim.get('y')) ?? animData.y;
		if (anim.exists('loop')) animData.loop = anim.get('loop') == "true";
		if (anim.exists('forced')) animData.forced = anim.get('forced') == "true";
		if (anim.exists('indices')) animData.indices = CoolUtil.parseNumberRange(anim.get('indices'));
		if (anim.exists('label')) animData.label = anim.get('label') == "true";

		return animData;
	}
}