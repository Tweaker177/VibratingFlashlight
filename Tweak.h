#import <AudioToolbox/AudioServices.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//Abreviated interface from classdump found on Limneos website
@protocol OS_dispatch_queue;
@class AVFlashlight, NSObject, NSHashTable;

@interface SBUIFlashlightController : NSObject {
    //These are iVars
    AVFlashlight* _flashlight;
    NSObject*<OS_dispatch_queue> _flashlightQueue;
    unsigned long long _level;
    NSHashTable* _observers;
    BOOL _overheated;
    BOOL _available;
}
//the readonly properties can only be changed by hooking the iVar, but we can read their values using the getter properies
@property (getter=isAvailable,nonatomic,readonly) BOOL available;                //@synthesize available=_available - In the implementation block
@property (getter=isOverheated,nonatomic,readonly) BOOL overheated;              //@synthesize overheated=_overheated - In the implementation block
//This property is readwrite, so we could set it using dot notation or [self setLevel:someLevel];
@property (assign,nonatomic) unsigned long long level;


+(id)sharedInstance;
-(id)init;
-(unsigned long long)level;
-(void)addObserver:(id)arg1 ;
-(void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void*)arg4 ;
-(void)removeObserver:(id)arg1 ;
-(BOOL)isAvailable;
-(void)setLevel:(unsigned long long)arg1 ;
-(void)warmUp;
-(void)removeAllObservers;
-(BOOL)isOverheated;
-(unsigned long long)_loadFlashlightLevel;
-(void)_postLevelChangeNotification:(unsigned long long)arg1 ;
-(void)_storeFlashlightLevel:(unsigned long long)arg1 ;
-(void)_setFlashlightLevel:(float)arg1 ;
-(void)_turnPowerOn;
-(void)_turnPowerOff;
-(void)_updateStateWithAvailable:(BOOL)arg1 level:(unsigned long long)arg2 overheated:(BOOL)arg3 ;
-(void)_postOverheatedChangeNotification:(BOOL)arg1 ;
-(void)_postAvailabilityChangeNotification:(BOOL)arg1 ;
-(void)turnFlashlightOnForReason:(id)arg1 ;
-(void)turnFlashlightOffForReason:(id)arg1 ;
-(void)coolDown;
@end


