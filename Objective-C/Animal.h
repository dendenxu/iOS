#import "BeautyContest.h"
#import <Foundation/Foundation.h>

@interface Animal : NSObject <BeautyContest>

@property NSString *name;
@property NSString *favFood;
@property NSString *sound;

@property float weight;

- (instancetype)initWithName:(NSString *)defaultName;

- (void)getInfo;

- (float)weightInKg:(float)weightInLbs;

- (NSString *)talkToMe:(NSString *)myName;

- (int)getSum:(int)num1
	nextNumber:(int)num2;

@end