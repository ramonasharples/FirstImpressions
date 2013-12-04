//
//  SSMMainViewController.m
//  FirstImpressions
//
//  Created by Samantha Merritt on 11/12/13.
//  Copyright (c) 2013 SamAlexDave. All rights reserved.
//

#import "SSMComposeViewController.h"
#define sendMessageFailedAlertTag 0

@interface SSMComposeViewController ()

@property (nonatomic, strong) IBOutlet UITextView *inputMessage;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;


-(IBAction)sendAMessageToParse:(id)sender;
- (void)saveMessageToCurrentUserRelation:(id)message;
- (void)saveMessageToQueue:(id)message;
- (void)setupKeyboardToolbar;
- (void)resignKeyboard:(id)sender;

@end

@implementation SSMComposeViewController

- (SADParseDataModel *)parseManager
{
	NSLog(@"Setting up _messageManager in Response view");
	if (!_parseManager) {
		_parseManager = [[SADParseDataModel alloc] init];
	}
	
	return _parseManager;
}

-(IBAction)sendAMessageToParse:(id)sender{
	[_inputMessage resignFirstResponder];
	
	//Validate input message
	if ([_inputMessage.text  isEqual: @""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
														message:@"You have to write something!"
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil, nil];
		[alert show];
	} else {
        
        NSLog(@"we are at beginning");
        BOOL flag = [self.parseManager sendAMessageToParse:_inputMessage.text];
        NSLog(@"we are at beginning of conditional");

        if (!flag) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Message"
                                                            message:@"Sending failed"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"Retry", nil];
            alert.tag = sendMessageFailedAlertTag;
            [alert show];
        } else {
            [self segueToReceivedMessage];
        }
		
	}

}

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == sendMessageFailedAlertTag) {
        if (buttonIndex == 1) {
            [self sendAMessageToParse:nil];
        }
    }
}




///////////////////   keyboard toolbar stuff /////////////////////

- (void)setupKeyboardToolbar
{
    if (self.keyboardToolbar == nil) {
        self.keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard:)];
        UIBarButtonItem *extraspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        [self.keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraspace, doneButton, nil]];
    }
}
- (void)resignKeyboard:(id)sender
{
    [_inputMessage resignFirstResponder];
}



//////////////////////////////////////////////////////////////////

- (void)segueToReceivedMessage {
	//Activate segue
	_inputMessage.text = @"";
	[self performSegueWithIdentifier:@"ReceivedMessageSegue" sender:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self navigationController].navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupKeyboardToolbar];
    _inputMessage.inputAccessoryView = self.keyboardToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
