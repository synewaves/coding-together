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
            digit = [@"0" stringByAppendingString:digit];
        }
        
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self appendToStackDisplay:self.display.text];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
       
    NSString *operation = [sender currentTitle];
    
    [self appendToStackDisplay:operation];
    double result = [self.brain performOperation:operation];
    [self appendToStackDisplay:@"="];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed:(UIButton *)sender
{
    [self.brain clearMemory];
    self.display.text = @"0";
    self.stackDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)switchSignPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        // switch sign in display
        double switchedValue = [self.display.text doubleValue];
        switchedValue *= -1;
        self.display.text = [NSString stringWithFormat:@"%g", switchedValue];
    } else {
        // new operation of multiplying by -1
        [self appendToStackDisplay:@"+/-"];
        double result = [self.brain performOperation:@"+/-"];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
}

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

- (void)appendToStackDisplay:(NSString *)value
{
    NSString *valueToAppend = [@" " stringByAppendingString:value];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:valueToAppend];
}

@end
