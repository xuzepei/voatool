//
//  ViewController.h
//  VOA Tool
//
//  Created by xuzepei on 2017/7/27.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic,strong) NSArray* categories;
@property (assign, nonatomic) int index;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;

- (IBAction)clickedButton:(id)sender;
- (IBAction)clickedVideoButton:(id)sender;

@end

