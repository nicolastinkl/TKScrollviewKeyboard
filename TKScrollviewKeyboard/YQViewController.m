//
//  YQViewController.m
//  TKScrollviewKeyboard
//
//  Created by apple on 4/1/14.
//  Copyright (c) 2014 XSHU. All rights reserved.
//

#import "YQViewController.h"
#import "UIView+Additon.h"

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0)

#define IS_4_INCH                   (APP_SCREEN_HEIGHT > 480.0)

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define ios7BlueColor               [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]

@interface YQViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

@end

@implementation YQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ self.tablview setHeight:(APP_SCREEN_HEIGHT-self.inputviewsss.height)];
	// Do any additional setup after loading the view, typically from a nib.
    self.tablview.dataSource = self;
    self.tablview.delegate = self;
    [self.tablview reloadData];
    
  self.inputviewsss.top = APP_SCREEN_HEIGHT - 44 ;
//    self.scrollview.top = APP_SCREEN_HEIGHT - 44 ;
    
    self.scrollview.height = APP_SCREEN_HEIGHT ;
    
//    self.scrollview.contentInset = UIEdgeInsetsMake(-216.0f,   //上
//                                                    0.0f,   //左
//                                                    0.0, //下
//                                                    0.0f);  //右
    
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleKeyboardWillShow:)
//												 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleKeyboardWillHide:)
//												 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
//
//
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
        
    }
    
    return YES;
}

#pragma mark  -keyboard


- (void) handleKeyboardWillShow:(NSNotification *)paramNotification{
    
    NSDictionary *userInfo = paramNotification.userInfo;
    
    //获取键盘弹出的动画持续时间，以便后续我们使用相同的时间进行动画呈现内容
    NSValue *animationDurationObject =  userInfo[UIKeyboardAnimationDurationUserInfoKey];
    //获取键盘弹出结束时的frame,是以屏幕坐标形式表示，因此后续使用需要转换成窗体坐标 convertRect:fromView:
    NSValue *keyboardEndRectObject = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    double animationDuration = 0.0;
    CGRect keyboardEndRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    keyboardEndRect = [self.view convertRect:keyboardEndRect fromView:window];
    	UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    /* 键盘覆盖的部分*/
    CGRect intersectionOfKeyboardRectAndWindowRect =  CGRectIntersection(self.view.frame, keyboardEndRect);
    
    //        delay:0.0
//options:[self animationOptionsForCurve:curve]
    /* 滚动视图以显示遮挡内容*/
    [UIView animateWithDuration:animationDuration
                  
                     animations:^{
        self.scrollview.contentInset = UIEdgeInsetsMake(0.0f-intersectionOfKeyboardRectAndWindowRect.size.height,   //上
                                                        0.0f,   //左
                                                        0.0, //下
                                                        0.0f);  //右
        //滚动视图使标识的rect刚好可见
        [self.scrollview  scrollRectToVisible:self.inputviewsss.frame animated:NO];
                         
    }  completion:^(BOOL finished) {
            NSLog(@" self.inputviewsss.top :%f", self.inputviewsss.top);
    }];

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
        
    }

}

- (void) handleKeyboardWillHide:(NSNotification *)paramSender{
    
    NSDictionary *userInfo = [paramSender userInfo];
    NSValue *animationDurationObject =  [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    
    UIViewAnimationCurve curve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
 
    
    double animationDuration = 0.0;
    [animationDurationObject getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:[self animationOptionsForCurve:curve]
                     animations:^{

        self.scrollview.contentInset = UIEdgeInsetsZero; //0,0,0,0
                     } completion:^(BOOL finished) {
    NSLog(@" self.inputviewsss.top :%f", self.inputviewsss.top);
                     }];

}


#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{

    [self keyboardWillShowHide:notification];
    [self scrollToBottomAnimated:YES];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}


- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    NSLog(@"duration :%f curve: %c",duration , curve);
 
    
    // Animate view size synchronously with the appearance of the keyboard.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
    
    CGRect inputViewFrame = self.inputviewsss.frame;
    CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
    NSLog(@"inputViewFrameY %f",inputViewFrameY);
    // for ipad modal form presentations
    CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
    if (inputViewFrameY > messageViewFrameBottom)
        inputViewFrameY = messageViewFrameBottom;
    
    [self.inputviewsss setTop:inputViewFrameY];
    //                         self.inputviewsss.frame = CGRectMake(inputViewFrame.origin.x,
    //																  inputViewFrameY,
    //																  inputViewFrame.size.width,
    //																  inputViewFrame.size.height);
    
    [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
     - self.inputviewsss.frame.origin.y - self.inputviewsss.height];
    
    [UIView commitAnimations];
    /*
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState |  curve
                     animations:^{
                         ////[self animationOptionsForCurve:curve]
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputviewsss.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         NSLog(@"inputViewFrameY %f",inputViewFrameY);
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
                         if (inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
						 
                         [self.inputviewsss setTop:inputViewFrameY];
//                         self.inputviewsss.frame = CGRectMake(inputViewFrame.origin.x,
//																  inputViewFrameY,
//																  inputViewFrame.size.width,
//																  inputViewFrame.size.height);
                         
                         [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
                          - self.inputviewsss.frame.origin.y
                          - inputViewFrame.size.height];
                     }
                     completion:nil];*/
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tablview numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.tablview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Dismissive text view delegate

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.tablview.contentInset = insets;
    self.tablview.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    NSLog(@"bottom %f",bottom);
    insets.bottom = bottom;
    
    return insets;
}

- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = self.inputviewsss.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputviewsss.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputviewsss.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputviewsss.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)point
{
    if (!self.tabBarController.tabBar.hidden){
        return;
    }
	
    CGRect inputViewFrame = self.inputviewsss.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputviewsss.frame = inputViewFrame;
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.textview isFirstResponder]) {
        [self.textview resignFirstResponder];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row : %d ",indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
