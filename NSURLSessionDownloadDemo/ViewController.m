//
//  ViewController.m
//  NSURLSessionDownloadDemo
//
//  Created by Apple on 8/13/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self downloadFile];
}

-(void)downloadFile{
    
    //1.创建url
    NSString *urlStr=@"https://github.com/cnbin/insertDemo/archive/master.zip";

    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    //2.创建请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    //3.创建会话（这里使用了一个全局会话）并且启动任务
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error) {
            //注意location是下载后的临时保存路径,需要将它移动到需要保存的位置
            
            NSError *saveError;
            NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *savePath=[cachePath stringByAppendingPathComponent:@"master.zip"];
            NSLog(@"%@",savePath);
            NSURL *saveUrl=[NSURL fileURLWithPath:savePath];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            if (!saveError) {
                NSLog(@"save sucess.");
            }else{
                NSLog(@"error is :%@",saveError.localizedDescription);
            }
            
        }else{
            NSLog(@"error is :%@",error.localizedDescription);
        }
    }];
    
    [downloadTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
