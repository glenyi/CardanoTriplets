//
//  ViewController.m
//  Cardano ObjC
//
//  Created by Glen Yi on 2014-08-21.
//  Copyright (c) 2014 On The Pursuit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goClick:(UIButton *)sender {
    NSInteger limit = self.limitTextField.text.integerValue;
    if (limit>=3) {
        NSDate *timestamp = [NSDate date];
        
        self.timeLabel.text = @"Calculating...";
        self.limitTextField.enabled = self.goButton.enabled = NO;
        
        [self calculateTripletsWithLimit:limit completion:^(NSInteger count) {
            self.tripletsLabel.text = [NSString stringWithFormat:@"%li", count];
            NSInteger seconds = -[timestamp timeIntervalSinceNow];
            self.timeLabel.text = [NSString stringWithFormat:@"%li", seconds];
            
            self.limitTextField.enabled = self.goButton.enabled = YES;
            NSLog(@"Found %li triplets in %li seconds!", (long)count, (long)seconds);
        }];
    }
}

- (BOOL)isCardanoTriplet:(NSInteger)a b:(NSInteger)b c:(NSInteger)c {
    double bc = b * sqrt(c);
    double cardano = cbrt(a + bc) + cbrt(a - bc);
    
    // Float errors... if there's a better way then please let me know
    return (cardano < 1.00000000000001 && cardano > 0.99999999999999);
}

- (void)calculateTripletsWithLimit:(NSInteger)limit completion:(void(^)(NSInteger count))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSInteger count = 0;
        
        for (int a=1; a<limit-2; a++) {
            for (int b=1; b<limit-a-1; b++) {
                for (int c=1; c<limit-a-b; c++) {
                    if ([self isCardanoTriplet:a b:b c:c]) {
                        count++;
                        NSLog(@"%li: (%i, %i, %i)", (long)count, a, b, c);
                    }
                }
            }
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            completion(count);
        });
    });
}

@end
