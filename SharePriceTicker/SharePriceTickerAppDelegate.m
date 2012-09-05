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
@synthesize shareSymTable = _shareSymTable;
@synthesize apiChoice = _apiChoice;
@synthesize refreshRate = _refreshRate;
@synthesize showPercentage = _showPercentage;
@synthesize runSharePriceTickerOnStartup = _runSharePriceTickerOnStartup;
@synthesize useNotificationCentreAlerts = _useNotificationCentreAlerts;
@synthesize createPanel = _createPanel;
@synthesize statusBar = _statusBar;
@synthesize refreshRateTimer = _refreshRateTimer;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Check if we have any nil values and if so, save some defaults
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    NSString *storedRefreshRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshRate"];
    
    if([storedRefreshRate isEqual:nil])
    {
        [usersPreferences setObject:@"30" forKey:@"refreshRate"];
    }
    
    NSString *storedPercen = [[NSUserDefaults standardUserDefaults] stringForKey:@"showPercentage"];

    if([storedPercen isEqual:nil])
    {
        [usersPreferences setObject:@"OFF" forKey:@"showPercentage"];
    }

    NSString *runOnStart = [[NSUserDefaults standardUserDefaults] stringForKey:@"runSharePriceTickerOnStartup"];

    if([runOnStart isEqual:nil])
    {
        [usersPreferences setObject:@"ON" forKey:@"runSharePriceTickerOnStartup"];
    }

    NSString *useNotify = [[NSUserDefaults standardUserDefaults] stringForKey:@"useNotificationCentreAlerts"];
 
    if([useNotify isEqual:nil])
    {
        [usersPreferences setObject:@"ON" forKey:@"useNotificationCentreAlerts"];
    }

    NSString *storedFinanceAPI = [[NSUserDefaults standardUserDefaults] stringForKey:@"financeAPI"];

    if([storedFinanceAPI isEqual:nil])
    {
        [usersPreferences setObject:@"google" forKey:@"financeAPI"];
    }

}





- (void) awakeFromNib {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    self.statusBar.title = @"Share Price Ticker";
    
    NSString *storedRefreshRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshRate"];
    
    double refreshRateValue = [storedRefreshRate doubleValue];
    
    
    _refreshRateTimer = [NSTimer scheduledTimerWithTimeInterval:refreshRateValue
                                                         target:self
                                                       selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:)
                                                       userInfo:nil
                                                        repeats:YES];
    
    toDoList = [NSMutableArray arrayWithObject:@"Add a ToDo with the '+' button"];

    
}


- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
    return [toDoList objectAtIndex:row];
}

- (int)numberOfRowsInTableView:(NSTableView *)tv
{
    return [toDoList count];
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
    
    // Log a time stamp
    
    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
    NSString *timestamp = [NSString stringWithFormat:@"%02d:%02d:%02.0f", currentDate.hour, currentDate.minute, currentDate.second];

    NSLog(@"Current Time: %@", timestamp);
    
}


- (IBAction) showPrefs:(NSWindow *)sender {
    
    NSLog(@" %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"showPercentage"]);
    
    NSString *storedRefreshRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshRate"];
    
    if([storedRefreshRate isEqualToString:@"15"])
    {
        [_refreshRate selectItemWithTitle:@"15 Seconds"];
    }
    else if([storedRefreshRate isEqualToString:@"30"])
    {
        [_refreshRate selectItemWithTitle:@"30 Seconds"];
    }
    else if([storedRefreshRate isEqualToString:@"45"])
    {
        [_refreshRate selectItemWithTitle:@"45 Seconds"];
    }
    else if([storedRefreshRate isEqualToString:@"60"])
    {
        [_refreshRate selectItemWithTitle:@"1 Minute"];
    }
    else if([storedRefreshRate isEqualToString:@"120"])
    {
        [_refreshRate selectItemWithTitle:@"2 Minutes"];
    }
    else if([storedRefreshRate isEqualToString:@"300"])
    {
        [_refreshRate selectItemWithTitle:@"5 Minutes"];
    }
    else if([storedRefreshRate isEqualToString:@"600"])
    {
        [_refreshRate selectItemWithTitle:@"10 Minutes"];
    }
    else if([storedRefreshRate isEqualToString:@"900"])
    {
        [_refreshRate selectItemWithTitle:@"15 Minutes"];
    }
    
    NSString *storedFinanceAPI = [[NSUserDefaults standardUserDefaults] stringForKey:@"financeAPI"];
    
    if([storedFinanceAPI isEqualToString:@"google"])
    {
        [_apiChoice selectItemWithTitle:@"Google Finance"];
    }
    else if([storedFinanceAPI isEqualToString:@"yahoo"])
    {
        [_apiChoice selectItemWithTitle:@"Yahoo! Finance"];
    }
    
    
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

- (IBAction)changePercentageVal:(id)sender {
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];

    if(_showPercentage.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"showPercentage"];
    }
    else if(_showPercentage.state == NSOffState)
    {
        [usersPreferences setObject:@"OFF" forKey:@"showPercentage"];
    }

}

