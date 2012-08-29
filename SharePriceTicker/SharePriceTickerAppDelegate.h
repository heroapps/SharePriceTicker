//
//  SharePriceTickerAppDelegate.h
//  SharePriceTicker
//
//  Created by Dan on 19/08/2012.
//  Copyright (c) 2012 HERO Apps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SharePriceTickerAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *statusMenu;

@property (weak) IBOutlet NSMenuItem *statusMenuImage;

- (IBAction) showPrefs:(NSWindow *)sender;
- (IBAction) closePreferencesWindow:(id)sender;
- (IBAction) saveUserPreferences:(id)sender;

@property (weak) IBOutlet NSPopUpButton *apiChoice;
@property (weak) IBOutlet NSPopUpButton *refreshRate;

@property (weak) IBOutlet NSButton *showPercentage;
@property (weak) IBOutlet NSButton *runSharePriceTickerOnStartup;
@property (weak) IBOutlet NSButton *useNotificationCentreAlerts;

@property (weak) IBOutlet NSWindow *createPanel;


@property (strong, nonatomic) NSStatusItem *statusBar;

@end
