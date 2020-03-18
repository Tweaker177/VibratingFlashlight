#import "Tweak.h"
#define Prefs [[NSUserDefaults alloc] initWithSuiteName:@"com.i0stweak3r.vibratingflashlight"]
//This is used for setting and getting pref values outside of the loadPrefs() function
//Mainly just for checking if installed from a pirate repo


const CGFloat firmware =  [[UIDevice currentDevice].systemVersion floatValue];
//used to determine which group to %init so we don't hook unneeded methods

static bool kIsSketch = NO; //kIsSketch = my way of checking if it's sketchy / shady / pirated
static bool kEnabled = YES;
static bool kWantsFlashlight = YES;
static bool kWantsCCSliders = YES;

/*
 There's 3 different haptic feedback choices we can choose from, from low intensity to the highest.
 I used a combo of 1520 for toggling on and setting the flashlight level, and 1521 for updating the state to get a variation of vibration patterns.
 AudioServicesPlaySystemSound(1519);  //Light
 AudioServicesPlaySystemSound(1520);  //Medium
 AudioServicesPlaySystemSound(1521);  //Heaviest
 */

%hook SBUIFlashlightController
-(void)_turnPowerOn {
    if(!kEnabled || !kWantsFlashlight) { return %orig; }
    %orig;
    //Calling %orig first means it will do the original implementation first, so the level should be higher than zero.
    
    if((self.level > 0) && (self.available)) {
        //If level is greater then zero and the flashlight is available play medium haptic feedback pattern when toggling on.
        
        AudioServicesPlaySystemSound(1520);
        
    }
}

-(void)_updateStateWithAvailable:(BOOL)arg1 level:(unsigned long long)arg2 overheated:(BOOL)arg3 {
    if(!kEnabled || !kWantsFlashlight) { return %orig; }
    %orig;
    if((arg2>0) && arg1 && !arg3) {
        //This is what causes the constant vibration while pressing a level in the expanded Control Center module.
        //Note that if it becomes overheated we tell it to only use the original implementation.
        
        AudioServicesPlaySystemSound(1521);
        
    }
}

-(void)turnFlashlightOnForReason:(id)arg1 {
    if(!kEnabled || !kWantsFlashlight) { return %orig; }
    %orig;
    AudioServicesPlaySystemSound(1520);
    //This ensures no matter how the flashlight is turned on, it will still toggle the haptic feedback playing the medium "sound" or vibration
}

-(void)_setFlashlightLevel:(float)arg1 {
    if(!kEnabled || !kWantsFlashlight) { return %orig; }
    %orig;
    if((arg1>0) && (self.available)) {
        //By using a variation of haptic "sounds", 1520 here and 1521 for the updateState method, we get 2 different patterns while adjusting the strength of the flashlight.
        
        AudioServicesPlaySystemSound(1520);
    }
}
%end





%group iOS11and12

%hook CCUIModuleSliderView
-(void)_handleValueChangeGestureRecognizer:(id)arg1 {
    if(!kEnabled || !kWantsCCSliders) { return %orig; }
    %orig;
    AudioServicesPlaySystemSound(1521);
}

-(void)_handleValueTapGestureRecognizer:(id)arg1 {
    if(!kEnabled || !kWantsCCSliders) { return %orig; }
    %orig;
    AudioServicesPlaySystemSound(1520);
}

-(void)setThrottleUpdates:(BOOL)arg1 {
    if(!kEnabled || !kWantsCCSliders) { return %orig; }
    %orig;
    if(arg1) {
        AudioServicesPlaySystemSound(1520);
    }
}
%end

%end // End of iOS 11 and 12 group

//%group iOS13

//iOS13 has some of same methods but in a different view
%hook CCUIContinuousSliderView
  -(void)_updateValueForPanGestureRecognizer:(id)arg1 forContinuedGesture:(BOOL)arg2 {
       if(!kEnabled || !kWantsCCSliders) { return %orig; }
arg2 = 1;
%orig(arg1, arg2);
  AudioServicesPlaySystemSound(1521);

}

-(void)_handleValueChangeGestureRecognizer:(id)arg1 {
    if(!kEnabled || !kWantsCCSliders) { return %orig; }
    %orig;
    AudioServicesPlaySystemSound(1521);
}


%end 

//%end 
// end of group iOS13



//Handle Prefs and Set Defaults
//Also make it so if the bundleID is from a pirate repo it won't work
//Note this is a very weak form of "DRM", people can still steal it a number of ways
//The main intent is to stop people not smart enough to steal it directly and would only be able
//to get it if it's in a pirate repo. (Which is stupid considering this is a free tweak) Sadly, I've
//had lots of pirate repos hosting free (and paid) tweaks from my beta repo.
//End result is YouTubers reviewing the tweak and listing the pirate repo as the source.
// F*ck YOU HYI, Pulandres and all the others guilty of said F*ckery

static void
loadPrefs() {
    static NSUserDefaults *prefs = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"com.i0stweak3r.vibratingflashlight"];
    
    kIsSketch = [prefs objectForKey:@"isSketch"] ? [prefs boolForKey:@"isSketch"] : kIsSketch;
    
    kEnabled =  ([[prefs objectForKey:@"enabled"] boolValue] && !kIsSketch) ? [prefs boolForKey:@"enabled"] : NO;

    kWantsFlashlight = ([[prefs objectForKey:@"wantsFlashlight"] boolValue] && !kIsSketch) ? [prefs boolForKey:@"wantsFlashlight"] : NO;
        
    kWantsCCSliders =  ([[prefs objectForKey:@"wantsCCSliders"] boolValue] && !kIsSketch) ? [prefs boolForKey:@"wantsCCSliders"] : NO;


}

%ctor {
    //%ctor = the constructor, which is only needed since we are using prefs with callbacks
    //and groups with separate %init calls, which autorelease since we are using objc-arc.
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.vibratingflashlight-prefsreload"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    kIsSketch = NO;
    
    if((![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.yourepo.i0s-tweak3r-betas.vibratingflashlight.list"]) && (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.i0stweak3r.vibratingflashlight.list"])) {
        
        
        kIsSketch = YES;


        [Prefs setBool:YES forKey:@"isSketch"];
        [Prefs setBool:NO forKey:@"enabled"];
    }
    else {
        kIsSketch = NO;
        [Prefs setBool:NO forKey:@"isSketch"];
    }
    
    loadPrefs();
    
    if(!kIsSketch) {
       /* if(firmware >= 13.0) {
        %init(iOS13);
        
        }
        if(firmware < 13.0) {
       */
        %init(iOS11and12);
        //}
        /*Not sure which method was needed from group iOS11and12 but for some reason it wasn't working right when separating it from iOS13 group so I ditched the firmware groups for now.
         */
    
  }  //end of checking if kIsSketch, the bool for if it's from a pirate repo
    %init; //ungrouped init, for hooks that aren't in a group, can apply to iOS 11-13
} //end of constructor












//This is the default commented out tutorial code that comes when starting a tweak with $THEOS/bin/nic.pl

/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
