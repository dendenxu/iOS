#import "Animal+Exam.h"
#import "Animal.h"
#import "Koala.h"
#import <Foundation/Foundation.h>
int main(int argc, const char *argv[])
{
	@autoreleasepool
	{
		Animal *dog = [[Animal alloc] init];

		[dog getInfo];

		NSLog(@"The dog's name is %@", [dog name]);

		[dog setName:@"Spot"];

		NSLog(@"The dog's name is %@", [dog name]);

		Animal *cat = [[Animal alloc] initWithName:@"Wiskers"];

		NSLog(@"The cat's name is %@", cat.name);

		NSLog(@"180 lbs = %.2f kg", [dog weightInKg:180]);

		NSLog(@"3 + 5 = %d", [dog getSum:3 nextNumber:5]);

		NSLog(@"%@", [dog talkToMe:@"Denden"]);

		Koala *herbie = [[Koala alloc] initWithName:@"Herbie"];

		NSLog(@"%@", [herbie talkToMe:@"Denden"]);

		[herbie performTrick];

		[herbie howIsExam];

		[dog looksBeautiful];
		[cat moreBeautiful];
	}

	@autoreleasepool
	{
		//Block funtion definiton
		void (^printMessage)(NSString *m) =
			^(NSString *message) {
			  NSLog(@"%@", message);
			};

		for (int i = 0; i < argc; i++)
			NSLog(@"%@", [NSString stringWithUTF8String:argv[i]]);
	}

	return 0;
}