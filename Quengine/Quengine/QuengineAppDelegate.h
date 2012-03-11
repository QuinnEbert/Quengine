//
//  QuengineAppDelegate.h
//  Quengine: experiments in learning OpenGL through brute force
//
//  IMPORTANT CODE LICENSING INFORMATION:
//  
//  This code is provided to the general public ONLY for the
//  purpose of educational use.  All other use is strictly
//  forbidden without prior written permission from the author.
//  This includes any use in which you copy and paste from this
//  program code, copy and paste the entire code into your own
//  program, or re-use files from this program.  Any of the above
//  listed uses of the code are indeed forbidden without prior
//  written permission from the author.  Such written permission
//  may also require payment of a licensing fee to be negotiated
//  after you have requested but before you are granted permission
//  and the assessment (or lack thereof) of any such fee shall be
//  the sole decision of the author on his own merits and for his
//  own arbitrary and nondisclosed reasons.
//
//  Created by David Ebert on 3/10/12.
//  Copyright (c) 2012 Beyond IT, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QuengineAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *myEngineView;

@end
