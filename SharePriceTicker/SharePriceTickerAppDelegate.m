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
@synthesize statusBar = _statusBar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    self.statusBar.title = @"Share Prices";
    
    // you can also set an image
    //self.statusBar.image =
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
    //NSError *error = nil;
    
    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSString *stringWithoutSpaces = [json_string stringByReplacingOccurrencesOfString:@"//" withString:@""];
    //stringWithoutSpaces = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@"[" withString:@""];
    //stringWithoutSpaces = [stringWithoutSpaces stringByReplacingOccurrencesOfString:@"]" withString:@""];
   
    //NSDictionary *myDict = [parser objectWithString:stringWithoutSpaces];
    
    NSArray *statuses = [parser objectWithString:json_string error:nil];
    
    
    NSLog(@"statuses:%@", statuses);
    
    parser = nil;
    
}

- (void) thisMethodGetsFiredOnceEveryThirtySeconds:(id)sender {
    
    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
    self.statusBar.title = [NSString stringWithFormat:@"%02d:%02d:%02.0f", currentDate.hour, currentDate.minute, currentDate.second];
    
}


@end
