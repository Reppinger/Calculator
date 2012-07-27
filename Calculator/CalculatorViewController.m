//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Randy Eppinger on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize entries;
@synthesize userIsEnteringNumber;
@synthesize brain = _brain;

- (CalculatorBrain *) brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    [self updateDisplay:digit];
}

- (IBAction)enterPressed {
    NSString *currentDisplay = [self.display.text stringByAppendingString:@" "];
    [self.brain pushOperand:[currentDisplay doubleValue]];
    [self appendToEntries:currentDisplay];
    self.userIsEnteringNumber = NO;
}

- (IBAction)operationPressed:(id)sender {
    if (self.userIsEnteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self appendToEntries:[operation stringByAppendingString:@" "]];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result]; 
}

- (IBAction)clearPressed:(id)sender {
    self.display.text = @"";
    self.entries.text = @"";
    [self.brain clear];
}

- (void)appendToEntries:(NSString *)newEntry {
    self.entries.text = [self.entries.text stringByAppendingString:newEntry];
}

- (void)updateDisplay:(NSString *)valueToDisplay {
    if (self.userIsEnteringNumber) {
        if ([self isDecimalPoint:valueToDisplay] && [self displayAlreadyHasDecimalPoint]) {
            return;
        }
        self.display.text = [self.display.text stringByAppendingString:valueToDisplay];
    } else {
        self.display.text = valueToDisplay;
        self.userIsEnteringNumber = YES;
    }
}


- (BOOL) isDecimalPoint:(NSString *)digit{
    NSRange range = [digit rangeOfString:@"."];
    return (range.length > 0);
}

- (BOOL) displayAlreadyHasDecimalPoint {
    NSRange range = [self.display.text rangeOfString:@"."];
    return (range.length > 0);    
}
	
- (void)viewDidUnload {
    [self setEntries:nil];
    [super viewDidUnload];
}
@end
