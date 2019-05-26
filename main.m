#import <Foundation/Foundation.h>
int main(int argc, const char *argv[])
{
    @autoreleasepool {
        //Something to do with NSStrings
        NSLog(@"Hello, world.");
        
        NSString *quote = @"Dogs have masters, while cats have staff";
        
        NSLog(@"Size of String : %d", (int)[quote length]);
        
        NSLog(@"Character at 5 : %c", [quote characterAtIndex:5]);
        
        char *name = "Denden";
        NSString *myName = [NSString stringWithFormat:@"- %s", name];
        
        BOOL isStringEqual = [quote isEqualToString:myName];
        
        printf("Are strings equal : %d\n", isStringEqual);
        
        const char *uCString = [[myName uppercaseString]UTF8String];
        
        printf("%s\n", uCString);
        
        NSString *wholeQuote = [quote stringByAppendingString:myName];
        
        NSRange searchResult = [wholeQuote rangeOfString:@"Denden"];
        
        if(searchResult.location == NSNotFound)
        {
            NSLog(@"String not found.");
        }
        else
        {
            printf("Denden is at index %lu and is %lu long\n", searchResult.location, searchResult.length);
        }
        
        NSRange range = NSMakeRange(42, 6);
        
        const char *newQuote = [[wholeQuote stringByReplacingCharactersInRange:range withString:@"Kaikai"] UTF8String];
        
        printf("%s\n",newQuote);
        
        NSMutableString *groceryList = [NSMutableString stringWithCapacity:50];
        
        [groceryList appendFormat:@"%s", "Potato, Banana, Pasta"];
        
        NSLog(@"groceryList : %@", groceryList);
        
        [groceryList deleteCharactersInRange:NSMakeRange(0,8)];
        
        NSLog(@"groceryList : %@", groceryList);
        
        [groceryList insertString:@", Apple" atIndex:13];
        
        NSLog(@"groceryList : %@", groceryList);
        
        [groceryList replaceCharactersInRange:NSMakeRange(15, 5) withString:@"Orange"];
        
        NSLog(@"groceryList : %@", groceryList);
    }
    
    @autoreleasepool {
        //Something to do with array


    }
    return 0;
}
