import karaoke.game.hud.DefaultHud;

class GAWHud extends DefaultHud {
	override function create() {
		super.create();

		final outlineColor:FlxColor = 0xFFFFFFFF;
		final outlineDraw:(spr:FlxSprite)->Void = (spr:FlxSprite) -> {
			var size:Int = 2;

			spr.setGraphicSize(spr.width + size, spr.height + size);
			spr.colorTransform.color = outlineColor;
			spr.offset.set();
			spr.draw();

			spr.setGraphicSize(spr.width - size, spr.height - size);
			spr.setColorTransform();
			spr.draw();
		}

		healthBar.onDraw = outlineDraw;
		flowBar.onDraw = outlineDraw;

		healthBar.createFilledBar(0xFF000000, 0xFF000000);
		flowBar.createFilledBar(0xFF000000, 0xFFFFFFFF);

		scoreText.onDraw = null;
		scoreText.setFormat(scoreText.font, scoreText.size, 0xFF000000, scoreText.alignment, scoreText.borderStyle, 0xFFFFFFFF);

		remove(playerIconShadow);
		remove(opponentIconShadow);

		playerIconShadow.destroy();
		opponentIconShadow.destroy();
	}
}