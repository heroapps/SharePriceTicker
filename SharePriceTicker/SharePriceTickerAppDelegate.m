//
//  SharePriceTickerAppDelegate.m
//  SharePriceTicker
//
//  Created by Dan on 19/08/2012.
//  Copyright (c) 2012 HERO Apps. All rights reserved.
//

#import "SharePriceTickerAppDelegate.h"
#import "SBJson.h"

@implementation SharePriceTickerAppDelegate

@synthesize statusMenu = _statusMenu;
@synthesize statusMenuImage = _statusMenuImage;
@synthesize apiChoice = _apiChoice;
@synthesize refreshRate = _refreshRate;
@synthesize showPercentage = _showPercentage;
@synthesize runSharePriceTickerOnStartup = _runSharePriceTickerOnStartup;
@synthesize useNotificationCentreAlerts = _useNotificationCentreAlerts;
@synthesize createPanel = _createPanel;
@synthesize statusBar = _statusBar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    self.statusBar.title = @"Share Price Ticker";
    
    //NSTimer *timer;
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:) userInfo:nil repeats:YES];
    
    //[timer fire];
    
}

- (void) thisMethodGetsFiredOnceEveryThirtySeconds:(id)sender {
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://finance.google.co.uk/finance/info?client=ig&q=LON:FOGL"]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    json_string = [json_string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    json_string = [json_string stringByReplacingOccurrencesOfString:@"//" withString:@""];
    json_string = [json_string stringByReplacingOccurrencesOfString:@"[" withString:@""];
    json_string = [json_string stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    NSDictionary *myDict = [parser objectWithString: json_string];
    
    NSString *statusTitle = [NSString stringWithFormat:@"%@: %@", [myDict objectForKey:@"t"], [myDict objectForKey:@"l"]];
    
    self.statusBar.title = statusTitle;
   
    NSURLRequest *graph = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/finance/chart?q=LON:FOGL&tlf=12"]];
    NSData *image_data = [NSURLConnection sendSynchronousRequest:graph returningResponse:nil error:nil];
    NSImage *img = [[NSImage alloc] initWithData:image_data];
    
    self.statusMenuImage.image = img;
    
    NSLog(@"Current Share Price: %@", statusTitle);
    
    parser = nil;

    
}


- (IBAction) showPrefs:(NSWindow *)sender {
    
    NSLog(@" %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"showPercentage"]);
    
    NSString *percen = [[NSUserDefaults standardUserDefaults] stringForKey:@"showPercentage"];
    
    if([percen isEqualToString:@"ON"] && [[NSUserDefaults standardUserDefaults] stringForKey:@"showPercentage"] != nil)
    {
        _showPercentage.state = NSOnState;
    }
    else
    {
        _showPercentage.state = NSOffState;
    }
    
    NSString *runOnStart = [[NSUserDefaults standardUserDefaults] stringForKey:@"runSharePriceTickerOnStartup"];
    
    if([runOnStart isEqualToString:@"ON"] && [[NSUserDefaults standardUserDefaults] stringForKey:@"runSharePriceTickerOnStartup"] != nil)
    {
        _runSharePriceTickerOnStartup.state = NSOnState;
    }
    else
    {
        _runSharePriceTickerOnStartup.state = NSOffState;
    }
    
    NSString *useNotify = [[NSUserDefaults standardUserDefaults] stringForKey:@"useNotificationCentreAlerts"];
    
    if([useNotify isEqualToString:@"ON"] && [[NSUserDefaults standardUserDefaults] stringForKey:@"useNotificationCentreAlerts"] != nil)
    {
        _useNotificationCentreAlerts.state = NSOnState;
    }
    else
    {
        _useNotificationCentreAlerts.state = NSOffState;
    }

    
    NSLog(@"Clicked to Show the Prefs");
    [self.createPanel makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    
}

- (IBAction)closePreferencesWindow:(id)sender {
    
    [self.createPanel close];
    
}

- (IBAction)saveUserPreferences:(id)sender {
    
    // Save the users preferences in NSUserDefaults
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    if(_showPercentage.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"showPercentage"];
    }
    else
    {
        [usersPreferences setObject:@"OFF" forKey:@"showPercentage"];
    }
    
    if(_runSharePriceTickerOnStartup.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"runSharePriceTickerOnStartup"];
    }
    else
    {
        [usersPreferences setObject:@"OFF" forKey:@"runSharePriceTickerOnStartup"];
    }
    
    if(_useNotificationCentreAlerts.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"useNotificationCentreAlerts"];
    }
    else
    {
        [usersPreferences setObject:@"OFF" forKey:@"useNotificationCentreAlerts"];
    }

}



@end
