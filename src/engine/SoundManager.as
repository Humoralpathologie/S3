package engine
{
  import flash.media.Sound;
  import flash.media.SoundTransform;
  import flash.media.SoundChannel;
  import flash.events.Event;
  import com.gskinner.motion.GTween;
  import starling.core.Starling;
  
  /**
   * ...
   * @author
   */
  public class SoundManager
  {
    
    private var _sounds:Object;
    private var _musicPlaying:Array;
    private var _soundsPlaying:Array;
    private var _musicTransform:SoundTransform;
    private var _soundTransform:SoundTransform;
    private var _fadingTween:GTween;
    private var _fadingTweenSFX:GTween;
    private var _level:int = 0;
    private const PLAYING:int = 1;
    private const FADING:int = 2;
    private const STOPPED:int = 3;
    private var STATE:int = STOPPED;

    private const PLAYINGSFX:int = 1;
    private const FADINGSFX:int = 2;
    private const STOPPEDSFX:int = 3;
    private var STATESFX:int = STOPPED;
    private var _musicMuted:Boolean = false;
    private var _SFXMuted:Boolean = false;
    private var _fading:Boolean = false;
    
    public function SoundManager()
    {
      _sounds = {};
      _musicPlaying = [];
      _soundsPlaying = [];
      _musicTransform = new SoundTransform();
      _soundTransform = new SoundTransform();
    }
    
    public function registerSound(name:String, sound:Sound):void
    {
      _sounds[name] = sound;
    }
    
    public function fadeOutMusic(delay:Number = 2):void
    {
      if(STATE == PLAYING) {
        STATE = FADING;
        _fadingTween = new GTween(_musicTransform, delay, {volume: 0}, {onComplete: clearMusic, onChange: updateChannels});
      }
    }
    public function fadeOutSound(delay:Number = 1):void
    {
      if(STATESFX == PLAYINGSFX) {
        STATESFX = FADINGSFX;
        _fadingTweenSFX = new GTween(_soundTransform, delay, {volume: 0}, {onComplete: clearSound, onChange: updateChannels});
      }
    }
    
    private function updateChannels(t:GTween = null):void
    {
      for (var i:int = 0; i < _musicPlaying.length; i++)
      {
        var channel:SoundChannel = _musicPlaying[i];
        if (channel)
        {
          channel.soundTransform = _musicTransform;
        }
      }
      for (var i:int = 0; i < _soundsPlaying.length; i++)
      {
        var channel:SoundChannel = _soundsPlaying[i];
        if (channel)
        {
          channel.soundTransform = _soundTransform;
        }
      }      
    }
    
    private function clearMusic(t:GTween = null):void
    {
      var music:SoundChannel;
      while (music = _musicPlaying.pop())
      {
        music.stop();
      }
      if(!_musicMuted) {
        _musicTransform.volume = 1;
      }
      STATE = STOPPED;
    }
    
    private function clearSound(t:GTween = null):void
    {
      var sound:SoundChannel;
      while (sound = _soundsPlaying.pop())
      {
        sound.stop();
      }
      if(!_SFXMuted) {
        _soundTransform.volume = 1;
      }
      STATESFX = STOPPEDSFX;
    }
    
    public function playMusic(name:String, repeat:Boolean = false):void
    {
      var music:Sound = _sounds[name];
      if (STATE == FADING) {
        _fadingTween.end();
        clearMusic();
      }
      
      if (music)
      {
        var channel:SoundChannel;
        channel = music.play(0, 1, _musicTransform);
        _musicPlaying.push(channel);
        channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
          {
            _musicPlaying.splice(_musicPlaying.indexOf(channel), 1);
            STATE = STOPPED;
            if (repeat) {
              playMusic(name, repeat);
            }
          });
      }
      STATE = PLAYING;
    }
    
    private function muteMusic():void {
      _musicMuted = true;
      _musicTransform.volume = 0;
      updateChannels();
    }
    
    private function unmuteMusic():void {
      _musicMuted = false;
      _musicTransform.volume = 1;
      updateChannels();
    }
    
    private function muteSFX():void {
      _soundTransform.volume = 0;
      updateChannels();
    }
    
    private function unmuteSFX():void {
      _soundTransform.volume = 1;
      updateChannels();
    }
    
    public function get musicMuted():Boolean {
      return _musicMuted;
    }
    
    public function get SFXMuted():Boolean {
      return _SFXMuted;
    }
    
    public function set musicMuted(value:Boolean):void {
      _musicMuted = value;
      if (_musicMuted) {
        muteMusic();
      } else {
        unmuteMusic();
      }
    }
    
    public function set SFXMuted(value:Boolean):void {
      _SFXMuted = value;
      if (SFXMuted) {
        muteSFX();
      } else {
        unmuteSFX();
      }
    }
    
    public function levelMusic():void
    {
      var musicLevels:Array = [AssetRegistry.LevelMusic1Sound, AssetRegistry.LevelMusic2Sound, AssetRegistry.LevelMusic3Sound, AssetRegistry.LevelMusic4Sound];
      if (STATE == FADING) {
        _fadingTween.end();
        clearMusic();
      }
      
      if (STATE == STOPPED)
      {
        _level = 0;
        var music:Sound; 
        var channel:SoundChannel;
        STATE = PLAYING;
        var play:Function = function():void
        {
          trace("Playing music level");
          trace(_level);
          music = musicLevels[Math.min(_level, musicLevels.length - 1)];
          channel = music.play(0, 1, _musicTransform);
          _musicPlaying.push(channel);
          channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
            {
              _musicPlaying.splice(_musicPlaying.indexOf(channel), 1);
              if (STATE == PLAYING) {
                Starling.juggler.delayCall(play, 0.1);
                //play();
              }
            });
        }
        play();
      }
    }
    
    public function playSound(name:String):void
    {
      var sound:Sound = _sounds[name];
      if (STATESFX == FADINGSFX) {
        _fadingTweenSFX.end();
        clearSound();
      }
      if (sound)
      {
        trace("Playing ", name);
        var channel:SoundChannel;
        channel = sound.play(0, 1, _soundTransform);
        _soundsPlaying.push(channel);
        channel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
          {
            _soundsPlaying.splice(_soundsPlaying.indexOf(channel), 1);
            if (name == "eruption") {
              playSound(name);
            }
          });
        
      }
      STATESFX = PLAYINGSFX;
    }
    
    public function get level():int 
    {
        return _level;
    }
    
    public function set level(value:int):void 
    {
        _level = value;
    }
  }

}