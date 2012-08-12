//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Randy Eppinger on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

+ (double) popOperandOffStack:(NSMutableArray *) stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) {
        [stack removeLastObject];
        
    }
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) {
                result = [self popOperandOffStack:stack] / divisor;  
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = 22.0 / 7.0;
        }
        
    }
    return result;
}

+ (double) runProgram:(id)program {
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (NSString *) descriptionOfProgram:(id)program {
    return @"Assignment II continued";
}

- (NSMutableArray *) programStack
{
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id) program {
    return self.programStack.copy;
}

- (void) pushOperand:(double) operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

- (void) pushVariable:(NSString*) variable {
    [self.programStack addObject:variable];
}

- (double) performOperation:(NSString*) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}
    
- (void) clear {
    [self.programStack removeAllObjects];
}

@end
