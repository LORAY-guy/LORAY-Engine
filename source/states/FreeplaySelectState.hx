package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class FreeplaySelectState extends MusicBeatState {
    public static var freeplayCats:Array<String> = ['Covers', 'Lore Origins', 'Iron Lung'];
	public var bgTweens:Map<String, FlxTween> = new Map<String, FlxTween>();

    public static var curCategory:Int = 0;
	var curSelected:Int = 0;

	var grpCats:FlxTypedGroup<Alphabet>;
	public var catName:Alphabet;

	var bg:FlxSprite;
	var bgPoster:FlxSprite;

    var categoryIcon:FlxSprite;
	var staticCategoryIcon:FlxSprite;
    
    override function create(){
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Selection Menu", null);
		#end

        bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0xFF00c2ff;
		add(bg);

		bgPoster = new FlxSprite().loadGraphic(Paths.image('category/lore origins'));
		bgPoster.updateHitbox();
		bgPoster.screenCenter();
		insert(1, bgPoster);
		
		persistentUpdate = true;

		var lettabox1:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/lettabox'), X, 0, 0);
		lettabox1.scrollFactor.set(0, 0);
		lettabox1.velocity.set(40, 0);
		lettabox1.y = 635;
		add(lettabox1);

		var lettabox2:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/lettabox2'), X, 0, 0);
		lettabox2.scrollFactor.set(0, 0);
		lettabox2.velocity.set(-40, 0);
		add(lettabox2);

        categoryIcon = new FlxSprite();
        categoryIcon.frames = Paths.getSparrowAtlas('category/category-covers');
        categoryIcon.animation.addByPrefix('idle', 'covers', 24);
        categoryIcon.animation.play('idle');
		categoryIcon.updateHitbox();
		categoryIcon.screenCenter();
		add(categoryIcon);

		catName = new Alphabet(20, (FlxG.height / 2) - 282, freeplayCats[curSelected], true);
		catName.screenCenter(X);
		add(catName);

        changeSelection();

        super.create();
    }

    override public function update(elapsed:Float){
		if (controls.UI_LEFT_P) {
			changeSelection(-1);
        }
		if (controls.UI_RIGHT_P) {
			changeSelection(1);
        }
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
        if (controls.ACCEPT) {
			switch (freeplayCats[curSelected].toLowerCase())
			{
				case 'lore origins', 'iron lung':
					FlxFlicker.flicker(staticCategoryIcon, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							staticCategoryIcon.visible = true;
						}
					);
					CoolUtil.browserLoad((freeplayCats[curSelected].toLowerCase() == 'iron lung' ? 'https://gamebanana.com/mods/451111' : 'https://gamebanana.com/mods/476070'));
				default:
					FlxTween.tween(catName, {alpha: 0}, 0.4, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){catName.kill();}});
					FlxFlicker.flicker(categoryIcon, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						if (freeplayCats[curSelected].toLowerCase() == 'covers') MusicBeatState.switchState(new FreeplayState());
					});
			}
			FlxG.sound.play(Paths.sound('confirmMenu'));
        }
        curCategory = curSelected;
        super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = freeplayCats.length - 1;
		if (curSelected >= freeplayCats.length)
			curSelected = 0;

		catName.destroy();
		catName = new Alphabet(20, (FlxG.height / 2) - 282, freeplayCats[curSelected], true);
		catName.screenCenter(X);
		add(catName);

		switch (freeplayCats[curSelected].toLowerCase())
		{
			case 'lore origins', 'iron lung':
				if (staticCategoryIcon != null) staticCategoryIcon.destroy();
				staticCategoryIcon = new FlxSprite().loadGraphic(Paths.image('category/category-' + freeplayCats[curSelected].toLowerCase()));
				staticCategoryIcon.updateHitbox();
				staticCategoryIcon.screenCenter();
				staticCategoryIcon.y += 210;
				add(staticCategoryIcon);

				if (bgPoster != null) bgPoster.destroy();
				bgPoster = new FlxSprite().loadGraphic(Paths.image('category/' + freeplayCats[curSelected].toLowerCase()));
				bgPoster.updateHitbox();
				bgPoster.screenCenter();
				bgPoster.alpha = 0;
				insert(1, bgPoster);

				bgTweens.set('tweenBG', FlxTween.tween(bgPoster, {alpha: 1}, 0.3, {ease: FlxEase.linear, onComplete: function(twn:FlxTween)
					{
						bgTweens.remove('tweenBG');
					}
				}));
			default:
				if (bgTweens.get('tweenBG') != null) {
					bgTweens.get('tweenBG').cancel();
					bgTweens.remove('tweenBG');
				}
				FlxTween.tween(bgPoster, {alpha: 0}, 0.3, {ease: FlxEase.linear});
		}
		categoryIcon.visible = (freeplayCats[curSelected].toLowerCase() == 'covers');
		if (staticCategoryIcon != null) staticCategoryIcon.visible = (freeplayCats[curSelected].toLowerCase() != 'covers');
	}

	override function beatHit()
	{
		categoryIcon.setGraphicSize(Std.int(categoryIcon.width * 1.1));
		FlxTween.tween(categoryIcon.scale, {x: 1, y: 1}, 0.6, {ease: FlxEase.cubeOut});

		if (staticCategoryIcon != null)
		{
			staticCategoryIcon.setGraphicSize(Std.int(staticCategoryIcon.width * 1.1));
			FlxTween.tween(staticCategoryIcon.scale, {x: 1, y: 1}, 0.6, {ease: FlxEase.cubeOut});
		}
	}
}