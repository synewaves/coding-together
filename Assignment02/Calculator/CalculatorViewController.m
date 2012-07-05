//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Matthew Vince on 7/2/12.
//  Copyright (c) 2012 Matthew Vince. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface  CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
- (void)appendToStackDisplay:(NSString *)value;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize stackDisplay = _stackDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

// Handles the digitPressed event
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    BOOL isDot = [digit isEqualToString:@"."];
      
    if (self.userIsInTheMiddleOfEnteringANumber) {
        if (isDot && [self.display.text rangeOfString:@"."].location != NSNotFound) {
            // already entered a decimal point
            return;
        }

        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        if (isDot) {
            // prepend with 0 for formatting niceness
            self.display.text = [@"0" stringByAppendingString:digit];
        } else {
            self.display.text = digit;
        }
        
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

// Handles the enterPressed event
// Will push an operand onto the stack
- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self appendToStackDisplay:self.display.text];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


// Handles the operationPressed event
// Will perform the operation and display result
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    
    [self appendToStackDisplay:operation];
    [self appendToStackDisplay:@"="];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

// Handles the clearPressed event
// Clears out the calculator
- (IBAction)clearPressed:(UIButton *)sender
{
    [self.brain clearMemory];
    self.display.text = @"0";
    self.stackDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

// Handles the switchSignPressed event
// Will either change the display's sign of operand or perform (x * -1) calculation
- (IBAction)switchSignPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        // switch sign in display
        self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
    } else {
        // just perform operation
        [self operationPressed:sender];
    }
}

// Handles the backspacePressed event
// Will remove last inputted symbol, but not operators. Clears to 0.
- (IBAction)backspacePressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        int length = [self.display.text length];
        
        if (length == 1) {
            self.display.text = @"0";
        } else if (length > 0) {
            self.display.text = [self.display.text substringToIndex:length - 1];
        }
    }
}

// Appends a new item to the display stack
- (void)appendToStackDisplay:(NSString *)value
{
    NSString *valueToAppend = [@" " stringByAppendingString:value];
    self.stackDisplay.text = [self.stackDisplay.text stringByReplacingOccurrencesOfString:@" =" withString:@""];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:valueToAppend];
}

@end
