//
//  ViewController.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/07.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

#define LISTURL @"http://localhost:3000/tops.json"
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic) UITextField* tf;
@property (nonatomic) UIButton *bn;
@property (nonatomic) UIButton *gBn;
@end

@implementation ViewController
@synthesize tf;
@synthesize bn;
@synthesize gBn;
- (instancetype)init
{
    self = [super init];
    if (self) {
        tf = [[UITextField alloc]initWithFrame:CGRectMake(70, 50, 120, 25)];
        tf.placeholder = @"入力";
        tf.textAlignment = NSTextAlignmentLeft;
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.font = [UIFont fontWithName:@"Helvetica" size:14];
        tf.keyboardType = UIKeyboardAppearanceDefault;
        tf.clearButtonMode = UITextFieldViewModeWhileEditing;
        tf.delegate = self;
        [tf becomeFirstResponder];
        [tf addTarget:self action:@selector(postData:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.view addSubview:tf];
        
        bn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50, 25)];
        [bn setTitle:@"post" forState:UIControlStateNormal];
        bn.userInteractionEnabled = YES;
        bn.backgroundColor = [UIColor blueColor];
        [bn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButton:)];
        [bn addGestureRecognizer:tapGesture];
        [self.view addSubview:bn];
        
        CGRect Frame = bn.frame;
        Frame.origin.x = CGRectGetMaxX(tf.frame) + 5.0f;
        Frame.origin.y = CGRectGetMinY(tf.frame);
        bn.frame = Frame;
        
        gBn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50, 25)];
        [gBn setTitle:@"get" forState:UIControlStateNormal];
        gBn.userInteractionEnabled = YES;
        gBn.backgroundColor = [UIColor redColor];
        [gBn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetButton:)];
        [gBn addGestureRecognizer:Gesture];
        [self.view addSubview:gBn];
        
        CGRect gBnF = gBn.frame;
        gBnF.origin.x = CGRectGetMidX(tf.frame);
        gBnF.origin.y = CGRectGetMaxY(tf.frame) + 30;
        gBn.frame = gBnF;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}


# pragma mark - tap Action
- (void)tapButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"Button tapped.");
    NSLog(@"%@", tf.text);
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:tf.text forKey:@"top[name]"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:LISTURL parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject){

              NSLog(@"success: %@", responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              
              NSLog(@"error: %@", error);
          }];
    
}

- (void)tapGetButton:(UITapGestureRecognizer *)sender
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:LISTURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             NSLog(@"success: %@", responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
             NSLog(@"error: %@", error);
         }];
}

# pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)postData:(UITextField*)textfield{
    NSLog(@"%@", tf.text);
}

@end
