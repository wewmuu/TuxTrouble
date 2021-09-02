package;

import openfl.Lib;
#if windows
import llua.Lua;
#end
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class GallerySubState extends MusicBeatSubstate
{

	var fullImage:FlxSprite;
	var imageTitle:FlxText;
	var imageDesc:FlxText;

	public function new()
	{
		super();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		fullImage = new FlxSprite(0, 0);
		fullImage.scrollFactor.set();
		fullImage.loadGraphic(Paths.image('full_images/' + GalleryState.instance.itemList[GalleryState.instance.curSelected][0], 'gallery'));
		fullImage.setGraphicSize(-1, Std.int(FlxG.height * 0.6));
		fullImage.updateHitbox();
		fullImage.screenCenter(XY);
		fullImage.y -= 100;
		fullImage.antialiasing = true;
		add(fullImage);

		imageTitle = new FlxText(0, 0, 0, GalleryState.instance.itemList[GalleryState.instance.curSelected][0], 12);
		imageTitle.setFormat(Paths.font("Delfino.otf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		imageTitle.borderSize = 3;
		imageTitle.antialiasing = true;
		imageTitle.updateHitbox();
		imageTitle.scrollFactor.set();
		imageTitle.screenCenter(X);
		imageTitle.y = fullImage.y + fullImage.height;
		add(imageTitle);

		imageDesc = new FlxText(0, 0, FlxG.width*0.6, GalleryState.instance.itemList[GalleryState.instance.curSelected][1], 12);
		imageDesc.setFormat(Paths.font("Delfino.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
		imageDesc.borderSize = 3;
		imageDesc.antialiasing = true;
		imageDesc.updateHitbox();
		imageDesc.scrollFactor.set();
		imageDesc.screenCenter(X);
		imageDesc.y = imageTitle.y + imageTitle.height;
		add(imageDesc);
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

		if (controls.BACK)
		{
			close();
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		var prevSelected = GalleryState.instance.curSelected;

		GalleryState.instance.curSelected += huh;

		var horizontal:Bool = (huh == 4 || huh == -4);

		if (GalleryState.instance.curSelected < 0 && horizontal && prevSelected == 0)
			GalleryState.instance.curSelected = GalleryState.instance.itemList.length - 4; // hardcoded. we con't have much time, and I need a working menu :(
		else if (GalleryState.instance.curSelected < 0 && horizontal && prevSelected == 3)
			GalleryState.instance.curSelected = GalleryState.instance.itemList.length - 1; // hardcoded. we con't have much time, and I need a working menu :(
		else if (GalleryState.instance.curSelected < 0 && horizontal && prevSelected == 1)
			GalleryState.instance.curSelected = GalleryState.instance.itemList.length - 3; // hardcoded. we con't have much time, and I need a working menu :(
		else if (GalleryState.instance.curSelected < 0 && horizontal)
			GalleryState.instance.curSelected = GalleryState.instance.itemList.length - (prevSelected % 4);
		else if (GalleryState.instance.curSelected >= GalleryState.instance.itemList.length && horizontal)
			GalleryState.instance.curSelected = prevSelected % 4;

		if (GalleryState.instance.curSelected >= GalleryState.instance.itemList.length)
			GalleryState.instance.curSelected = 0;
		else if (GalleryState.instance.curSelected < 0)
			GalleryState.instance.curSelected = GalleryState.instance.itemList.length - 1;

		fullImage.loadGraphic(Paths.image('full_images/' + GalleryState.instance.itemList[GalleryState.instance.curSelected][0], 'gallery'));
		fullImage.setGraphicSize(-1, Std.int(FlxG.height * 0.6));
		fullImage.updateHitbox();
		fullImage.screenCenter(XY);
		fullImage.y -= 100;

		imageTitle.text = GalleryState.instance.itemList[GalleryState.instance.curSelected][0];
		imageTitle.updateHitbox();
		imageTitle.screenCenter(X);
		imageTitle.y = fullImage.y + fullImage.height;

		imageDesc.text = GalleryState.instance.itemList[GalleryState.instance.curSelected][1];
		imageDesc.updateHitbox();
		imageDesc.screenCenter(X);
		imageDesc.y = imageTitle.y + imageTitle.height;

		GalleryState.instance.menuCursor.x = GalleryState.instance.menuItems.members[GalleryState.instance.curSelected].x - 10;
		GalleryState.instance.menuCursor.y = GalleryState.instance.menuItems.members[GalleryState.instance.curSelected].y - 10;
		GalleryState.instance.menuCursorGhost.y = GalleryState.instance.menuItems.members[GalleryState.instance.curSelected].y - 10;

	}

}
