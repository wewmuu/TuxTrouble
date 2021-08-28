package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		// BASE GAME (some icons are replaced)

		animation.add('null', [0, 1], 0, false, isPlayer);
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('bf-car', [0, 1], 0, false, isPlayer);
		animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
		animation.add('spooky', [2, 3], 0, false, isPlayer);
		animation.add('pico', [4, 5], 0, false, isPlayer);
		animation.add('mom', [6, 7], 0, false, isPlayer);
		animation.add('mom-car', [6, 7], 0, false, isPlayer);
		animation.add('tankman', [8, 9], 0, false, isPlayer);
		animation.add('face', [10, 11], 0, false, isPlayer);
		animation.add('dad', [12, 13], 0, false, isPlayer);
		animation.add('jarjar', [12, 13], 0, false, isPlayer);
		animation.add('senpai', [22, 22], 0, false, isPlayer);
		animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
		animation.add('spirit', [23, 23], 0, false, isPlayer);
		animation.add('bf-old', [14, 15], 0, false, isPlayer);
		animation.add('gf', [16], 0, false, isPlayer);
		animation.add('gf-christmas', [16], 0, false, isPlayer);
		animation.add('gf-pixel', [16], 0, false, isPlayer);
		animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		animation.add('monster', [19, 20], 0, false, isPlayer);
		animation.add('monster-christmas', [19, 20], 0, false, isPlayer);

		// TUX TROUBLE

		animation.add('gf-hell', [16], 0, false, isPlayer);
		animation.add('gf-throne', [16], 0, false, isPlayer);
		animation.add('gf-gone', [16], 0, false, isPlayer);

		animation.add('trolling', [24, 25], 0, false, isPlayer);
		animation.add('trolling_old', [24, 25], 0, false, isPlayer);
		animation.add('bsuit_tt', [24, 25], 0, false, isPlayer);

		animation.add('bsuit', [26, 27], 0, false, isPlayer);
		animation.add('bsuit_old', [26, 27], 0, false, isPlayer);
		animation.add('bsuit_transition', [34, 35], 0, false, isPlayer);
		animation.add('bsuit_angy', [34, 35], 0, false, isPlayer);

		animation.add('beastie', [28, 29], 0, false, isPlayer);
		animation.add('beastie_old', [28, 29], 0, false, isPlayer);
		animation.add('beastie_beta', [24, 25], 0, false, isPlayer); // uses trolling icons

		animation.add('amongus', [30, 31], 0, false, isPlayer);

		animation.add('troublemakers', [32, 33], 0, false, isPlayer);

		// FREESTYLE

		animation.add('noah', [40, 41], 0, false, isPlayer);

		animation.add('freestyle-hell', [16], 0, false, isPlayer);
		animation.add('freestyle-hell_alt', [16], 0, false, isPlayer);

		animation.add('freestyle_beastie', [36, 37], 0, false, isPlayer);

		animation.add('freestyle_troublemakers', [38, 39], 0, false, isPlayer);



		// Super TuxKart

		animation.add('null__stk', [22, 22], 0, false, isPlayer);
		animation.add('bf__stk', [22, 22], 0, false, isPlayer);
		animation.add('bf-car__stk', [22, 22], 0, false, isPlayer);

		animation.add('gf-hell__stk', [16], 0, false, isPlayer);
		animation.add('gf-throne__stk', [16], 0, false, isPlayer);
		animation.add('gf-gone__stk', [16], 0, false, isPlayer);

		animation.add('trolling__stk', [21, 21], 0, false, isPlayer);
		animation.add('trolling_old__stk', [21, 21], 0, false, isPlayer);
		animation.add('bsuit_tt__stk', [21, 21], 0, false, isPlayer);

		animation.add('bsuit__stk', [11, 11], 0, false, isPlayer);
		animation.add('bsuit_old__stk', [11, 11], 0, false, isPlayer);
		animation.add('bsuit_transition__stk', [21, 21], 0, false, isPlayer);
		animation.add('bsuit_angy__stk', [21, 21], 0, false, isPlayer);

		animation.add('beastie__stk', [21, 21], 0, false, isPlayer);
		animation.add('beastie_old__stk', [21, 21], 0, false, isPlayer);
		animation.add('beastie_beta__stk', [21, 21], 0, false, isPlayer); // uses trolling icons

		animation.add('amongus__stk', [30, 31], 0, false, isPlayer);

		animation.add('troublemakers__stk', [20, 20], 0, false, isPlayer);

		animation.add('noah__stk', [23, 23], 0, false, isPlayer);

		animation.add('freestyle-hell__stk', [16], 0, false, isPlayer);
		animation.add('freestyle-hell_alt__stk', [16], 0, false, isPlayer);

		animation.add('freestyle_beastie__stk', [10, 10], 0, false, isPlayer);

		animation.add('freestyle_troublemakers__stk', [12, 12], 0, false, isPlayer);

		animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
			default:
				antialiasing = true;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
