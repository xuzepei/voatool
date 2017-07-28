//
//  ViewController.m
//  VOA Tool
//
//  Created by xuzepei on 2017/7/27.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "ViewController.h"
#import "RCHttpRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.index = -1;
    
    self.categories = @[@"As It Is",@"America's National Parks",@"American Mosaic",@"American Stories",@"In the News",@"Business",@"Education",@"Everyday Grammar",@"Health Report",@"Science in the News",@"Personal Technology",@"People in America",@"The Making of a Nation",@"This is America",@"The Year in Review",@"Words and Their Stories",@"What's Trending?",@"VOA Newscast",@"Economics Report",@"Education Report",@"Health Report",@"Lifestyles",@"Technology Report",@"News Words",@"English in a Minute",@"Talk2Us",@"English @ the Movies",@"English Grammar TV"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickedButton:(id)sender {
    
    self.index = -1;
    [self updateContent];
    
    self.startButton.enabled = NO;
    self.videoButton.enabled = NO;
}

- (NSString*)getNextCategory
{
    self.index++;
    //if(self.index >= [self.categories count])
        //self.index = 0;
    
    if(self.index < [self.categories count])
    {
        return [self.categories objectAtIndex: self.index];
    }
    
    return nil;
}

- (void)updateContent
{
    NSString* category = [self getNextCategory];
    if(0 == category.length)
    {
        self.startButton.enabled = YES;
        self.videoButton.enabled = YES;
        NSLog(@"$$$Finished!!!");
        return;
    }
    
    NSString* urlString = @"https://api.innoloop.net/voale/classes/Article";
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:@"-original_pubtime,-article_id" forKey:@"order"];
    [dict setObject:@"article_id,audio,audio_hq,cf_url,cover,dropbox_url,duration,dynamic_link,hero,like_count,original_pubtime,subtitle,title,view_count" forKey:@"keys"];
    [dict setObject:@"GET" forKey:@"_method"];
    [dict setObject:@{@"status":@"published",@"programs":category} forKey:@"where"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedContentRequest:) bodyData:postData token:nil];
    if(b)
    {
        NSLog(@"$$$Step1: get data from voa server.");
        [self.indicator startAnimating];
    }
}

- (void)finishedContentRequest:(NSString*)jsonString
{
    [self.indicator stopAnimating];
    
    if([jsonString length])
    {
        NSString* category = [self.categories objectAtIndex: self.index];
        NSString* urlString = [NSString stringWithFormat:@"http://appdream.sinaapp.com/voa/update.php?category=%@",category];
        
        NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedContentRequest2:) bodyData:postData token:nil];
        if(b)
        {
            NSLog(@"$$$Step2: upload data to my server.");
            [self.indicator startAnimating];
        }
    }
}

- (void)finishedContentRequest2:(NSString*)jsonString
{
    [self.indicator stopAnimating];
    
    [self updateContent];
}

#pragma mark - Video

- (IBAction)clickedVideoButton:(id)sender {
    
    self.index = -1;
    [self updateVideoContent];
    
    self.startButton.enabled = NO;
    self.videoButton.enabled = NO;
}

- (void)updateVideoContent
{
    NSString* category = [self getNextCategory];
    if(0 == category.length)
    {
        self.startButton.enabled = YES;
        self.videoButton.enabled = YES;
        NSLog(@"$$$Finished videos!!!");
        return;
    }
    
    NSString* urlString = @"https://api.innoloop.net/voale/classes/Video";
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    [dict setObject:@"-original_pubtime,-article_id" forKey:@"order"];
    [dict setObject:@"cf_url,cover,dropbox_url,duration,hq_ok,like_count,link_url,mobile_ok,pubtime,subtitle,title,title_lowercase,video_id,video_url,view_count,yt_url" forKey:@"keys"];
    [dict setObject:@"GET" forKey:@"_method"];
    [dict setObject:@{@"status":@"published",@"programs":category} forKey:@"where"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    
    RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
    BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedVideoContentRequest:) bodyData:postData token:nil];
    if(b)
    {
        NSLog(@"$$$Step1: get data from voa server.");
        [self.indicator startAnimating];
    }
}

- (void)finishedVideoContentRequest:(NSString*)jsonString
{
    [self.indicator stopAnimating];
    
    if([jsonString length])
    {
        NSString* category = [self.categories objectAtIndex: self.index];
        NSString* urlString = [NSString stringWithFormat:@"http://appdream.sinaapp.com/voa/update.php?category=%@",category];
        
        NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        RCHttpRequest* temp = [[RCHttpRequest alloc] init] ;
        BOOL b = [temp post:urlString delegate:self resultSelector:@selector(finishedVideoContentRequest2:) bodyData:postData token:nil];
        if(b)
        {
            NSLog(@"$$$Step2: upload data to my server.");
            [self.indicator startAnimating];
        }
    }
}

- (void)finishedVideoContentRequest2:(NSString*)jsonString
{
    [self.indicator stopAnimating];
    
    [self updateVideoContent];
}





@end
