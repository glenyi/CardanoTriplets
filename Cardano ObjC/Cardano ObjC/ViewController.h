//
//  ViewController.h
//  Cardano ObjC
//
//  Created by Glen Yi on 2014-08-21.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *limitTextField;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UILabel *tripletsLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)goClick:(UIButton *)sender;

@end

