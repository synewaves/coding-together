//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Matthew Vince on 7/2/12.
//  Copyright (c) 2012 Matthew Vince. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)clearMemory;
-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operand;

@end
