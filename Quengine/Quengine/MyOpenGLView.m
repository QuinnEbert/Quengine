//
//  MyOpenGLView.m
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

#import "MyOpenGLView.h"

#include <OpenGL/gl.h>

@implementation MyOpenGLView

@synthesize myTestCubeOffset;
@synthesize myTestCubeRotate;
@synthesize myTestCubeSkewer;
@synthesize myTestCubeBumper;

@synthesize viewerIsCrouching;
@synthesize viewerIsElevating;

-(void)keyUp:(NSEvent*)event
{
    if ([event keyCode]==COCOA_KEY_ENGLISH_LETTER_C)
    {
        viewerIsCrouching=NO;
        myTestCubeBumper =0.0f;
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_WORLDLY_SPACEBAR)
    {
        viewerIsElevating=NO;
        myTestCubeBumper =0.0f;
        [self runScene];
    }
}
-(void)keyDown:(NSEvent*)event
{
    if ([event keyCode]==COCOA_KEY_ARROW_U)
    {
        myTestCubeOffset += 0.1f;
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_ARROW_D)
    {
        myTestCubeOffset -= 0.1f;
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_ARROW_L)
    {
        myTestCubeRotate -= 3;
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_ARROW_R)
    {
        myTestCubeRotate += 3;
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_SYMBOL_BRACKET_L)
    {
        if (myTestCubeSkewer==0)
        {
            myTestCubeSkewer += LEAN_ANGLE;
        }
        else
        {
            myTestCubeSkewer  = 0;
        }
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_SYMBOL_BRACKET_R)
    {
        if (myTestCubeSkewer==0)
        {
            myTestCubeSkewer -= LEAN_ANGLE;
        }
        else
        {
            myTestCubeSkewer  = 0;
        }
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_ENGLISH_LETTER_C)
    {
        if (viewerIsElevating==NO)
        {
            viewerIsCrouching=YES;
            myTestCubeBumper =0.3f;
        }
        [self runScene];
    }
    else if ([event keyCode]==COCOA_KEY_WORLDLY_SPACEBAR)
    {
        if (viewerIsCrouching==NO)
        {
            viewerIsElevating=YES;
            myTestCubeBumper =-0.2f;
        }
        [self runScene];
    }
}
-(BOOL)acceptsFirstResponder
{
    return YES;
}
-(void) drawAnObject
{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSString *texFile = [[NSString alloc]initWithString:[appPath stringByAppendingString:@"/Contents/Resources/QuinnBox.png"]];
    TextureData td = [self loadPngTexture:texFile];
    static GLuint textureName;
    glEnable(GL_TEXTURE_2D);
    glGenTextures(1,&textureName);
    glBindTexture(GL_TEXTURE_2D, textureName);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, td.width, td.height, 0, GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, td.data);
    glColor3f(1.0,1.0,1.0);
    glBegin(GL_POLYGON);
    {
        glTexCoord2f(1, 1);
        glVertex3f(0.5,0.5,-1.0);
        glTexCoord2f(1, 0);
        glVertex3f(0.5,-0.5,-1.0);
        glTexCoord2f(0, 0);
        glVertex3f(-0.5,-0.5,-1.0);
        glTexCoord2f(0, 1);
        glVertex3f(-0.5,0.5,-1.0);
    }
    glEnd();
    glPushMatrix();
}
-(void) runScene
{
    glViewport(0,0,640,640);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45.0f, 640.0f / 640.0f, 1.0f, 500.0f);
    glMatrixMode(GL_MODELVIEW);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    glTranslatef(0.0f,myTestCubeBumper,myTestCubeOffset);
    glRotatef(myTestCubeRotate,0.0f,1.0f,0.0f);
    glRotatef(myTestCubeSkewer,0.0f,0.0f,1.0f);
    [self drawAnObject];
    glLoadIdentity();
    glFlush();
}
-(void) playWave:(NSString *)wav
{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:wav ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error: nil];
    [fileURL release];
    [newPlayer prepareToPlay];
    [newPlayer play];
}
-(void) drawRect:(NSRect) bounds
{
    // Play the welcome sound:
    [self playWave:@"sound"];
    // Default values for jump versus crouch conflict management:
    viewerIsCrouching = NO;
    viewerIsElevating = NO;
    // Default offsets for faking player viewpoint camera movement:
    myTestCubeOffset = -2.0f;
    myTestCubeRotate = 0;
    myTestCubeSkewer = 0;
    myTestCubeBumper = 0.0f;
    // Render the first frame through the OpenGL pipeline:
    [self runScene];
}
-(TextureData) loadPngTexture:(NSString *)fileName {
    CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:fileName];
    CGImageSourceRef myImageSourceRef = CGImageSourceCreateWithURL(url, NULL);
    CGImageRef myImageRef = CGImageSourceCreateImageAtIndex (myImageSourceRef, 0, NULL);
    GLuint width = (GLuint)CGImageGetWidth(myImageRef);
    GLuint height = (GLuint)CGImageGetHeight(myImageRef);
    void *data = malloc(width * height * 4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), myImageRef);
    CGImageRelease(myImageRef);
    CGContextRelease(context);
    return (TextureData){ data, width, height };
}
@end