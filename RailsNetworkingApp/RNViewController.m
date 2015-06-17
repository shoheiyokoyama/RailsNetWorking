//
//  RNViewController.m
//  RailsNetworkingApp
//
//  Created by 横山祥平 on 2015/06/07.
//  Copyright (c) 2015年 shohei. All rights reserved.
//

#import "RNViewController.h"
#import "RailsListManager.h"
#import "RailsListCachesManager.h"
#import "RLTableViewCell.h"
#import "RLPostItems.h"

@interface RNViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITextField* textField;
@property (nonatomic) UIButton *postButton;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *lists;
@property (nonatomic) RLPostItems *post;
@property (nonatomic, weak, readonly) RailsListManager *manager;
@end

@implementation RNViewController
@synthesize textField;
@synthesize postButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        textField = [[UITextField alloc]initWithFrame:CGRectMake(5.0f, 100.0f, 0.0f, 25)];
        textField.placeholder = @"入力";
        textField.textAlignment = NSTextAlignmentLeft;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.font = [UIFont fontWithName:@"Helvetica" size:14];
        textField.keyboardType = UIKeyboardAppearanceDefault;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
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
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.separatorStyle = UITableViewCellStyleValue1;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    _lists = [[RailsListCachesManager sharedManager] getData];
    [self getListsData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _tableView.frame = [UIScreen mainScreen].bounds;
    CGRect tableFrame = _tableView.frame;
    tableFrame.origin.y = CGRectGetMaxY(textField.frame) + 20.0f;
    _tableView.frame = tableFrame;
    
    CGRect textFrame = textField.frame;
    textFrame.size.width = self.view.bounds.size.width - CGRectGetWidth(postButton.frame) - 20.0f;
    textField.frame = textFrame;
    
    CGRect Frame = postButton.frame;
    Frame.origin.x = CGRectGetMaxX(textField.frame) + 5.0f;
    Frame.origin.y = CGRectGetMinY(textField.frame);
    postButton.frame = Frame;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:YES];
}

- (void)getListsData
{
    [self.manager getJsonData:^(NSMutableArray *posts, NSError *error)
     {
         if (error) {
             [self showAlert:@"読み込みに失敗しました"];
         }
         _lists = posts;
//         [[RailsListCachesManager sharedManager] addData:_lists];
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@" tableView : %@", _lists);
    _post = [_lists objectAtIndex:indexPath.row];
    cell.textLabel.text = _post.text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"id ▶︎ %@", _post.postId];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_lists removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.manager deleteJsonData:_lists[indexPath.row] completionHandler:^(NSError *error) {
            //
        }];
    }
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
    
    if ([[[textField text] stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
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
