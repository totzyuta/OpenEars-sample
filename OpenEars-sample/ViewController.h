//
//  ViewController.h
//  OpenEars-sample
//
//  Created by yutatotz on 6/18/15.
//  Copyright (c) 2015 yutatotz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/OEEventsObserver.h>


@interface ViewController : UIViewController <OEEventsObserverDelegate>

@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@end

