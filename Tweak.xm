#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//This interface is an abbreviated version of the class dump for SBUIFlashLightController.h for iOS 13 from Limneos' website

@protocol OS_dispatch_queue;
@class AVFlashlight, NSObject, NSHashTable;

@interface SBUIFlashlightController : NSObject {
    
    AVFlashlight* _flashlight;
    unsigned long long _level;
    BOOL _overheated;
    BOOL _available;
}

//iVars are always declared first (after any  protocols, forward class declarations, and the main interface declaring the parent class), then properties, then methods used in the class

@property (getter=isAvailable,nonatomic,readonly) BOOL available;                //@synthesize available=_available - In the implementation block
@property (getter=isOverheated,nonatomic,readonly) BOOL overheated;              //@synthesize overheated=_overheated - In the implementation block

//Note this only has properties to get the the values of available and overheated, as both are readonly, meaning it is set elsewhere in iOS
//All properties are readwrite by default, unless explicitly set as readonly. So for common properties like background color that are readwrite,
// you don't need to put the readwrite in the property declarations.

@property (assign,nonatomic) unsigned long long level;
//So the level is set with this controller- we learn that by seeing the assign, and the fact that it is readwrite. (And there is both a getter and setter method)
//It appears to share the ability with at least one other controller due to the sharedInstance class method.

+(id)sharedInstance;
-(id)init;
-(unsigned long long)level;
-(BOOL)isAvailable;
-(void)setLevel:(unsigned long long)arg1 ;
-(BOOL)isOverheated;
-(unsigned long long)_loadFlashlightLevel;
-(void)_setFlashlightLevel:(float)arg1 ;
-(void)_turnPowerOn;
-(void)_turnPowerOff;
-(void)_updateStateWithAvailable:(BOOL)arg1 level:(unsigned long long)arg2 overheated:(BOOL)arg3 ;
-(void)turnFlashlightOnForReason:(id)arg1 ;
-(void)turnFlashlightOffForReason:(id)arg1 ;
@end


/* 
There's 3 different haptic feedback choices we can choose from, from low intensity to the highest. 
I used a combo of 1520 for toggling on and setting the flashlight level, and 1521 for updating the state to get a variation of vibration patterns.
AudioServicesPlaySystemSound(1519);  //Light
AudioServicesPlaySystemSound(1520);  //Medium
AudioServicesPlaySystemSound(1521);  //Heaviest
*/


%hook SBUIFlashlightController
-(void)_turnPowerOn {
    %orig;
//Calling %orig first means it will do the original implementation first, so the level should be higher than zero.

   if((self.level > 0) && (self.available)) {
       //If level is greater then zero and the flashlight is available play medium haptic feedback pattern when toggling on.

AudioServicesPlaySystemSound(1520);

    }
}

-(void)_updateStateWithAvailable:(BOOL)arg1 level:(unsigned long long)arg2 overheated:(BOOL)arg3 {
          %orig;
          if((arg2>0) && arg1 && !arg3) {
//This is what causes the constant vibration while pressing a level in the expanded Control Center module.
//Note that if it becomes overheated we tell it to only use the original implementation.
 
              AudioServicesPlaySystemSound(1521);

          }
}

-(void)turnFlashlightOnForReason:(id)arg1 {
    %orig;
    AudioServicesPlaySystemSound(1520);
//This ensures no matter how the flashlight is turned on, it will still toggle the haptic feedback playing the medium "sound" or vibration
}

-(void)_setFlashlightLevel:(float)arg1 {
%orig;
if((arg1>0) && (self.available)) {
//By using a variation of haptic "sounds", 1520 here and 1521 for the updateState method, we get 2 different patterns while adjusting the strength of the flashlight.

AudioServicesPlaySystemSound(1520);
}
}
%end




















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
