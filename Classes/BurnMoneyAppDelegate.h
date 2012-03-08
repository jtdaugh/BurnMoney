//
//  BurnMoneyAppDelegate.h
//  BurnMoney
//
//  Created by Jesse Daugherty on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BurnMoneyViewController;

@interface BurnMoneyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BurnMoneyViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BurnMoneyViewController *viewController;

@end

