//MVC: Model View Controler
/*
How to arrange the classes?:MVC
Controller = How your Model is presented to the user?(UI logic)
View = Your Controller's menion
It's all about managing communications between camps.
    - Controllers can always talk directly to their Model.
    - Controllers can also talk directly to their View.(Outlet)
    - The Model and View should never speak to each other.
    - Can View talk to the controller?
        - Sort of. Communication is blind and Structured.
        - The Controller can drop a target on itself.
        - Then handout an action to the View.
        - The View sends the action when things happen in the UI.
 
        - Sometimes the View need to sychronize with the Controller.
        - The Controller sets itself as the View's delegate.
 
        - Views do not own the data they display.
        - So if needed, they have a protocal to acquire it.
        - Controllers are almost always the data source(not Model!).
    - Can Model talk to the Controller?
        - No. The Model is(should be) UI independent.
        - So what if the model has infomation to update or something?
        - It uses a "radio station"-like a broadcast mechanism.
 */

//Properties
#import "Card.h"

@interface Card()

@end

@implementation Card

int main(int argc, const char *argv[])
{
    NSLog(@"Hello, world.");
}

@end
