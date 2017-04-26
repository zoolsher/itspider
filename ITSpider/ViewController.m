//
//  ViewController.m
//  ITSpider
//
//  Created by zoolsher on 2017/4/26.
//  Copyright © 2017年 zoolsher. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "NSTransView.h"

@implementation ViewController

-(void)addTransBackgroud{
    NSTransView* tView = [[NSTransView alloc]init];
    tView.frame = self.view.frame;
    [self.view addSubview:tView positioned:-1 relativeTo:self.view];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:tView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self waitFetchUI];
//    [self addTransBackgroud];
    // Do any additional setup after loading the view.
}

- (IBAction)downloadIt:(NSButton *)sender {
    [self runRequest];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

-(void)waitFetchUI{
    self.label.title = @"click start!";
    [self.indicator setHidden:true];
}

-(void)startFetchUI{
    self.label.title = @"now fetching...";
    [self.indicator startAnimation:nil];
    [self.indicator setHidden:false];
}

-(void)endFetchUI:(NSString*)info{
    self.label.title = info;
    [self.indicator stopAnimation:nil];
    [self.indicator setHidden:true];
}

-(void)runRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"https://www.itjuzi.com/horse" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self endFetchUI:@"success"];
        NSMutableString* csvStr = [self parserJSONtoCSV:responseObject];
        [self saveStrToFile:csvStr];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self endFetchUI:@"failed"];
    }];
    [self startFetchUI];
}

-(NSMutableString*)parserJSONtoCSV:(id)responseObject{
    NSMutableString* str = [[NSMutableString alloc]init];
    if([responseObject isKindOfClass:[NSArray class]]){
        NSArray<NSDictionary*>* arr = (NSArray<NSDictionary*>*) responseObject;
        if(arr.count>=1){
            NSDictionary* arr0 = [arr objectAtIndex:0];
            NSArray<NSString*>* keys = [arr0 allKeys];
            for(int i = 0;i<keys.count;i++){
                [str appendString:keys[i]];
                if(i<keys.count-1){
                    [str appendString:@","];
                }
            }
            [str appendString:@"\r\n"];
            NSDictionary* t = nil;
            for(int j = 0;j<arr.count;j++){
                t=arr[j];
                for(int k=0;k<keys.count;k++){
                    if([t objectForKey:keys[k]]==nil){
                        [str appendString:@""];
                    }else{
                        NSString *s = @"";
                        @try {
                            id tmpNullable = [t objectForKey:keys[k]];
                            if([tmpNullable isKindOfClass:[NSNull class]]){
                                [str appendString:@""];
                            }else{
                                s = (NSString*)tmpNullable;
                                [str appendString:s];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@ key: %@",t,keys[k]);
                        } @finally {
                        }
                        
                    }
                    if(k<keys.count-1){
                        [str appendString:@","];
                    }
                }
                [str appendString:@"\r\n"];
            }
        }else{
        
        }
    }
    return str;
}

-(void) saveStrToFile:(NSString*)str{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.csv",
                          documentsDirectory];
    //create content - four lines of text
    NSString *content = str;
    //save content to the documents directory
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:nil];
    
//    NSDictionary *arr = [NSDictionary dictionaryWithObjectsAndKeys:
//                         @"1", @"Field1", @"string2", @"Field2", nil];
//    NSData *data = [NSPropertyListSerialization dataFromPropertyList:arr
//                                                              format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[@"csv"];
    panel.allowsOtherFileTypes = false;
    
    NSInteger ret = [panel runModal];
    if (ret == NSFileHandlingPanelOKButton) {
        [content writeToURL:[panel URL] atomically:YES];
//        [data writeToURL:[panel URL] atomically:YES];
    }
    [self waitFetchUI];
    
}

@end
