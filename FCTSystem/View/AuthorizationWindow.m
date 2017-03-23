//
//  AuthorizationWindow.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/8/10.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "AuthorizationWindow.h"

#define KEY_PASSWORD            @"ConfigPassword"

#define AUTHORIZATION_DEFAULT       @"mtadmin"
#define AUTHORIZATION_RST           @"mtswdeveloper"

@interface AuthorizationWindow ()

@end

@implementation AuthorizationWindow
{
    IBOutlet NSButton            *_btAction;
    IBOutlet NSButton            *_btSwitch;
    
    IBOutlet NSTextField         *_tfPassword;
    IBOutlet NSTextField         *_tfPrompt;
    
    IBOutlet NSView              *_modifyArea;
    IBOutlet NSTextField         *_tfNewPasswd;
    IBOutlet NSTextField         *_tfNewPasswdConfirm;
}

- (instancetype)init
{
    self = [super init];
    
    if(self)
    {
        [[NSBundle mainBundle] loadNibNamed:self.className owner:self topLevelObjects:nil];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(IBAction)doAction:(id)sender
{
    NSButton *btn = (NSButton *)sender;
    NSString *passwd = [[NSUserDefaults standardUserDefaults] valueForKeyPath:KEY_PASSWORD];
    passwd = passwd ? passwd : AUTHORIZATION_DEFAULT;
    if([btn.title isEqualTo:@"Login"])
    {
        NSString *inputPasswd = _tfPassword.stringValue;
        if([inputPasswd isEqualTo:AUTHORIZATION_RST])
        {
            [[NSUserDefaults standardUserDefaults] setValue:AUTHORIZATION_DEFAULT forKeyPath:KEY_PASSWORD];
            passwd = inputPasswd;
        }
        if([inputPasswd isEqualTo:passwd])
        {
            [self closeWithRetureCode:NSModalResponseOK];
        }
        else
        {
            _tfPrompt.stringValue = @"Incorrent Password";
            [_tfPassword selectText:self];
        }
    }
    else
    {
        NSString *inputPasswd = _tfPassword.stringValue;
        if([inputPasswd isNotEqualTo:passwd])
        {
            [_tfPassword selectText:self];
            _tfPrompt.stringValue = @"The old password is incorrent";
        }
        else
        {
            NSString *newPwd = _tfNewPasswd.stringValue;
            NSString *newPwdConfirm = _tfNewPasswdConfirm.stringValue;
            if([newPwd isEqualTo:@""])
            {
                _tfPrompt.stringValue = @"The new password is empty";
                [_tfNewPasswd selectText:self];
            }
            else
            {
                if([newPwd isNotEqualTo:newPwdConfirm])
                {
                    [_tfNewPasswd selectText:self];
                    _tfPrompt.stringValue = @"The new passwords is different";
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setValue:newPwd forKeyPath:KEY_PASSWORD];
                    _btSwitch.state = 0;
                    [self switchPurpose:_btSwitch];
                }
            }
        }
    }
}

- (IBAction)switchPurpose:(id)sender
{
    NSButton *btn = (NSButton *)sender;
    if(btn.state)
    {
        NSRect winFrame = _modifyArea.window.frame;
        NSRect newFrame = NSMakeRect(NSMinX(winFrame), NSMinY(winFrame)-67, NSWidth(winFrame), NSHeight(winFrame)+67);
        [_modifyArea.window setFrame:newFrame display:YES];
        _btAction.title = @"Modify";
    }
    else
    {
        if(NSHeight(_modifyArea.frame) > 0)
        {
            NSRect winFrame = _modifyArea.window.frame;
            NSRect newFrame = NSMakeRect(NSMinX(winFrame), NSMinY(winFrame)+67, NSWidth(winFrame), NSHeight(winFrame)-67);
            [_modifyArea.window setFrame:newFrame display:YES];
            _btAction.title = @"Login";
        }
    }
    
    _tfPrompt.stringValue = @"";
}

-(IBAction)cancel:(id)sender
{
    [self closeWithRetureCode:NSModalResponseCancel];
}

-(void)closeWithRetureCode:(NSModalResponse)returnCode
{
    _tfPassword.stringValue = @"";
    if(self.window.sheetParent)
    {
        [self.window.sheetParent endSheet:self.window returnCode:returnCode];
    }
    _btSwitch.state = 0;
    [self switchPurpose:_btSwitch];
    [self.window close];
}

-(void)windowDidBecomeKey:(NSNotification *)notification
{
    _tfPassword.stringValue = @"";
    _tfPrompt.stringValue = @"";
}

@end
