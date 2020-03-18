#import <spawn.h>
#import <objc/runtime.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

#define Prefs [[NSUserDefaults alloc] initWithSuiteName:@"com.i0stweak3r.vibratingflashlight"]
#define Prefs_setBoolForKey(bool, key) [Prefs setBool:bool forKey:key]
#define Prefs_getBool(key) [Prefs boolForKey:key]
//Ease of use definitions to access whether or not it's from a pirate repo, and if an alert should be shown letting them know why the tweak isn't working.
//These are also use to set a default value for whether the thank you alert has already been seen.

@interface VFLRootListController : PSListController
-(void)love;
- (void)respring:(id)sender;
-(void)twitter;
-(void)donate;
-(void)github;
-(void)repolink;
-(BOOL)shouldShowPirateAlert;
-(void)showThankYouAlert;
-(void)showPirateAlert;
@end

//Basic way to create a custom table cellClass to color switches.
@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
@end

@interface PSSwitchTableCell : PSControlTableCell
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
@end

@interface SRSwitchTableCell : PSSwitchTableCell
@end

@implementation SRSwitchTableCell

-(id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier {
    //init method
    
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
    //Always call the super init method first
    
    if (self) {
        [((UISwitch *)[self control]) setOnTintColor:[UIColor cyanColor]];
        //Color switches in prefs when enabled
        
    }
    return self;
    //for all init methods, you should return self, or %orig; often you can start with self = %orig; then make modifications, like initWithFrame, etc
}

@end
