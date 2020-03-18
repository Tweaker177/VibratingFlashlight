#include "VFLRootListController.h"
#import <notify.h>
#import <Social/Social.h>
//These last two are needed to use the twitter sharing api, for when the heart is pressed.

@implementation VFLRootListController
//NOTE: CepheiPrefs is a great way to make your settings look better, but to keep this tweak as lightweight as possible I just do it the same way many of my older tweaks were done.
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
//Notice the retain on the end is deleted- that's because objc-arc takes care of retain and releases automatically.
	}

	return _specifiers;
}

//alert function code from open source tweak by dpkg9510
//Always give credit where due
// I usually use a different way to show alerts, but I like the ease of use that this way allows you to use and customize it for multiple alerts.

static void showAlert(NSString *myTitle, NSString *myMessage, UIViewController *presentingController) {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:myTitle message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [presentingController presentViewController:alertController animated:YES completion:nil];
}



- (void)love  //This is the selector that is called when making the button in loadView
{
    SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [twitter setInitialText:@"I’m using #VibratingFlashlight by @BrianVS to make my flashlight and CC sliders use haptic feedback. New package hosted by @YouRepo https://i0s-tweak3r-betas.yourepo.com/pack/vibratingflashlight Works on iOS 11-13.x all devices including A12 and A13."];
    if (twitter != nil) {
        [[self navigationController] presentViewController:twitter animated:YES completion:nil];
    }
}

- (void) loadView
{
    //always call the superview before making changes to the view you are loading
    [super loadView];
    
    UIImage *heart = [[UIImage alloc] initWithContentsOfFile:[[self bundle] pathForResource:@"Heart" ofType:@"png"]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setBackgroundImage:heart forState:UIControlStateNormal];
    [button addTarget:self action:@selector(love) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = YES;
    
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    
    //set the button of the heart image to appear in navigation bar on the right side
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)respring:(id)sender {
    //this can be done a number of ways, including using NSTask, but I prefer posix_spawn
    //you could substitute "backboardd" for "SpringBoard" if you want to re-start backboardd and it's hooks
    // this tweak doesn't use any so SpringBoard works just fine.
    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}



- (void)twitter {
    //Try to open in Twitter App, or Tweetbot, otherwise open in safari
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=brianvs"]];
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/brianvs"]];
    }  else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/brianvs"]];
    }
}

- (void)github {
    //Easy access to view the source code in safari by clicking the link in settings
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Tweaker177/VibratingFlashlight"]];
    
}

- (void)donate
{
    //open my paypal donation link (not that it ever gets used, lol)
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/i0stweak3r"]];
}
- (void)repolink {
    /*
     My main "betas" repo, where many are quality tweaks but not finished, while others are finished but exclusively hosted there.
    I like hosting tweaks only in my repo to encourage people to have it in their source list.
    Most tweaks in the repo aren't necessarily beta, I just have plans to eventually make them better.
    The more I learn the higher my standard becomes for being "release ready" in a default repo.
     */
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://i0s-tweak3r-betas.yourepo.com"]];
}

-(BOOL)shouldShowPirateAlert {
    //This adds a 2nd check to see if package was installed from a pirate repo
    //Just in case the user changes the value of the default in NewTerm
    if (Prefs_getBool(@"isSketch") || ((![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.yourepo.i0s-tweak3r-betas.vibratingflashlight.list"]) && (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.i0stweak3r.vibratingflashlight.list"]))) {
        Prefs_setBoolForKey(NO, @"enabled");
        Prefs_setBoolForKey(YES, @"isSketch");
        return YES;
    }
    else
    {
        Prefs_setBoolForKey(NO, @"isSketch");
        return NO;
    }
}

-(void)showThankYouAlert {
    //Show a thank you alert the first time the tweak settings are opened
        showAlert(@"Thank you for installing VibratingFlashlight", @"Now you can turn the tweak on and off, as well as choose to make just the flashlight vibrate, or you can make the CC Sliders for volume and brightness vibrate as well. \n\n If you have any questions or need support hit me up on Twitter or through your package manager email function. \n\n This alert will no longer appear. Just wanted to thank you for supporting my work.", self);
    Prefs_setBoolForKey(YES, @"hasSeenAlert");
    
}

-(void)showPirateAlert  {
   
    
    NSString *theTitle = @"Why the hell would you pirate this?";
    NSString *theMessage = @"This is a free tweak. Get it from the correct source,\n\n http://i0s-tweak3r-betas.yourepo.com \n\n You are very lucky I am not the type to use malicious DRM.  Or am I? Lmao jk.  If you do see a spinning apple logo that won't go away, I swear it was not me. It was probably from one of your other cracked tweaks.";
    
        showAlert(theTitle, theMessage, self);
    
    }

-(void)viewDidLoad {
    [super viewDidLoad];
    //always call the super before making changes to this method
   
    
    if ([self shouldShowPirateAlert] || Prefs_getBool(@"isSketch")) {
        [self showPirateAlert];
    }
    else if(!Prefs_getBool(@"hasSeenAlert") && !Prefs_getBool(@"isSketch")) {
        [self showThankYouAlert];
    }
        else { return; }
}


@end

