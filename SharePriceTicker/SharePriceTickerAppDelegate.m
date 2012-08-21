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
@synthesize statusBar = _statusBar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    self.statusBar.menu = self.statusMenu;
    self.statusBar.highlightMode = YES;
    
    NSTimer *timer;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(thisMethodGetsFiredOnceEveryThirtySeconds:) userInfo:nil repeats:YES];
    
    [timer fire];
    
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


@end
