package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.FlxSubState;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

// the fucking gallery

class GalleryState extends MusicBeatState
{

	public static var instance:GalleryState = null;

	public var curSelected:Int = 0;

	public var menuCursor:FlxSprite;
	public var menuCursorGhost:FlxSprite;

	public var menuItems:FlxSpriteGroup;
	public var itemList:Array<Array<String>> = [];

	var inSubstate:Bool = false;



	override function create()
	{

		instance = this;

		FlxG.sound.music.stop();
		FlxG.sound.playMusic(Paths.music('bees_nuts', 'gallery'), 0);
		FlxG.sound.music.fadeIn(4, 0, 0.7);

		var bg:TrollBG = new TrollBG(0, 0);
		bg.loadGraphic(Paths.image('peDesat'));
		bg.color = FlxColor.PINK;
		bg.setGraphicSize(Std.int(bg.width * 1.1), Std.int(bg.height * 1.1));
		bg.updateHitbox();
		bg.antialiasing = true;
		bg.scrollFactor.set(0, 0);
		add(bg);

		// cursor should be 600x600
		menuCursor = new FlxSprite(55, 150).makeGraphic(270, 270, FlxColor.WHITE);
		add(menuCursor);
		menuCursorGhost = new FlxSprite(0, 150).makeGraphic(270, 270, FlxColor.WHITE);
		menuCursorGhost.screenCenter(X);
		menuCursorGhost.visible = false;
		add(menuCursorGhost);

		menuItems = new FlxSpriteGroup(0, 0);
		add(menuItems);

		var menuHeader:FlxText = new FlxText(0, 20, 0, 'Gallery', 12);
		menuHeader.setFormat("friday night", 118, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		menuHeader.borderSize = 3;
		menuHeader.antialiasing = true;
		menuHeader.updateHitbox();
		menuHeader.screenCenter(X);

		#if web
		menuHeader.y -= 20;
		#end

		add(menuHeader);

		var theFuckingTextFile:Array<String> = CoolUtil.coolTextFile(Paths.txt('gallery-data', 'gallery'));
		for (i in theFuckingTextFile)
		{
			var theSplitz = i.split('--');
			itemList.push(theSplitz);
		}

		for (i in 0...itemList.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('menu_sprites/' + itemList[i][0], 'gallery'));
			menuItem.scale.x = 0.5;
			menuItem.scale.y = menuItem.scale.x;
			menuItem.updateHitbox();

			if (i != 0 && !(i % 4 == 0))
			{
				menuItem.y = menuItems.members[i-1].y;
				menuItem.x = menuItems.members[i-1].x + menuItems.members[i-1].width + 50;
			}
			else if (i != 0 && (i % 4 == 0))
			{
				menuItem.y = menuItems.members[i-1].y + menuItems.members[i-1].height + 50;
				menuItem.x = 65;
			}
			else
			{
				menuItem.x = 65;
				menuItem.y = 160;
			}

			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		FlxG.camera.follow(menuCursorGhost, LOCKON, 0.2);

		super.create();
	}

	var selectedSomethin:Bool = false;

	function changeItem(huh:Int = 0)
	{
		var prevSelected = curSelected;

		curSelected += huh;

		var horizontal:Bool = (huh == 4 || huh == -4);

		if (curSelected < 0 && horizontal && prevSelected == 0)
			curSelected = menuItems.length - 4; // hardcoded. we don't have much time, and I need a working menu :(
		else if (curSelected < 0 && horizontal && prevSelected == 3)
			curSelected = menuItems.length - 1; // hardcoded. we don't have much time, and I need a working menu :(
		else if (curSelected < 0 && horizontal && prevSelected == 1)
			curSelected = menuItems.length - 3; // hardcoded. we don't have much time, and I need a working menu :(
		else if (curSelected < 0 && horizontal)
			curSelected = menuItems.length - (prevSelected % 4);
		else if (curSelected >= menuItems.length && horizontal)
			curSelected = prevSelected % 4;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		else if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuCursor.x = menuItems.members[curSelected].x - 10;
		menuCursor.y = menuItems.members[curSelected].y - 10;
		menuCursorGhost.y = menuItems.members[curSelected].y - 10;

	}

	override function update(elapsed:Float)
	{

		if (controls.LEFT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(-1);
		}

		else if (controls.RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(1);
		}

		else if (controls.UP_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(-4);
		}

		else if (controls.DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(4);
		}

		if (controls.ACCEPT)
		{
			openSubState(new GallerySubState());
		}

		menuCursor.x = menuItems.members[curSelected].x - 10;
		menuCursor.y = menuItems.members[curSelected].y - 10;
		menuCursorGhost.y = menuItems.members[curSelected].y - 10;

		if (controls.BACK)
		{
			FlxG.mouse.visible = false;

			if (FlxG.random.bool(1))
				FlxG.sound.play(Paths.sound('cancelMenuAlt'));
			else
				FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);

	}

	override function openSubState(SubState:FlxSubState)
	{
		inSubstate = true;

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		inSubstate = false;

		menuCursor.x = menuItems.members[curSelected].x - 10;
		menuCursor.y = menuItems.members[curSelected].y - 10;
		menuCursorGhost.y = menuItems.members[curSelected].y - 10;

		super.closeSubState();
	}

}
