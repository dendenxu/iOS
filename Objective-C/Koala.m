#import "Koala.h"

@implementation Koala

- (NSString *)talkToMe:(NSString *)myName
{
	NSString *response = [NSString stringWithFormat:@"Hello, %@, says %@", myName, self.name];
	return response;
}

- (void)performTrick
{
	NSLog(@"%@ performs a hand stand", self.name);
	[self howIsExam];
}

- (void)makeSound
{
	NSLog(@"%@ says Yawn", self.name);
}

@end
