//
//  OnOffButton.h
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface OnOffButton : CCNode

- (BOOL)isOn;
- (void)turnOn;
- (void)turnOff;

@end
