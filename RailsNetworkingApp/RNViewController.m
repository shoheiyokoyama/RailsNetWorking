//
//  RNViewController.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/07.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RNViewController.h"
#import <AFNetworking.h>

#define LISTURL @"http://localhost:3000/tops.json"
@interface RNViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITextField* postText;
@property (nonatomic) UIButton *postButton;
@property (nonatomic) UIButton *getButton;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *lists;
@end

@implementation RNViewController
@synthesize postText;
@synthesize postButton;
@synthesize getButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        postText = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 50.0f, 0.0f, 25)];
        postText.placeholder = @"入力";
        postText.textAlignment = NSTextAlignmentLeft;
        postText.borderStyle = UITextBorderStyleRoundedRect;
        postText.font = [UIFont fontWithName:@"Helvetica" size:14];
        postText.keyboardType = UIKeyboardAppearanceDefault;
        postText.clearButtonMode = UITextFieldViewModeWhileEditing;
        postText.delegate = self;
        [postText becomeFirstResponder];
        [self.view addSubview:postText];
        
        postButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50, 25)];
        [postButton setTitle:@"post" forState:UIControlStateNormal];
        postButton.userInteractionEnabled = YES;
        postButton.backgroundColor = [UIColor colorWithRed:0.125 green:0.698 blue:0.667 alpha:1.0];
        postButton.layer.cornerRadius = 3.0f;
        [postButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPostButton:)];
        [postButton addGestureRecognizer:tapGesture];
        [self.view addSubview:postButton];
        
        getButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50, 25)];
        [getButton setTitle:@"get" forState:UIControlStateNormal];
        getButton.userInteractionEnabled = YES;
        getButton.backgroundColor = [UIColor colorWithRed:0.98 green:0.502 blue:0.447 alpha:1.0];
        getButton.layer.cornerRadius = 3.0f;
        [getButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *Gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGetButton:)];
        [getButton addGestureRecognizer:Gesture];
        [self.view addSubview:getButton];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellStyleValue1;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
     [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = [UIScreen mainScreen].bounds;
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y = CGRectGetMaxY(postText.frame) + 30.0f;
    _tableView.frame = tableFrame;
    
    CGRect textFrame = postText.frame;
    textFrame.size.width = self.view.bounds.size.width - CGRectGetWidth(postButton.frame) - CGRectGetWidth(getButton.frame) - 20.0f;
    postText.frame = textFrame;
    
    CGRect Frame = postButton.frame;
    Frame.origin.x = CGRectGetMaxX(postText.frame) + 5.0f;
    Frame.origin.y = CGRectGetMinY(postText.frame);
    postButton.frame = Frame;
    
    CGRect gBnF = getButton.frame;
    gBnF.origin.x = CGRectGetMaxX(postButton.frame) + 5.0f;
    gBnF.origin.y = CGRectGetMinY(postText.frame);
    getButton.frame = gBnF;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_lists.count == 0) {
        return 0;
    }
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSLog(@" tableView : %@", _lists);
    cell.textLabel.text = [_lists objectAtIndex:indexPath.row];
    return cell;
}

# pragma mark - tap Action
- (void)tapPostButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"Button tapped.");
    NSLog(@"%@", postText.text);

    NSDictionary *params = [NSDictionary dictionaryWithObject:postText.text forKey:@"top[name]"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:LISTURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              NSLog(@"success: %@", responseObject);
              postText.text = @"";
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
             
             _lists = [NSMutableArray array];
             for (NSDictionary *jsonObject in responseObject) {
                 
                 [_lists addObject:[jsonObject objectForKey:@"name"]];
             }
             [_tableView reloadData];
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

@end
