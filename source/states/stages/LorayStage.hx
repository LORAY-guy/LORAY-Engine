package states.stages;

class LorayStage extends BaseStage
{
    public var fffback:BGSprite;
    public var ffback:BGSprite;
    public var fback:BGSprite;
    public var back:BGSprite;
    public var mid:BGSprite;
    public var front:BGSprite;
    public var ffront:BGSprite;

	public var computa:FlxSprite;

    private var path:String = 'LORAY/';
	private var computaOffsets:Array<Float> = [0, 1080];

	public var animTimer:Map<String, FlxTimer> = new Map<String, FlxTimer>();

	override function create()
	{
		fffback = new BGSprite(path + 'fffback', -2000, -1050, 0.3, 0.3);
		add(fffback);

        ffback = new BGSprite(path + 'ffback', -2000, -1050, 0.4, 0.4);
		add(ffback);

        fback = new BGSprite(path + 'fback', -2000, -1050, 0.55, 0.55);
		add(fback);

        back = new BGSprite(path + 'back', -2000, -1050, 0.75, 0.75);
		add(back);

		var graphic = Paths.image(path + 'lua');
		computa = new FlxSprite(-662, 124).loadGraphic(graphic, true, Math.floor(graphic.width), Math.floor(graphic.height / 2));
		computa.scale.x = 0.16;
		computa.scale.y = 0.23;
		computa.updateHitbox();

		computa.animation.add('screen', [0, 1], 0, false);
		computa.animation.play('screen');
		add(computa);

        mid = new BGSprite(path + 'mid', -2000, -1050, 1, 1);
		add(mid);

        front = new BGSprite(path + 'front', -2200, -1200, 1.125, 1.125);
		front.setGraphicSize(Std.int(front.width * 1.1));
		front.updateHitbox();
		add(front);

        ffront = new BGSprite(path + 'ffront', -2200, -1200, 1.25, 1.25);
		ffront.setGraphicSize(Std.int(ffront.width * 1.1));
		ffront.updateHitbox();
		add(ffront);

		super.create();
	}

	override function createPost()
	{
		if (PlayState.SONG.song.toLowerCase() == 'heartbeat') setUpHeartBeat();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (dad.animation.curAnim.name != 'idle')
		{
			computa.animation.curAnim.curFrame = 1;

			animTimer.set('pogAnim', new FlxTimer().start(0.9, function(tmr:FlxTimer) {
				if(tmr.finished) {
					computa.animation.curAnim.curFrame = 0;
					animTimer.remove('pogAnim');
				}}
			));
		}
	}

	function setUpHeartBeat()
	{
		dad.visible = false;
		mid.x += 750;
		computa.x += 750;
	}
}