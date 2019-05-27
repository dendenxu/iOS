#import <Foundation/Foundation.h>
int main(int argc, const char *argv[])
{
	@autoreleasepool
	{
		// Something to do with array
		NSArray *officeSupplies = @[ @"Pencils", @"Paper" ];

		NSLog(@"First : %@", officeSupplies[0]);

		NSLog(@"Office Supplies : %@", officeSupplies);

		BOOL containsItem = [officeSupplies containsObject:@"Pencils"];
		NSLog(@"Need Pencils : %d", containsItem);

		NSLog(@"Total : %d", (int)[officeSupplies count]);
		NSLog(@"Index of Pencils is at %lu",
			  (unsigned long)[officeSupplies indexOfObject:@"Pencils"]);
		NSLog(@"Index of Paper is at %lu",
			  (unsigned long)[officeSupplies indexOfObject:@"Paper"]);

		NSMutableArray *heroes = [NSMutableArray arrayWithCapacity:5];
		[heroes addObject:@"Batman"];
		[heroes addObject:@"Flash"];
		[heroes addObject:@"Wonder Woman"];
		[heroes addObject:@"Kid Flash"];

		[heroes insertObject:@"Superman" atIndex:2];

		NSLog(@"%@", heroes);

		[heroes removeObject:@"Flash"];
		for (int i = 0; i < [heroes count]; i++)
			NSLog(@"%@", heroes[i]);
		NSLog(@" ");

		[heroes removeObjectAtIndex:0];
		for (int i = 0; i < [heroes count]; i++)
			NSLog(@"%@", heroes[i]);
		NSLog(@" ");

		[heroes removeObjectIdenticalTo:@"Superman" inRange:NSMakeRange(0, 1)];
		for (int i = 0; i < [heroes count]; i++)
			NSLog(@"%@", heroes[i]);
		NSLog(@" ");
	}
	return 0;
}
