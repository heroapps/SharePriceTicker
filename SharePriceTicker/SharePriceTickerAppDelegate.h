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

@property (strong, nonatomic) NSStatusItem *statusBar;

@end
