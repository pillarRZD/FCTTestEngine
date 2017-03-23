//
//  AppDelegate.m
//  FCT(B282)
//
//  Created by Jack.MT on 16/7/18.
//  Copyright © 2016年 Jack.MT. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "MainWindow.h"
#import <ExceptionHandling/ExceptionHandling.h>
@import JKFramework;

#import "CBAuth_API.h"
#import "get_hash.h"

#import "TestItem.h"

#import <math.h>
#import <Accelerate/Accelerate.h>

#define SuppressPerformSelectorLeakWarning(retValue, Method) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
retValue = Method; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface AppDelegate ()
{
    IBOutlet MainWindow         *mainWinDelegate;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self test];

    [[AppConfig config] logAppExceptionWithMask:EXCEPTION_LOG_MASK];    //启动异常监控（记录）
    
    NSString* marketVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString* buildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *swVersioin = [NSString stringWithFormat:@"%@.%@", marketVersion, buildVersion];
    self.window.title = [NSString stringWithFormat:@"ver(%@)", swVersioin];
    
    [[[NSThread alloc] initWithTarget:self selector:@selector(initSystem) object:nil] start];
//    [self.window setAcceptsMouseMovedEvents:YES];
    [mainWinDelegate appDidLaunching];
    
    [self runCheckTask];
}


- (void)test
{
}


- (NSString *)check:(NSDictionary *)paramDic
{
    return [paramDic description];
}

- (void)runCheckTask
{
    NSTask *_checkTask = [[NSTask alloc] init];
    _checkTask.launchPath = @"/bin/sh";
    _checkTask.arguments = @[[NSString stringWithFormat:@"ping -c1 -t1 %@ | grep '1 packets received' > /dev/null", @"169.254.10.11"]];
    NSPipe *oPipe = [NSPipe pipe];
    _checkTask.standardOutput = oPipe.fileHandleForReading;
    _checkTask.standardError = oPipe.fileHandleForReading;
    _checkTask.standardInput = [NSPipe pipe].fileHandleForWriting;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:_checkTask];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataReady:) name:NSFileHandleDataAvailableNotification object:_checkTask.standardOutput];
    [_checkTask.standardOutput waitForDataInBackgroundAndNotify];
    
    [_checkTask launch];
}

- (void)dataReady:(NSNotification *)notification
{
    
}

- (void)taskTerminated:(NSNotification *)notification
{
    NSTask *task = (NSTask *)notification.object;
    NSFileHandle *readHandle = (NSFileHandle *)task.standardOutput;
    NSString *info = [[NSString alloc] initWithData:readHandle.availableData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", info);
    
    [NSThread sleepForTimeInterval:1];
    
    //    [self runCheckTask];
}

//- (void)applicationWillTerminate:(NSNotification *)aNotification {
//    // Insert code here to tear down your application
//    [[JKDeviceManager sharedManager] close];
//    [[AppConfig config] killAllProcessInBackgourd];     //kill all background process created by current application
//    [self.window close];
//    NSLog(@"Exit");
//}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    __block NSApplicationTerminateReply reply = NSTerminateCancel;
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = [NSString stringWithFormat:@"\tQuit %@ ?!", [AppConfig config].appName];
    alert.informativeText = @"";
    [alert addButtonWithTitle:@"Quit"];
    [alert addButtonWithTitle:@"Cancel"];
    
    if([alert runModal] == NSAlertFirstButtonReturn)
    {
        [[JKDeviceManager sharedManager] close];
        [[AppConfig config] killAllProcessInBackgourd];     //kill all background process created by current application
        [self.window close];
        reply = NSTerminateNow;
    }
    
    return reply;
}

-(void)initSystem
{
    JKDeviceManager *dm = [JKDeviceManager sharedManager];
    [dm addObserver:mainWinDelegate forKeyPath:@"logMessage" options:NSKeyValueObservingOptionNew context:nil];
    [dm initAllDevices];
//    [dev close];
    
    [[[NSThread alloc] initWithTarget:mainWinDelegate selector:@selector(checkSystemState) object:nil] start];
}

- (IBAction)goRootDataDirectory:(id)sender
{
//    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
//    openPanel.parentWindow = self.window;
//    openPanel.directoryURL = [NSURL URLWithString:[AppConfig config].rootDataDirectory];
//    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
//        [openPanel endSheet:self.window];
//    }];
    
    [[NSWorkspace sharedWorkspace] openFile:[AppConfig config].rootDataDirectory];
}

@end
