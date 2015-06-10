//
//  RNViewController.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/07.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RNViewController.h"
#import "RailsListManager.h"

@interface RNViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITextField* textField;
@property (nonatomic) UIButton *postButton;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *lists;
@property (nonatomic, weak, readonly) RailsListManager *manager;
@end

@implementation RNViewController
@synthesize textField;
@synthesize postButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 50.0f, 0.0f, 25)];
        textField.placeholder = @"入力";
        textField.textAlignment = NSTextAlignmentLeft;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont fontWithName:@"Helvetica" size:14];
        textField.keyboardType = UIKeyboardAppearanceDefault;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
        [textField becomeFirstResponder];
        [self.view addSubview:textField];
        
        postButton = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 50, 25)];
        [postButton setTitle:@"post" forState:UIControlStateNormal];
        postButton.userInteractionEnabled = YES;
        postButton.backgroundColor = [UIColor colorWithRed:0.125 green:0.698 blue:0.667 alpha:1.0];
        postButton.layer.cornerRadius = 3.0f;
        [postButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPostButton:)];
        [postButton addGestureRecognizer:tapGesture];
        [self.view addSubview:postButton];
    }
    return self;
}

- (RailsListManager *)manager
{
    return [RailsListManager sharedManager];
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
    [self getListsData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = [UIScreen mainScreen].bounds;
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y = CGRectGetMaxY(textField.frame) + 30.0f;
    _tableView.frame = tableFrame;
    
    CGRect textFrame = textField.frame;
    textFrame.size.width = self.view.bounds.size.width - CGRectGetWidth(postButton.frame) - 20.0f;
    textField.frame = textFrame;
    
    CGRect Frame = postButton.frame;
    Frame.origin.x = CGRectGetMaxX(textField.frame) + 5.0f;
    Frame.origin.y = CGRectGetMinY(textField.frame);
    postButton.frame = Frame;
    
}

- (void)getListsData
{
    [self.manager getJsonData:^(NSMutableArray *posts, NSError *error)
     {
         if (error) {
             [self showAlert:@"読み込みに失敗しました"];
         }
         _lists = posts;
         [_tableView reloadData];
    }];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@" tableView : %@", _lists);
    cell.textLabel.text = [_lists objectAtIndex:indexPath.row];
    return cell;
}

- (void)showAlert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

# pragma mark - tap Action
- (void)tapPostButton:(UITapGestureRecognizer *)sender
{
    NSLog(@"Button tapped.");
    NSLog(@"%@", textField.text);
    
    if ([textField.text isEqualToString:@""]) {
        [self showAlert:@"文字を入力してください"];
    } else {
        [self.manager postJsonData:textField.text completionHandler:^(NSError *error)
         {
             if (error) {
                 [self showAlert:@"投稿できませんでした"];
             } else {
                 textField.text = @"";
                 [self showAlert:@"投稿を完了しました"];
                 [self getListsData];
             }
         }];
    }
}


# pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