- (IBAction)changeRunSharePriceOnStartup:(id)sender {
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    if(_runSharePriceTickerOnStartup.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"runSharePriceTickerOnStartup"];
    }
    else if(_runSharePriceTickerOnStartup.state == NSOffState)
    {
        [usersPreferences setObject:@"OFF" forKey:@"runSharePriceTickerOnStartup"];
    }
    
}

- (IBAction)changeUseNotificationCentreForAlerts:(id)sender {
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    if(_useNotificationCentreAlerts.state == NSOnState)
    {
        [usersPreferences setObject:@"ON" forKey:@"useNotificationCentreAlerts"];
    }
    else if(_useNotificationCentreAlerts.state == NSOffState)
    {
        [usersPreferences setObject:@"OFF" forKey:@"useNotificationCentreAlerts"];
    }
    
}

- (IBAction)changeRefreshRate:(NSPopUpButton *)sender {
    
    NSLog(@"%@", sender.titleOfSelectedItem);
    
    NSString *storedRefreshRate = [[NSUserDefaults standardUserDefaults] stringForKey:@"refreshRate"];
    
    NSNumber *currentRefreshRate = [NSNumber numberWithDouble:[storedRefreshRate doubleValue]];
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    NSNumber *newSecondVal;
    
    if([sender.titleOfSelectedItem isEqualToString:@"15 Seconds"])
    {
        [usersPreferences setObject:@"15" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:15];
        NSLog(@"15 Skecs");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"30 Seconds"])
    {
        [usersPreferences setObject:@"30" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:30];
        NSLog(@"30 Skecs");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"45 Seconds"])
    {
        [usersPreferences setObject:@"45" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:45];
        NSLog(@"45 Skecs");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"1 Minute"])
    {
        [usersPreferences setObject:@"60" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:60];
        NSLog(@"60 Skecs");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"2 Minutes"])
    {
        [usersPreferences setObject:@"120" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:120];
        NSLog(@"2 Mins");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"5 Minutes"])
    {
        [usersPreferences setObject:@"300" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:300];
        NSLog(@"5 Mins");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"10 Minutes"])
    {
        [usersPreferences setObject:@"600" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:600];
        NSLog(@"10 Mins");
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"15 Minutes"])
    {
        [usersPreferences setObject:@"900" forKey:@"refreshRate"];
        newSecondVal = [NSNumber numberWithDouble:900];
        NSLog(@"15 Mins");
    }
    
    
    if([newSecondVal isNotEqualTo:currentRefreshRate])
    {
        [_refreshRateTimer invalidate];
        double newrate = [newSecondVal doubleValue];
        _refreshRateTimer = [NSTimer scheduledTimerWithTimeInterval:newrate
                                                             target:self
                                                           selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:)
                                                           userInfo:nil
                                                            repeats:YES];
    }

    
    
}

- (IBAction)changeFinanceAPI:(NSPopUpButton *)sender {
    
    NSUserDefaults *usersPreferences = [NSUserDefaults standardUserDefaults];
    
    if([sender.titleOfSelectedItem isEqualToString:@"Google Finance"])
    {
        [usersPreferences setObject:@"google" forKey:@"financeAPI"];
    }
    else if([sender.titleOfSelectedItem isEqualToString:@"Yahoo! Finance"])
    {
        [usersPreferences setObject:@"yahoo" forKey:@"financeAPI"];
    }
    
}

- (IBAction)stopTheTimer:(NSButton *)sender {
    
    [toDoList addObject:@"Bozo!"];
    [_shareSymTable reloadData];
    
}

- (IBAction)removeSymbol:(id)sender
{
    [toDoList removeObjectAtIndex:[_shareSymTable selectedRow]];
    [_shareSymTable reloadData];
}





@end
