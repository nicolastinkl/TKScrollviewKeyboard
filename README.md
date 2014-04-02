TKScrollviewKeyboard
====================

## init

- 键盘弹出时像苹果iMessage那样子平滑处理，输入栏和键盘同时以相同的动画和速度弹出，这样子体验非常好。让人感觉键盘和软件简直是焕然一体。
- 有两种方式弹出键

## 前言

**tinkl**, is some of my experiences,hope that can help *ios  developers*.

**TKRefereshTableHeaderView** uses ARC and requires iOS 7.0+.

It probably will work with iOS 6, I have not tried,but  it is not using any iOS7 specific APIs.
 
####  Installation

> just download zip file… &gt; and you can use it .

#### Links and Email

if you have some Question to ask me, you can contact email <nicolastinkl@gmail.com> link.
 
 
## Content
 
- Synchronizing rotation animation between the keyboard and the attached view----->>
[The basic principle for solving the first problem requires observing keyboard notifications such as **`UIKeyboardWillShowNotification`** and  **`UIKeyboardWillHideNotification`** and updating the appropriate views when these notifications are received. The keyboard notification object supplies the final keyboard position and its dimensions as well as keyboard animation properties such as duration and curve, allowing to perfectly synchronize keyboard appearance animation with the slide-up animation of the attached UIView. Thus, creating the effect in which the keyboard pushes the view up or pulls it down.]
Following example demonstrates the basic principle explained above:

 


example:

``` 
objective-c

– (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(keyboardWillShow:)
			name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(keyboardWillHide:)
			name:UIKeyboardWillHideNotification object:nil];
  } 
-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[[NSNotificationCenter defaultCenter]
			removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]
			removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
– (void)keyboardWillShow:(NSNotification*)notification {
	[self adjustViewForKeyboardNotification:notification];
}
– (void)keyboardWillHide:(NSNotification*)notification {
	[self adjustViewForKeyboardNotification:notification];
}
– (void)adjustViewForKeyboardNotification:(NSNotification *)notification {
	NSDictionary *notificationInfo = [notification userInfo]; 
	// Get the end frame of the keyboard in screen coordinates.
	CGRect finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	// Get the animation curve and duration
	UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]; 
	// Convert the finalKeyboardFrame to view coordinates to take into account any rotation
	// factors applied to the window’s contents as a result of interface orientation changes.
	finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window]; 
	// Calculate new position of the commentBar
	CGRect commentBarFrame = self.commentBar.frame;
	commentBarFrame.origin.y = finalKeyboardFrame.origin.y - commentBarFrame.size.height; 
	// Update tableView height.
	CGRect tableViewFrame = self.tableView.frame;
	tableViewFrame.size.height = commentBarFrame.origin.y; 
	// Animate view size synchronously with the appearance of the keyboard. 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	[UIView setAnimationBeginsFromCurrentState:YES]; 
	self.commentBar.frame = commentBarFrame;
	self.tableView.frame = tableViewFrame; 
	[UIView commitAnimations];
}

```

`To solve this problem we need to make sure not to set up any animations whenever keyboard is dismissed or presented due to rotation of the interface orientation. Instead, we only need to update the position of appropriate views. For this purpose we can utilize following UIViewController methods:`


-  willRotateToInterfaceOrientation:duration:
-  willAnimateRotationToInterfaceOrientation:duration:
-  didRotateFromInterfaceOrientation:

`When the device is rotated and rotation of the interface orientation is animated the order of the events happens in the following order:`

- willRotateToInterfaceOrientation:duration:  method is called
- UIKeyboardWillHideNotification notification is sent
- willAnimateRotationToInterfaceOrientation:duration:  method is called
- UIKeyboardWillShowNotification notification is sent
-  didRotateFromInterfaceOrientation:  method is called


*Following example demonstrates the solution explained above:*
 
```

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(keyboardWillShow:)
			name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(keyboardWillHide:)
			name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter]
			removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]
			removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
// #1
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	self.animatingRotation = YES;
}
// #3
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
// #5
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	self.animatingRotation = NO;
}
// #4
- (void)keyboardWillShow:(NSNotification*)notification {
	[self adjustViewForKeyboardNotification:notification];
}
// #2
- (void)keyboardWillHide:(NSNotification*)notification {
	[self adjustViewForKeyboardNotification:notification];
}
- (void)adjustViewForKeyboardNotification:(NSNotification *)notification {
	NSDictionary *notificationInfo = [notification userInfo];
	// Get the end frame of the keyboard in screen coordinates.
	
	CGRect finalKeyboardFrame = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	// Convert the finalKeyboardFrame to view coordinates to take into account any rotation
	// factors applied to the window’s contents as a result of interface orientation changes.
	
	finalKeyboardFrame = [self.view convertRect:finalKeyboardFrame fromView:self.view.window];
	// Calculate new position of the commentBar
	CGRect commentBarFrame = self.commentBar.frame;
	commentBarFrame.origin.y = finalKeyboardFrame.origin.y - commentBarFrame.size.height;
	// Update tableView height.
	CGRect tableViewFrame = self.tableView.frame;
	tableViewFrame.size.height = commentBarFrame.origin.y;
	
	if (!self.animatingRotation) {
		// Get the animation curve and duration
		UIViewAnimationCurve animationCurve = (UIViewAnimationCurve) [[notificationInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
		NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		
		// Animate view size synchronously with the appearance of the keyboard. 
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:animationCurve];
		[UIView setAnimationBeginsFromCurrentState:YES];
		
		self.commentBar.frame = commentBarFrame;
		self.tableView.frame = tableViewFrame;
		
		[UIView commitAnimations];
	} else {
		self.commentBar.frame = commentBarFrame;
		self.tableView.frame = tableViewFrame;
	}
}

```
###如果用如下block回调方式，那体验会比较差

~~[UIView animateWithDuration:duration
                          delay:0.0
                        options:[self animationOptionsForCurve:curve]
                     animations:^{  }   completion:nil];~~

 


<!--@end-->


[id]: http://mouapp.com "Markdown editor on Mac OS X"