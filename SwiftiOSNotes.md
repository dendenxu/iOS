# Notes for Swift & iOS

## Concentration Code Collection

```swift
//
//  ViewController.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/6/30.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ViewController: UIViewController//This shouldn't be changed any time soon
{
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count+1)/2);//var game: Concentration = Concentration();
    
    var flipCount = 0
    {
        didSet//didSet is like the monitor of a vaiable, whenever something changes, the program does the following stuff
        {
            flipCountLabel.text = "Flip Count: \(flipCount)";
        }
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!//The exclaiming mark means that the variable is an optional an is automatically unwrapped whenever used

    @IBOutlet var cardButtons: [UIButton]!
//    var emojiCollections = ["👻","🎃","👻","🎃"]//omit the type specification because that is not implicit at all
    
    @IBAction func touchCard(_ sender: UIButton)// the _ is for the caller to use
    {
        flipCount+=1;
        if let cardIndex = cardButtons.firstIndex(of: sender)//We do that because we want swift to look like English. The if let structure tests whether the optional variable is a nil. If it is, unwarps it.
        {
//            print("cardIndex is at \(cardIndex)");
//            flipCard(withEmoji:emojiCollections[cardIndex],on:sender);
            game.chooseCard(at: cardIndex);
            updateViewFromModel();
        }
        else
        {
            print("Button is not in the array");
        }
    }
    
    func updateViewFromModel()
    {
        for index in cardButtons.indices
        {
            let button = cardButtons[index];
            let card = game.cards[index];
            if card.isFacedUp
            {
                button.setTitle(emoji(for: card), for: UIControl.State.normal);
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            }
            else
            {
                button.setTitle("", for: UIControl.State.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1) ;
            }
        }
    }

    var emojiChoices = ["👻","🎃","🐒","🦕","🦀","🐺","🦋"]//omit the type specification because that is not implicit at all
    
//    var emoji = Dictionary<Int, String>();
    var emoji = [Int:String]();
    
    func emoji(for card:Card) -> String
    {
        // In swift, if we have nested "if"s, we can put them in the same line and seperate them with a comma
        if emoji[card.identifier]==nil, emojiChoices.count != 0
        {
            // arc4randowm_uniform generates random numbers
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)));
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex);
        }
        
//        if emoji[card.identifier] != nil
//        {
//            return emoji[card.identifier]!;
//        }
//        else
//        {
//            return "?";
//        }
        //exactly the same as
        return emoji[card.identifier] ?? "?";
    }
//    @IBAction func touchSecondCard(_ sender: UIButton)
//    {
//        flipCount+=1;
//        flipCard(withEmoji: "🎃", on: sender);
//    }
//These are duplicated codes and are really unwelcomed, should be augmented
    
//    func flipCard(withEmoji emoji:String, on button:UIButton)//We do that because we want swift to look like English
//    {
//        print("flipCard(withEmoji: \(emoji))");
//        if button.currentTitle == emoji
//        {
//            button.setTitle("", for: UIControl.State.normal);
//            button.backgroundColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1);
//        }
//        else
//        {
//            button.setTitle(emoji, for: UIControl.State.normal);
//            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
//        }
//    }
}


```

```swift
//
//  Concentrarion.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

class Concentration//every class gets a free initalizer with no parameters as long as all its variables are initialized
{
    var cards = [Card]();//[Card] is an array, array has multiple initializers, one of which is this empty init. This is the same as Array<Card>()
    
    func chooseCard(at index:Int)
    {
        if cards[index].isFacedUp
        {
            cards[index].isFacedUp = false;
        }
        else
        {
            cards[index].isFacedUp = true;
        }
    }
    //init is a function that has the same inside and outside parameter
    init(numberOfPairsOfCards:Int)
    {
        //Using for loop with a sequenced stuff
        //Here we use countable range
        //for identifier in 0..<numberOfPairsOfCards
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card();//We let card decide its unique identifier
            //cards.append(card);
            //cards.append(card);
            //Using method:append to add something in an array
            cards += [card,card];//When putting something inside an array, swift makes a copy of it
        }
        
        //TODO:shuffle the cards
    }
};

```

```swift
//
//  Card.swift
//  Concentration
//
//  Created by Zhen Xu on 2019/7/5.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import Foundation

struct Card//every struct gets a free initializer with all its instance variables queried
    //Differences between struct and array:
    //1. structs are value type(making a copy while passing)
    //2. classes are reference type(passing pointers)
{
    var isFacedUp = false;
    var isMatched = false;
    var identifier :Int;
    //We are in the model here, not the UI.
    //So we shouldn't have any emoji or what
    
    static var identifierFactory = 0;
    
    static func getUniqueIdentifier() ->Int
    {
        identifierFactory += 1;
        return identifierFactory;
    }
    
//    init(identifier:Int)
//    {
//        self.identifier = identifier;
//        //approximately self == this. This is a way of distinguishing between these two
//    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier();
    }
};

```

## Concentration

- `Model`
  - `Concentraion`负责成对分配卡片，打乱顺序，以及在接收到信息时对卡片做处理
  - `Card`负责卡片信息的构建，包括`isMatched`，`isFaceUp`和`identifier`变量的创建
- `ViewController`
  - `ViewController`负责分配游戏
  - 并且将Model中的`Card`概念映射到屏幕上的`Buttons`
  - 并且以字典的形式把`Emoji`也做一一对应
  - 三者中相互联系的部分是`Card`中的`identifier`

## Tuple

Tuple is very light weight.

You can define a tuple using this:

```swift
let x:(String, Int, Double) = ("Hello", 5, 0.85);// In this case, the name of the three elements will be 0, 1 and 2. So it's kind of the same as let x:(0: String, 1: Int, 2: Double);
let (Name, Age, Ratio) = x;
print(Name);
print(Age);
print(Ratio);

let x:(Name:String, Age: Int, Ratio: Double) = ("Mike", 14, 0.99);
print(x.Name);
print(x.Age);
print(x.Ratio);

```

## Computed Properties

Some properties of an instance is stored inside the memory, while in swift you can get them to be computed if you've found any duplication.

Just use a pair of brackets and some get and set to achieve that.

```swift
// Like:
var indexOfOneAndOnlyFaceUpCard: Int?
{
  get
  {
    var foundIndex:Int?;
    for index in cards.indices
    {
      if cards[index].isFaceUp
      {
        if foundIndex == nil
        {
          foundIndex = index;
        }
        else
        {
          return nil;
        }
      }
    }
    return foundIndex;
  }
  set
  {
    for index in cards.indices
    {
      cards[index].isFaceUp = index == newValue;
    }
  }
}
```



## Arrays Have Shuffle

```swift
//    func shuffle(theArray: [Card]) -> [Card]
//    {
//        var list = theArray;
//        for index in 0..<list.count {
//            let newIndex = Int(arc4random_uniform(UInt32(list.count - index))) + index
//            if index != newIndex {
//                list.swapAt(index, newIndex);
//            }
//        }
//        return list;
//    }

// Or you can just do:
cards.shuffle();
```

## Access Control

- **internal**: this is the default, it means "usable by any object in my app or framework"
- **private**: only callable from within this object
- **private(set)**: the property is readable outside this object, but not settable
- **fileprivate**: accessible by any code in this source file 
- **public**: (for frameworks only) can be used by objects outside my framework
- **open**: (for frameworks only) public and object outside my framework can subclass it.

## Assert

给出一个条件，如果不满足则让程序停止运行。并以我们想要的报错信息报错。例如：

```swift
assert(cards.indices.contains(index), "Concentraion.chooseCard(at \(index)): chosen index out of range");
assert(numberOfPairsOfCards > 0, "Concentraion.init(\(numberOfPairsOfCards)): you should have at least one pair of cards");
```

## Extensions

Adding methods or properties to a class without having to have its code. Like this:

```swift
extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)));
        }
        else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(-self)));
        }
        else
        {
            return 0;
        }
    }
}
// By doing this, we add an extension to the class Int, which has a var arc4random of type Int.(computable property)
// Be mindful that extentions should have memory. They can only be computed properties.
```

## Enum

Can only have discrete states...

```swift
enum FastFoodMenuItem
{
  case hamburger(numberOfPatties: Int);
  case fries(size: FryOrderSize);
  case drink(String, ounces: Int);
  case cookie;
}
enum FryOrderSize
{
  case large;
  case small;
}

let menuItem: FastFoodMenuItem = FastFoodMenuItem.hamburger(numberOfPatties: 2);//when you set the value, it's fixed.
// Same as var otherItem: FastFoodMenuItem = .cookie;
// var otherItem = FastFoodMenuItem.cookie;
var otherItem: FastFoodMenuItem = FastFoodMenuItem.cookie;

// We use switch case pairs against enum
```

Using Enum's data

```swift
var menuItem = FastFoodMenuItem.cookie;
switch menuItem
{
  case .hamburger: break;
  case .fries: print("Fried");
  default: print("other");
}
//multiple lines are also available
var menuItem = FastFoodMenuItem.fries(size: .large)

```

Getting the associated data:

```swift
var menuItem = FastFoodMenuItem.drink("Coke", ounces: 32);

switch menuItem
{
  case .hamburger(let pattyCount): print("A burger with \(pattyCount) patties!");
  case .fries(let size): print("A \(size) order of fries!");
  case .drink(let brand, let ounces): print("a \(ounces)oz \(brand)");
  case .cookie: print("a cookie!");
}
// Note that local variable that retrieves the associated data can even have a different name, like in tuple when you assign it to another tuple.
```

What about Methods? And Vars?

```swift
// func yes, stored properties no
// and you can use switch self to get your own data
enum FastFoodMenuItem
{
  ...
  func isIncludedInSpecialOrder(number: Int) -> Bool
  {
    switch self
    {
      case .hamburger(let pattyCount): return pattyCount == number;
      case .fries, .cookie: return true;
      case .drink(_, let ounces): return ounces == 16;
    }
  }
  
  var calories
  {
    get
    {
      ...
    }
    set
    {
      ...
    }
  }
  
  
  // How to modify the enum
  mutating func switchToBeingACookie()
  {
    self = .cookie;// this works even if self is a .hamburger or .drink
    // Note that mutating is required because enum is a VALUE TYPE.
  }
}
```

## Optionals: Enum

```swift
enum Option<T>// a generic type, like Array<Element>...
{
  case none;
  case some(<T>);
}

// Operators
var hello: String?;						var hello: Optional<String> = .none;
var hello: String? = "Hello";	var hello: Optional<String> = .some("Hello");
var hello: String? = nil;			var hello: Optional<String> = .none;


let hello: String? = ...;			switch hello
print(hello!);									{
  																case .none: //raise an exception
  																case .some(let data): print(data);
																}

if let greeting = hello				switch hello
{																{
  print(greeting);								case .some(let data): print(data);
}																	case .none:// Do something else
else														}
{
  // Do something else
}
```



## Memory Management

Apple 使用ARC方法来管理内存，当没有强指针指向某个内容时，他就被清空。但对于弱指针（只能是一个Optional变量），不计入强指针的统计中，当没有其他强指针指向某一片内存时，这个弱指针就被设为nil。unowned意思是不使用ARC的方式来管理内容，我保证不错误地使用这个指针。

**strong**: strong is a normal reference counting.**weak**、**unowned**

## Protocols

Essencially a way to express an API more concisely

Just a list of var and functions. And a protocal is just a **TYPE**

1. declaration of a protocal
2. class or struct or enum declaration that makes the clain to implement the protocal
3. the code in said class

其实可以有Stored Properties，只要Protocols中的声明包括了get和set，实现它的那个类或结构就可以用Stored Properties来实现。

```swift
protocol Moveable
{
  mutating func move(to point: CGPoint);
}
class Car: Moveable
{
  func move(to point: CGPoint) {...}
  func changeOil() {...}
}
struct Shape: Moveable
{
  mutating func move(to point: CGPoint) {...}
  func draw() {...}
}

let prius: Car = Car();
let square: Shape = Shape();

var thingToMove: Moveable = prius;
thingToMove.move(to: _)//OK
thingToMove.changeOil()//Not OK
thingToMove = square;
let thingToMove:[Moveable] = [prius, square];

func slide(slider: Moveable)
{
  let positionToSlideTo = _;
  slider.move(to: positionToSlideTo);
}
slide(prius);
slide(square);

```



## Delegation

举个例子：

```swift
// UIScrollView has a delegate property
weak var delegate: UIScrollViewDelegate?;

// And this is probably what UIScrollViewDelegate looks like
@objc protocol UIScrollViewDelegate
{
  Optional func scrollViewDidScroll(scrollView: UIScrollView);
  Optional func viewForZooming(in scrollView: UIScrollView) -> UIView
  ... and many more
}
// A Controller with a UIScrollView in its View would be declared like this ...
class MyViewController: UIViewController, UIScrollViewDelegate{...}
// probably in the @IBOutlet didSet for the scroll view, the Controller would do...
scrollView.delegate = self;
```

## Dictionary

其实也是一种Protocol。

```swift
protocol Equatable
{
  static func == (lhs: self, rhs: self) -> Bool;
}
protocol Hashable: Equatable
{
  var hashValue: Int{get}
}
Dictionary<Key: Hashable, Value>
```

## Multiple Inheritance

You can extent your protocol and then implement your default stuff.

## Functional Programming



## String

**Character**: The character in a String

String cannot be indexed by Int

Indices into Strings are therefore of a different type … String.Index.

```swift
let pizzaJoint = "café pesto";
let firstCharacterIndex = pizzaJoint.startIndex;
let fourthCharacterIndex = pizzaJoint.index(firstCharacterIndex, offsetBy: 3);

if let firstSpace = pizzaJoint.index(of: " ")
{
  //return nil if " " is not found.
  let secondWordIndex = pizzaJoint.index(firstSpace,offsetBy: 1);
  let secondWord = pizzaJoint[secondWordIndex..<pizzaJoint.endIndex];
}

pizzaJoint.components(separatedBy: " ")[1]
// remember to import Foundation
```

String is also a sequence, and it's a collection.

```swift
for c in s{}
let characterArray = Array(s);

// Note the ..< Range appears to have no start. But it do works
```

## NSAttributedString

```swift
let attributes: [NSAttributedStringKey: Any] = 
[
  .strokeColor: UIColor.orange,
  .strokeWidth: 5.0
]
let attribtext = NSAttributedString(string: "Flips: 0", attributes: attributes);


    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString
    {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
```



## Closure

 super simple

```swift
var operation: (Double) -> Double = {-$0};
or
var operation: (Double) -> Double = {(operated: Double)->Double in return -operated};
// All those parameters, return types whatever can be easily inferred by swift. And the return sign can also be omitted. We can also simply call the parameters $0, $1, $2 ...
let result = operation(4.0)//result will be -4.0
```

And where do we use it(Closure)?

```swift
//Array has a method called map which takes a function as an argument.
let primes = [2.0,3.0,5.0,7.0,11.0];
let negativePrimes = primes.map({-$0});
let invertedPrimes = primes.map() {1.0/$0};
let primeStrings = primes.map { String($0)};
//如果某个函数的最后一个参数是一个闭包，那么它可以被放在小括号外面。
//如果这个参数是该函数的唯一一个参数，那么这个函数可以没有小括号。

// Property initialization
var someProperty: Type = 
{
  //Constructing the value of someProperty here
  return <the constructed value>
}()// This is going to be especially useful when dealing with lazy vars

// Closures capture stuff around them and it's of reference type
var ltuae = 42
operation = { ltuae * $0 }
arrayOfOperations.append(operation)
```

## Thrown Error

In swift, methods can throw errors

- having keyword throws on the end

```swift
func save() throws
do
{
  try context.save()
}
catch let error
{
  throw error
}
let x = try? throwOrInt()

```

## Any or AnyObject

```swift
let unknown: Any = ...
if let foo = unknown as? MyType
{
  
}

let vc: UIViewController = ConcentrationViewController()
// This is legal, but you can touch card or whatever here.
if let cvc = vc as? ConcentrationViewController
{
  cvc.flipCard(...)// This is gonna be OK.
}
```

## Views

```swift
var superview: UIView?
var subviews: [UIView]
```

The hierarchy is mostly often constructed in Xcode graphically

- even custom views are usually added to the view hiearchy using Xcode

But it can also be done in code as well

```swift
func addSubview(_ view: UIView)	// Sent to view's superview
func removeFromSuperview()			// Sent to the view you want to remove
```

What't the top?

```swift
var view: UIView
```

## Initializing an UIView

using initializers

## Coordinate System Data Structure

### CGFloat

### CGPoint

```swift
var point = CGPoint(x: 37.0, y: 55.2)
point.x -= 30
point.y += 20.0
```

### CGSize

```swift
var size = CGSize(width: 100.0, height: 50.0)
size.width += 42.5
size.height += 75
```

### CGRect

```swift
struct CGRect
{
  var origin: CGPoint
  var size: CGSize
}
let rect = CGRect(origin: aCGPoint, size: aCGSizee)
```

Origin is upper left. Example:

```swift
// Assume this code is in a UIViewController (and thus the var view is the root view)
let labelRect = CGRect(x: 20, y: 20, width: 100, height: 50)
let label = UILabel(frame: labelRect)
labet.text = "Hello"
view.addSubview(label);
```



## To Draw

### Core Graphics Concepts

1. Get a context to draw in.
2. Create paths
3. Set drawing attributes
4. Stroke or fill the above-created paths with the given attributes

### UIBezierPath

Almost the same

```swift
//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/19.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class PlayingCardView: UIView {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
//        if let context = UIGraphicsGetCurrentContext()
//        {
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
//
//            context.setLineWidth(5.0)
//            #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).setFill()
//            #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).setStroke()
//            context.strokePath()
//            context.fillPath()
//        }
//
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2 * CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).setFill()
        #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).setStroke()
        path.stroke()
        path.fill()
    }

}

```

## Using Constant Elegantly

```swift
extension PlayingCardView
{
  private struct SizeRatio
  {
    static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
    static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    static let cornerOffsetToCornerRadius: CGFloat = 0.33
    static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
  }
  
  private var cornerRadius: CGFloat
  {
    return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
  }
  
  private var cornerOffset: CGFloat
  {
    return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
  }
  
  private var cornerFontSize: CGFloat
  {
    return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
  }
  
  private var rankString: String
  {
    switch rank
    {
      case 1: return "A"
      case 2...10: return String(rank)
      case 11: return "J"
      case 12: return "Q"
      case 13: return "K"
      default: return "?"
    }
  }
}
```

## Extension for CGRect and CGPoint

```swift
extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
```

## Multitouch

```swift
// UIGestureRecognizer（抽象的概念）

// 一般利用didSet来添加识别器（当iOS在运行时将这个变量连接起来后）
@IBOutlet weak var pannableView: UIView
{
  didSet// 创建变量的时候直接添加recognizer
  {
    // 直接创建这样的识别器，并将其与某个handle（一般是ViewController中的某个方法）绑定
    let panGestureRecognizer = UIPanGestureRecognizer
    (
    	target: self, action: #selector(ViewController.pan(recognizer:))
    )
    
    // The property observer's didSet code gets called when iOS hooks up this outlet at runtime. Here we are creating an instance of concrete subclass of UIGestureRecognizer (for pans). The target gets notified when the gesture is recognized
    
    //为某个东西添加上面的手势识别器
    pannableView.addGestureRecognizer(panGestureRecognizer)
  }
}
```

1. Adding a gesture recognizer
2. Providing a method to "handle"

```swift
func pan(recognizer: UIPanGestureRecognizer)
{
  switch recognizer.state
  {
    case .changed: fallthrough
    case .ended:
    	let translation = recognizer.translation(in: pannableView)
    	recognizer.setTranslation(CGPoint.zero, in: pannableView)
    default: break
  }
}
```





## Playing Card Code Collection

```swift
//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/18.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import Foundation


// The protocol CustomStringConvertible enables you to use stuff like \(...)
struct PlayingCard: CustomStringConvertible
{
    var description: String// This is the stuff inside the CustomStringConvertible protocol
    {
        return "\(rank)\(suit)"
    }
    
  
  	// These are the two main variables of class: PlayingCard
    var suit: Suit
    var rank: Rank

    enum Suit: String, CustomStringConvertible
    {
        var description: String// Stuff for CustomStringConverible
        {
            return rawValue
        }
        
      
      	// enum with rawValue(the rawValue can be directly accessed)
        case spades = "♤"
        case hearts = "♡"
        case clubs = "♧"
        case diamonds = "♢"
				
      	// The static var is for initialization
        static var all: [Suit] = [Suit.clubs, Suit.diamonds, Suit.hearts, Suit.spades]

    }

    enum Rank: CustomStringConvertible
    {
        //This is how you gonna display it
      	var description: String
        {
            switch self
            {
            case .ace: return "A"
            case .numeric(let number): return String(number)
            case .face(let string): return string
            }
        }
        
        case ace
        case face(String)
        case numeric(Int)
				
      	// The order of the Rank is somehow like the rawValue of the Suit
        var order: Int
        {
            switch self
            {
            case .ace: return 1
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "K": return 13
            case .face(let kind) where kind == "Q": return 12
            case .numeric(let pips): return pips
            default: return 0
            }
        }

      	// The static var is for initialization
        static var all: [Rank]
        {
            // This is a computed property and this is a getter
          	var allRanks = [Rank.ace]
            for pips in 2...10
            {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
        
        
    }
}

```

```swift
//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/18.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import Foundation

struct PlayingCardDeck
{
    // initializing with an empty PlayingCard array
  	private(set) var cards = [PlayingCard]()

  	// emm OK. this is the true initializer
    init()
    {
        // the All inside Suit and Rank provides convenience for initialization
      	for suit in PlayingCard.Suit.all
        {
            for rank in PlayingCard.Rank.all
            {
                // The whole initialization process is actually appending stuff in the array
              	cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
  
  	// This is a struct, and struct is value type. And you should use mutating when trying to modify the value of a value type
  	// "draw" doesn't mean painting here, it means extracting something out the PlayingCardDeck
    mutating func draw() -> PlayingCard?
    {
        if cards.count > 0
        {
            return cards.remove(at: cards.count.arc4random)
        }
        else
        {
            return nil
        }
    }
}

extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0
        {
            return -Int(arc4random_uniform(UInt32(-self)))
        }
        else
        {
            return 0
        }
    }
}

```

```swift
//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/19.
//  Copyright © 2019 Xuzh. All rights reserved.
//


// OK. Now comes the big one.
// This is your custom view class
import UIKit

@IBDesignable// This means you can render it inside the main.storyboard
class PlayingCardView: UIView {

    @IBInspectable// This means you can modify those values in main.storyboard's inspector
    var rank: Int = 13 { didSet { setNeedsDisplay();setNeedsLayout() } }// Doing the didSet means that once the value is changed somehow, you should require iOS to redraw your things using setNeedsDisplay(), and require iOS to redraw your subviews using setNeedsLayout()
    @IBInspectable
    var suit: String = "♢" { didSet { setNeedsDisplay();setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay();setNeedsLayout() } }

  
  	// The following two is for pinch gesture
    var playingCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() } }
    // To use this as the handle of the gesture recognizer, we should declare it using @obj
    @objc func setPlayingCardScale(byPinchGestureRecognizer recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state// Switching on the state is a safe way to do this
        {
        case .changed:
            playingCardScale *= recognizer.scale
            recognizer.scale = 1.0// This is to ensure the scale is going in linear speed
        default: break
        }
    }
    
    // Creating centeredAttributedString for our small label
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString
    {
        // Create a font and then scale it to proper size in case ...
      	var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)// In case you scroll your font size in your phone's setting
      
      	// NSMutableParagraghStyle has everything that a paragraph might need
        let paragraphStyle = NSMutableParagraphStyle()// Initializing with an empty one
        paragraphStyle.alignment = .center// paragraphStyle is one of the NSAttributedStringKeys
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }

  	// Using the previous function to create an cornerString out of our suit and rank
  	// rankString is inside the extension(converting rank: Int to the specified String) 
    private var cornerString: NSAttributedString
    {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }

    private lazy var upperLeftCornerLabel = createCornerLabel()

    private lazy var lowerRightCornerLabel = createCornerLabel()

  	// Create an empty label and set it as PlayingCardView's subview
    private func createCornerLabel() -> UILabel
    {
        let label = UILabel()
        label.numberOfLines = 0// Uses as many lines as you may
        addSubview(label)
        return label
    }

  	// Adding attributed String to the label specified(now we only have its position to worry about)
    private func configureCornerLabel(_ label: UILabel)
    {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero// In case the width of the size is set already
        label.sizeToFit()
        label.isHidden = !isFaceUp// Sync with whether the card is face up
    }

  	// To make it possible for monitoring whether you've dragged the scroll bar in your iPhone's setting
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }

  	// This function draws current view's subviews
    override func layoutSubviews()
    {
        // This is pretty much something every layoutSubviews() function needs
      	super.layoutSubviews()
      
      	// UpperLeftCornerString Part
      	// Adding attributed string
        configureCornerLabel(upperLeftCornerLabel)
      	// Putting the origin point in the right position
      	// Moving thing along some offset
      	// The offset constant is set in the extension part
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)

      
      	// LowerRightCornerString Part
      	// Adding attributed string
        configureCornerLabel(lowerRightCornerLabel)
      	// AffineTransform: 仿射变换
      	// 通过仿射变换来使右下角的内容倒过来。由于旋转是绕着origin点发生的，在旋转前后我们应适当移动label
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)// 直接给label的transform属性增加一个CGAffineTransform
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
      			// In conclusion, a frame is used to draw a view in relation to its superview. The bounds are used to draw within a view’s own space.
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)// 由于label是按照从左到右，从上到下的顺序打印的，我们需要将其像左上方移动一定距离
    }


    override func draw(_ rect: CGRect)
    {
        //这个initializer只是BezierPath里面众多initializer的一个
      	let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()// subview 里面超出的部分就直接clip掉好了
        UIColor.white.setFill()
        roundedRect.fill()
				
      	// suitString is inside the extension(for image searching purpose only). Somehow the good-looking ones can't be used inside file name
        if isFaceUp
        {
            // 一般情况下我们使用if let语句来处理image，因为很有可能根本找不到这个相应的image
          	if let faceCardImage = UIImage(named: rankString + suitString, in:Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                // 找得到的话，直接调用这个UIImage的draw方法就行
              	// zoom和playingCardScale纯碎是为了实现拖放功能而放在这儿
              	// zoom能够保证这张图片以一定的中心缩放显示，而不是直接占满整个bounds
              	// 记住：bounds是对内的，frame是对super的
              	faceCardImage.draw(in: bounds.zoom(by: playingCardScale))
            }
            else
            {
                drawPips()// 这个函数其实他真的很长，很长，很长，很长……
            }
        }
        else
        {
            if let cardBackImage = UIImage(named: "cardback",in:Bundle(for: self.classForCoder), compatibleWith: traitCollection)//除了name以外的部分只是为了让这张图片能在storyboard的预览中被展示出来
            {
                cardBackImage.draw(in: bounds)
            }
        }
    }

    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1, 1], [1, 1, 1], [2, 2], [2, 1, 2], [2, 2, 2], [2, 1, 2, 2], [2, 2, 2, 2], [2, 2, 1, 2, 2], [2, 2, 2, 2, 2]]
      	// data driven

        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString
        {
            // about reduce: 就有点像递归，用于sequence
          	// 第一次reduce中，$0是reduce的第一个参数，$1是sequence中的第一个参数
          	// 第二次reduce中，$0是上一次reduce的结果，$1是sequence中的下一个参数（sequence has next）
          	// And the following code is pretty self explanary
          	let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount
            {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            }
            else
            {
                return probablyOkayPipString
            }
        }

        if pipsPerRowForRank.indices.contains(rank)
        {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
          
          	// This centers it
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2// You know what I'm saying? Center!
            for pipCount in pipsPerRow
            {
                switch pipCount
                {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

}
extension PlayingCardView
{
    // Some Ratio
  	// example: cornerFontSizeToBoundsHeight * BoundsHeight(bounds.size.height) = cornerFontSize
  	private struct SizeRatio
    {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }

  	// Creating a rectangle with radius
    private var cornerRadius: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }

  	// Using offset to make sure the label doesn't get clipped by the frame
    private var cornerOffset: CGFloat
    {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }

    private var cornerFontSize: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }

  	// rankString is inside the extension(converting rank: Int to the specified String) 
    private var rankString: String
    {
        switch rank
        {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }

  	// suitString is inside the extension(for image searching purpose only). Somehow the good-looking ones can't be used inside file name
    private var suitString: String
    {
        switch suit
        {
        case "♤": return "♠️"
        case "♡": return "♥️"
        case "♧": return "♣️"
        case "♢": return "♦️"
        default: return "?"
        }
    }
}


extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width / 2, height: height)
    }

    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width / 2, height: height)
    }

  	// Center-based resizing
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
		// Origin-based resizing
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }

  	// Center-based scaling
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
  	// Moving an CGPoint away
  	// This is used when putting the label in the right position
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint
  	{
        return CGPoint(x: x + dx, y: y + dy)
    }
}
// That's a damn long code to read...
```

```swift
//
//  ViewController.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/18.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()// Creating a deck for drawing random card out
    @IBOutlet weak var PlayingCardView: PlayingCardView!
    {
        didSet// Mostly we use didSet to add gesture recognizer to our view
        {
            // This is the common paradiam
          	let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipe.direction = [.left, .right]// We can always hit dot and then wait for the code to be completed
            PlayingCardView.addGestureRecognizer(swipe)
          	// Target is where the action is, usually it's the view controller itself
            let pinch = UIPinchGestureRecognizer(target: PlayingCardView, action: #selector(PlayingCardView.setPlayingCardScale(byPinchGestureRecognizer:)))
            PlayingCardView.addGestureRecognizer(pinch)
        }
    }
		// OR WE CAN JUST USE IBAction TO ADD GESTURE RECOGNIZER
    @IBAction func flipCard(_ sender: UITapGestureRecognizer)
    {
        switch sender.state
        {
        case .ended: PlayingCardView.isFaceUp = !PlayingCardView.isFaceUp
        default: break
        }
    }
    @objc func nextCard()
    {
        if let card = deck.draw()
        {
            PlayingCardView.rank = card.rank.order
            PlayingCardView.suit = card.suit.rawValue
        }
    }

		
  	// This function is for testing things
  	// When view is loaded, it's executed. So we can put some code to test our features within the bracket
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
```

## Multiple MVCs

When trying to use multiple MVCs in swift, we should note the following stuff

1. After control dragging the button to the view to create a segue, we should always change the segue's identifier so that we can use that in preperation procedure.
2. When creating another view controller, we should add a new cocoa touch class file to our xcode project and change the added view's class to that one

```swift
// I've implemented a splitview controller inside my interface builder
// The new theme chooser class is ConcentrationThemeChooserViewController
//
//  ThemeChooserViewController.swift
//  Concentration
//
//  Created by Xuzh on 2019/7/20.
//  Copyright © 2019 Zhen Xu. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate{

    let themes =
        [
            "Sports": "⚽️🏀🏈⚾️🥎🏐🏉🎾🥏🎱🏓🏸🥅🏒🏑🥍🏏⛳️",
            "Animals": "🐶🐱🐭🐹🐰🦊🦝🐻🐼🦘🦡🐨🐯🦁🐮🐷🐽🐸",
            "Faces": "😤😢😭😦😧😨😩🤯😬😰😱🥵🥶😳🤪😵😡😠"
        ]

  	// This is some delegate things.
  	// Turns out awakeFromNib is a function get called when stuff built from interface builder is awaken
    override func awakeFromNib()
    {
        splitViewController?.delegate = self// We need to claim ourself as an UISplitViewControllerDelegate to set ourself as its delegate
    }
    
  
  	// This function controls whether we collapse stuff when using iPhone
    func splitViewController
        (_ splitViewController: UISplitViewController,
         collapseSecondary secondaryViewController: UIViewController,
         onto primaryViewController: UIViewController) -> Bool
    {
        if let cvc = secondaryViewController as? ConcentrationViewController
        {
            if cvc.theme == nil
            {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentraionViewController
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                cvc.theme = theme
            }
        }
        else if let cvc = lastSeguedToDetailConcentrationViewController
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else
        {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    
    private var splitViewDetailConcentraionViewController: ConcentrationViewController?
    {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToDetailConcentrationViewController: ConcentrationViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Choose Theme"
        {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]
            {
                if let cvc = segue.destination as? ConcentrationViewController
                {
                    cvc.theme = theme
                    lastSeguedToDetailConcentrationViewController = cvc
                }
            }
        }
    }

}

```

## Timer

```swift
class func scheduledTimer
(
	withTimerInterval: TimerInterval,
  repeats: Bool,
  block: (Timer) -> Void
)

private weak var timer: Timer?
{
  timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true)
  {
    // code to execute here.
  }
}

timer.tolerance = 10 // in seconds
// It might help system performance to set a tolerance for "late firing"
```

这种计时器并不完全精确（即使tolerance为零）。不能用于实时动画渲染。大概精度在十分之一秒左右。



## Kinds of Animation

1. Animating UIView properties
2. Animating Controller transitions (as in a UINavigationController)
3. Core Animation
4. OpenGL and Metal: 3D
5. SpriteKit: "2.5D"
6. Dynamic Animation: "Physics" - based animation

## UIView Properties Animation

```swift
//things to animate:
//frame/center
//bounds
//transform
//alpha
//background

UIViewPropertyAnimator using closures

class func runningPropertyAnimator(
	withDuration: TimeInterval
  delay: TimeInterval
  options: UIViewAnimatorOptions,
  animations: ()->Void
  completion: ((position: UIViewAnimatingPosition)->Void)? = nil
)

if mayView.alpha == 1.0 {
  UIViewPropertyAnimator.runningPropertyAnimator(
  	withDuraion: 3.0,
    delay: 2.0,
    options: [.allowUserInteraction],// otherwise users can't touch them
    animations: { myView.alpha = 0.0 }// happens immediately
    completion: { if $0 == .end { myView.removeFromSuperView } }
  )
  print("alpha = \(myView.alpha)")// even though it takes 5s to finish the operation, it still prints out zero at this time
}
```

### UIViewAnimationOptions

1. beginFromCurrentState: pick up from other, in-progress animations of these properties
2. allowUserInteraction: all gestures to get processed while animation is in progress
3. layoutSubviews: animate the relayout of subviews with a parent's animation
4. repeat: repeat indefinitely
5. autoreverse: play animation forwards, then backwards
6. overrideInheritedDuration: if not set, use duration of any in-progress animation
7. overrideInheritedCurve: if not set use curve(e.g. ease-in/out) of in-progress animation
8. curveEaseInEaseOut: slower at beginning, normal throughout, the slow at end
9. curveEaseIn
10. curveLinear

### Entire View Modification

```swift
UIView.AnimationOptions.transitionFlipFrom{Left, Right, Top, Bottom}//Flip the entire view over
.transitionCrossDissolve//Dissolve from old to new state
.transitionCurl{Up, Down}//Curling up or down
```

example:

```siwft
UIView.transition(
	with: myPlayingCardView
	duration: 0.75
	options: [.transitionFlipFromLeft]
	animations: { cardIsFaceUp = !cardIsFaceUp }
	completion: nil
)
```

## Dynamic Animation

1. Step 1: create a UIDynamicAnimator

   ```swift
   var animator = UIDynamicAnimator(referenceView: UIView)
   // If animating views, all views must be in a view hierarchy wit referenceView at the top
   ```

2. Step 2: create and add UIDynamicBehavior instances

   ```swift
   e.g., let gravity = UIGravityBehavior()
   animator.addBehavior(gravity)
   e.g., let collider = UICollisionBehavior()
   animator.addBehavior(collider)
   ```

3. step 3: add UIDynamicItems to a UIDynamicBehavior

   ```swift
   let item1: UIDynamicItem = ...//usually a UIView
   let item2: UIDynamicItem = ...
   gravity.addItem(item1)
   collider.addItem(item2)
   gravity.addItem(item2)
   // The instance we add an item to them, it starts to take effect
   ```

UIDynamicItem Protocol

   ```swift
protocol UIDynamicItem{
	var bounds: CGRect { get }
	var center: CGPoint { get set }
  var transform: CGAffineTransform { get set }
  var collisionBoundsType: UIDynamicItemCollisionBoundsType { get set }
  var collisionBoundingPath: UIBezierPath { get set }
}
   //UIView implements this
   
   //If you change center or transform while the animator is running, you must call this method to make it take effect
   animator.updateItemUsingCurrentState(item: UIDynamicItem)
   ```

UIDynamicBehavior

```swift
func addChildBehavior(UIDynamicBehavior)
var dynamicAnimator: UIDynamicAnimator?
func willMove(to: UIDynamicAnimator?)

var action: (()->Void)?
```

Stasis

```swift
var delegate: UIDynamicAnimatorDelegate

func dynamicAnimatorDidPause(UIDynamicAnimator)

func dynamicAnimatorWillResume(UIDynamicAnimator)
```

This creates a memory cycle.

- pushBehavior has a pointer to the closure
- the closure has a pointer to the pushBehavior

```swift
if let pushBehavior = UIPushBehavior(item: [...], mode: .instantaneous){
  pushBehavior.magnitude = ...
  pushBehavior.angle = ...
  pushBehavior.action = {
    pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
    animator.addBehavior(pushBehavior) // will push right away
  }
}
// its action captures a pointer back to itself
```

### Aside: Closure Capture

- You can define local variebles on the fly at the start of a closure

  ```swift
  var foo = { [x = someInstanceOfaClass, y = "Hello"] in 
    // use x and y here
            }
  ```

- These locals can be declared `weak` or `unowned`

  ```swift
  var foo = { [weak x = someInstanceOf aClass, y = "Hello"] in 
            // use x and y here
            }
  
  var foo = { [unowned x = someInstanceOfaClass, y = "Hello"] in 
            // use x and y here, x is not an Optional
             // if you see x here and it is not in the heap, you will crash
            }
  ```

- **A memory leak occurs when a content remains in memory even after its lifecycle has ended.**

- **Closures can cause retain cycles for a single reason: by default, the object that uses them has a strong reference to them.**

- So how to break it useing this little trick

  ```swift
  class Zerg {
    // private var foo = { [weak self = self] in self?.bar() }
    // or for short we can just say:
    private var foo = { [weak self] in self?.bar()}
    private func bar() {...}
  }
  ```

- How to modify the UIPushBehavior

  ```swift
  if let pushBehavior = UIPushBehavior(item: [...], mode: .instantaneous){
    pushBehavior.magnitude = ...
    pushBehavior.angle = ...
    pushBehavior.action = {
     [unowned pushBehavior] in pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
      animator.addBehavior(pushBehavior) // will push right away
    }
  }
  // its action no longer captures pushBehavior.
  ```

  

## Failable Initializer

In swift, the initializers won’t return anything. But objective -C does. In swift, You write `return nil`to trigger an initialization failure, you do not use the `return` keyword to indicate initialization success.

## Required Initializer

Write the `required` modifier before the definition of a class initializer to indicate that every subclass of the class must implement that initializer.



## Animation Demo

```swift
//code to add in CardDynamicBehavior

if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
  let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
  switch (item.center.x, item.center.y) {
    case let (x,y) where x < center.x && y < center.y:
    push.angle = (CGFloat.pi/2).drand
    case let (x,y) where x > center.x && y > center.y:
    push.angle = CGFloat.pi + (CGFloat.pi/2).drand
    case let (x,y) where x < center.x && y > center.y:
    push.angle = CGFloat.pi * 1.5 + (CGFloat.pi/2).drand
    case let (x,y) where x > center.x && y < center.y:
    push.angle = CGFloat.pi * 0.5 + (CGFloat.pi/2).drand
    default: break
  }
}
```

### PlayingCard Code Collection

```swift
//
//  ViewController.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/18.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()

    @IBOutlet private var cardViews: [PlayingCardView]!// This is the view thing

  	// Creating dynamic animator for our view controller
    lazy var animator = UIDynamicAnimator(referenceView: view)

    lazy var cardBehavior = CardDynamicBehavior(in: animator)// See in CardDynamicBehavior.swift

    var cards = [PlayingCard]()// This is the model thing

    override func viewDidLoad() {
        super.viewDidLoad()
      
      	// Draw cards out in pairs an temporarily storing them in an array
        for _ in 1...(cardViews.count + 1) / 2 {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }

      	// Initializing cardViews:
      	// 1. setting face down
      	// 2. gathering infomation from the model
      	// 3. adding gesture recognizer
      	// 4. adding the item to dynamic behavior
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
        }
    }

  	// cardViews that are face up and not in animation and not out of the box
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter {
            $0.isFaceUp && !$0.isHidden && !($0.alpha == 0) &&
                !($0.transform == CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)) &&
                !($0.transform == CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1))
        }
    }
		
  	// whether the face up cards are an exact match
    private var faceUpCardViewsMatched: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
		
  
  	// for avoiding confliction
    private var lastChosenCardView: PlayingCardView?

    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
          	// UITapGestureRecognizer has infomation about the view that triggers it
          	// Counting face-up cards guarantees that we can't flip a third card
            if let chosenCardView = recognizer.view as? PlayingCardView, self.faceUpCardViews.count < 2 {
              	// updating lastChosenCardView
                lastChosenCardView = chosenCardView
              	// Stop the dynamic animation of the flipped card when flipping it
                cardBehavior.removeItem(chosenCardView)
              
              	// This is a transition animation
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6, // Sometimes setting duration longer can help developer detect flaws，如果在此时有第二张卡被翻面，那么他们就都会进入下面的finish阶段，然后保持face up card == 2的状态，于是就会有不好的事情发生 
                    options: [.curveEaseInOut, .transitionFlipFromBottom],
                    animations: { chosenCardView.isFaceUp = !chosenCardView.isFaceUp },// We just put what changest the view here
                    completion: {
                      	// 这里有可能有一张或者两张face-up card，由于face-up card的筛选机制，已经匹配并消失的卡片不计入face-up card
                        finished in
                        let cardsToAnimate = self.faceUpCardViews// 为了避免重复计算，在这里用变量将信息储存
                        if self.faceUpCardViewsMatched, self.lastChosenCard == chosenCardView {// 如果match了就先变大再变小在消失然后调整大小清洁垃圾。在这句话旁边，我觉得应该也得判断判断lastChosenCard和chosenCardView，但是实际上不判断好像也能正常运行
                            UIViewPropertyAnimator.runningPropertyAnimator(
                              	// This is another kind of animator: Property animator
                              	// Here we use transform
                                withDuration: 0.6,
                                delay: 0,
                                options: [.curveEaseInOut],
                                animations: {
                                    cardsToAnimate.forEach {
                                      	// CGAffineTransform will lead to blur
                                      	// This it the largening part
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
//                                        $0.frame = $0.frame.zoom(by: 3.0)
                                    }
                                },
//                                completion: {
//                                    position in
//                                    cardsToAnimate.forEach {
//                                        $0.transform = CGAffineTransform.identity
//                                        $0.frame = $0.frame.zoom(by: 3.0)
//                                    }
//                                }
                                completion: {
                                    position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [.curveEaseInOut],
                                        animations: {
                                            cardsToAnimate.forEach {
                                              	// This is the smalling part
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                        },
                                        completion: {
                                          	// This is the cleaning part
                                            position in
                                            cardsToAnimate.forEach {
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                        }
                                    )
                                }
                            )
                          // Your two face up card may do the same thing
                          // leading to disaster.
                        } else if cardsToAnimate.count == 2 {
                            if self.lastChosenCardView! == chosenCardView {
                                cardsToAnimate.forEach {
                                    chosenCardView in
                                    UIView.transition(
                                        with: chosenCardView,
                                        duration: 0.6,
                                        options: [.curveEaseInOut, .transitionFlipFromBottom],
                                        animations: { chosenCardView.isFaceUp = false },
                                        completion: { finished in self.cardBehavior.addItem(chosenCardView) }
                                    )
                                }
                            }
                        } else if !chosenCardView.isFaceUp {
                          	// if not 2, the number of face up card is 1
                          	// so we add it back to the behaviors
                            self.cardBehavior.addItem(chosenCardView)
                          	// One important thing about closure is that:
                          	// if we have a var storing the closure, the var has a 
                          	// strong pointer to the closure(since closure is of referencetype)
                          	// Meanwhile if there exists a self thing inside the closure
                          	// the closure might holds a strong pointer towards the instance
                          	// so a memory cycle may form
                        }
                    }
                )
            }
        default: break
        }
    }

//    @IBOutlet weak var PlayingCardView: PlayingCardView!
//    {
//        didSet
//        {
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
//            swipe.direction = [.left, .right]
//            PlayingCardView.addGestureRecognizer(swipe)
//            let pinch = UIPinchGestureRecognizer(target: PlayingCardView, action: #selector(PlayingCardView.setPlayingCardScale(byPinchGestureRecognizer:)))
//            PlayingCardView.addGestureRecognizer(pinch)
//        }
//    }

//    @IBAction func flipCard(_ sender: UITapGestureRecognizer)
//    {
//        switch sender.state
//        {
//        case .ended: PlayingCardView.isFaceUp = !PlayingCardView.isFaceUp
//        default: break
//        }

//    }
//    @objc func nextCard()
//    {
//        if let card = deck.draw()
//        {
//            PlayingCardView.rank = card.rank.order
//            PlayingCardView.suit = card.suit.rawValue
//        }
//    }

}

extension CGFloat {
    var drand: CGFloat {
        return CGFloat(drand48() * Double(self))
    }
}

```

```swift
//
//  CardDynamicBehavior.swift
//  PlayingCard
//
//  Created by Xuzh on 2019/7/24.
//  Copyright © 2019 Xuzh. All rights reserved.
//

import UIKit

// Creating this class means we can add child behavior to the object instance
class CardDynamicBehavior: UIDynamicBehavior {

    lazy var collisionBehavior: UICollisionBehavior = {
        var behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()// This is a lazy var, which requires an init: Cannot use get/set

    lazy var itemBehavior: UIDynamicItemBehavior = {
        var behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()


  	// When calling this function, the item can be automatically added to the push behavior
    private func push(_ item: UIDynamicItem) {
      	// mode can be .instantaneous or .constant
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
//        push.angle = (2 * CGFloat.pi).drand
      
      	// Pushing towards the center
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x <= center.x && y <= center.y:
                push.angle = (CGFloat.pi / 2).drand
            case let (x, y) where x >= center.x && y >= center.y:
                push.angle = CGFloat.pi + (CGFloat.pi / 2).drand
            case let (x, y) where x < center.x && y > center.y:
                push.angle = CGFloat.pi * 1.5 + (CGFloat.pi / 2).drand
            case let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi * 0.5 + (CGFloat.pi / 2).drand
            default:
                break
            }
        }
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).drand
        push.action = {
          	// BE CAREFUL WITH THIS: A MEMORY CYCLE MAY HAPPEN
          	// destroying the push behavior after use
            [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }

    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }

    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }

    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }

  	// in convenience init, we can easily add behaviors to the animator all in one
  	// WHICH, IS EXACTLY WHY THIS FILE EXISTS
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

```

## Regular Expression

### 推荐的表达式测试网站

[REGEX101](https://regex101.com/)

### 本文目标

30分钟内让你明白正则表达式是什么，并对它有一些基本的了解，让你可以在自己的程序或网页里使用它。

### 如何使用本教程

最重要的是——请给我*30分钟*，如果你没有使用正则表达式的经验，请不要试图在30*秒*内入门——除非你是超人 :)

别被下面那些复杂的表达式吓倒，只要跟着我一步一步来，你会发现正则表达式其实并没有想像中的那么困难。当然，如果你看完了这篇教程之后，发现自己明白了很多，却又几乎什么都记不得，那也是很正常的——我认为，没接触过正则表达式的人在看完这篇教程后，能把提到过的语法记住80%以上的可能性为零。这里只是让你明白基本的原理，以后你还需要多练习，多使用，才能熟练掌握正则表达式。

除了作为入门教程之外，本文还试图成为可以在日常工作中使用的正则表达式语法参考手册。就作者本人的经历来说，这个目标还是完成得不错的——你看，我自己也没能把所有的东西记下来，不是吗？

[清除格式](http://deerchao.net/tutorials/regex/regex.htm) 文本格式约定：**专业术语** 元字符/语法格式 正则表达式 正则表达式中的一部分(用于分析) *对其进行匹配的源字符串* 对正则表达式或其中一部分的说明

[隐藏边注](http://deerchao.net/tutorials/regex/regex.htm) 本文右边有一些注释，主要是用来提供一些相关信息，或者给没有程序员背景的读者解释一些基本概念，通常可以忽略。

### 正则表达式到底是什么东西？

**字符**是计算机软件处理文字时最基本的单位，可能是字母，数字，标点符号，空格，换行符，汉字等等。**字符串**是0个或更多个字符的序列。**文本**也就是文字，字符串。说某个字符串**匹配**某个正则表达式，通常是指这个字符串里有一部分（或几部分分别）能满足表达式给出的条件。

在编写处理字符串的程序或网页时，经常会有查找符合某些复杂规则的字符串的需要。**正则表达式**就是用于描述这些规则的工具。换句话说，正则表达式就是记录文本规则的代码。

很可能你使用过Windows/Dos下用于文件查找的**通配符(wildcard)**，也就是*和?。如果你想查找某个目录下的所有的Word文档的话，你会搜索*.doc。在这里，*会被解释成任意的字符串。和通配符类似，正则表达式也是用来进行文本匹配的工具，只不过比起通配符，它能更精确地描述你的需求——当然，代价就是更复杂——比如你可以编写一个正则表达式，用来查找所有以0开头，后面跟着2-3个数字，然后是一个连字号“-”，最后是7或8位数字的字符串(像*010-12345678*或*0376-7654321*)。

### 入门

学习正则表达式的最好方法是从例子开始，理解例子之后再自己对例子进行修改，实验。下面给出了不少简单的例子，并对它们作了详细的说明。

假设你在一篇英文小说里查找hi，你可以使用正则表达式hi。

这几乎是最简单的正则表达式了，它可以精确匹配这样的字符串：由两个字符组成，前一个字符是h,后一个是i。通常，处理正则表达式的工具会提供一个忽略大小写的选项，如果选中了这个选项，它可以匹配*hi*,*HI*,*Hi*,*hI*这四种情况中的任意一种。

不幸的是，很多单词里包含*hi*这两个连续的字符，比如*him*,*history*,*high*等等。用hi来查找的话，这里边的*hi*也会被找出来。如果要精确地查找hi这个单词的话，我们应该使用\bhi\b。

\b是正则表达式规定的一个特殊代码（好吧，某些人叫它**元字符，metacharacter**），代表着单词的开头或结尾，也就是单词的分界处。虽然通常英文的单词是由空格，标点符号或者换行来分隔的，但是\b并不匹配这些单词分隔字符中的任何一个，它**只匹配一个位置**。

如果需要更精确的说法，\b匹配这样的位置：它的前一个字符和后一个字符不全是(一个是,一个不是或不存在)\w。

假如你要找的是hi后面不远处跟着一个Lucy，你应该用\bhi\b.*\bLucy\b。

这里，.是另一个元字符，匹配除了换行符以外的任意字符。*同样是元字符，不过它代表的不是字符，也不是位置，而是数量——它指定*前边的内容可以连续重复使用任意次以使整个表达式得到匹配。因此，.*连在一起就意味着任意数量的不包含换行的字符。现在\bhi\b.*\bLucy\b的意思就很明显了：先是一个单词hi,然后是任意个任意字符(但不能是换行)，最后是Lucy这个单词。

换行符就是'\n',ASCII编码为10(十六进制0x0A)的字符。

如果同时使用其它元字符，我们就能构造出功能更强大的正则表达式。比如下面这个例子：

0\d\d-\d\d\d\d\d\d\d\d匹配这样的字符串：以0开头，然后是两个数字，然后是一个连字号“-”，最后是8个数字(也就是中国的电话号码。当然，这个例子只能匹配区号为3位的情形)。

这里的\d是个新的元字符，匹配一位数字(0，或1，或2，或……)。-不是元字符，只匹配它本身——连字符(或者减号，或者中横线，或者随你怎么称呼它)。

为了避免那么多烦人的重复，我们也可以这样写这个表达式：0\d{2}-\d{8}。这里\d后面的{2}({8})的意思是前面\d必须连续重复匹配2次(8次)。

### 测试正则表达式

其它可用的测试工具:

- [RegexBuddy](http://www.regexbuddy.com/)
- [Javascript正则表达式在线测试工具](https://deerchao.net/tools/wegester/index.html)

如果你不觉得正则表达式很难读写的话，要么你是一个天才，要么，你不是地球人。正则表达式的语法很令人头疼，即使对经常使用它的人来说也是如此。由于难于读写，容易出错，所以找一种工具对正则表达式进行测试是很有必要的。

不同的环境下正则表达式的一些细节是不相同的，本教程介绍的是微软 .Net Framework 4.5 下正则表达式的行为，所以，我向你推荐我编写的.Net下的工具 [Regester](https://deerchao.net/tools/regester/index.htm)。请参考该页面的说明来安装和运行该软件。

### 元字符

现在你已经知道几个很有用的元字符了，如\b,.,*，还有\d.正则表达式里还有更多的元字符，比如\s匹配任意的空白符，包括空格，制表符(Tab)，换行符，中文全角空格等。\w匹配字母或数字或下划线或汉字等。

对中文/汉字的特殊处理是由.Net提供的正则表达式引擎支持的，其它环境下的具体情况请查看相关文档。

下面来看看更多的例子：

\ba\w*\b匹配以字母a开头的单词——先是某个单词开始处(\b)，然后是字母a,然后是任意数量的字母或数字(\w*)，最后是单词结束处(\b)。

好吧，现在我们说说正则表达式里的单词是什么意思吧：就是不少于一个的连续的\w。不错，这与学习英文时要背的成千上万个同名的东西的确关系不大 :)

\d+匹配1个或更多连续的数字。这里的+是和*类似的元字符，不同的是*匹配重复任意次(可能是0次)，而+则匹配重复1次或更多次。

\b\w{6}\b 匹配刚好6个字符的单词。

| 代码 | 说明                         |
| ---- | ---------------------------- |
| .    | 匹配除换行符以外的任意字符   |
| \w   | 匹配字母或数字或下划线或汉字 |
| \s   | 匹配任意的空白符             |
| \d   | 匹配数字                     |
| \b   | 匹配单词的开始或结束         |
| ^    | 匹配字符串的开始             |
| $    | 匹配字符串的结束             |

正则表达式引擎通常会提供一个“测试指定的字符串是否匹配一个正则表达式”的方法，如JavaScript里的RegExp.test()方法或.NET里的Regex.IsMatch()方法。这里的匹配是指是字符串里有没有符合表达式规则的部分。如果不使用^和$的话，对于\d{5,12}而言，使用这样的方法就只能保证字符串里包含5到12连续位数字，而不是整个字符串就是5到12位数字。

元字符^（和数字6在同一个键位上的符号）和$都匹配一个位置，这和\b有点类似。^匹配你要用来查找的字符串的开头，$匹配结尾。这两个代码在验证输入的内容时非常有用，比如一个网站如果要求你填写的QQ号必须为5位到12位数字时，可以使用：^\d{5,12}$。

这里的{5,12}和前面介绍过的{2}是类似的，只不过{2}匹配只能不多不少重复2次，{5,12}则是重复的次数不能少于5次，不能多于12次，否则都不匹配。

因为使用了^和$，所以输入的整个字符串都要用来和\d{5,12}来匹配，也就是说整个输入必须是5到12个数字，因此如果输入的QQ号能匹配这个正则表达式的话，那就符合要求了。

和忽略大小写的选项类似，有些正则表达式处理工具还有一个处理多行的选项。如果选中了这个选项，^和$的意义就变成了匹配行的开始处和结束处。

### 字符转义

如果你想查找元字符本身的话，比如你查找.,或者*,就出现了问题：你没办法指定它们，因为它们会被解释成别的意思。这时你就得使用\来取消这些字符的特殊意义。因此，你应该使用\.和\*。当然，要查找\本身，你也得用\\.

例如：deerchao\.net匹配deerchao.net，C:\\Windows匹配C:\Windows。

### 重复

你已经看过了前面的*,+,{2},{5,12}这几个匹配重复的方式了。下面是正则表达式中所有的限定符(指定数量的代码，例如*,{5,12}等)：

| 代码/语法 | 说明             |
| --------- | ---------------- |
| *         | 重复零次或更多次 |
| +         | 重复一次或更多次 |
| ?         | 重复零次或一次   |
| {n}       | 重复n次          |
| {n,}      | 重复n次或更多次  |
| {n,m}     | 重复n到m次       |

下面是一些使用重复的例子：

Windows\d+匹配Windows后面跟1个或更多数字

^\w+匹配一行的第一个单词(或整个字符串的第一个单词，具体匹配哪个意思得看选项设置)

### 字符类

要想查找数字，字母或数字，空白是很简单的，因为已经有了对应这些字符集合的元字符，但是如果你想匹配没有预定义元字符的字符集合(比如元音字母a,e,i,o,u),应该怎么办？

很简单，你只需要在方括号里列出它们就行了，像[aeiou]就匹配任何一个英文元音字母，[.?!]匹配标点符号(.或?或!)。

我们也可以轻松地指定一个字符**范围**，像[0-9]代表的含意与\d就是完全一致的：一位数字；同理[a-z0-9A-Z_]也完全等同于\w（如果只考虑英文的话）。

下面是一个更复杂的表达式：\(?0\d{2}[) -]?\d{8}。

“(”和“)”也是元字符，后面的分组节里会提到，所以在这里需要使用转义。

这个表达式可以匹配几种格式的电话号码，像*(010)88886666*，或*022-22334455*，或*02912345678*等。我们对它进行一些分析吧：首先是一个转义字符\(,它能出现0次或1次(?),然后是一个0，后面跟着2个数字(\d{2})，然后是)或-或空格中的一个，它出现1次或不出现(?)，最后是8个数字(\d{8})。

### 分枝条件

不幸的是，刚才那个表达式也能匹配*010)12345678*或*(022-87654321*这样的“不正确”的格式。要解决这个问题，我们需要用到**分枝条件**。正则表达式里的**分枝条件**指的是有几种规则，如果满足其中任意一种规则都应该当成匹配，具体方法是用|把不同的规则分隔开。听不明白？没关系，看例子：

0\d{2}-\d{8}|0\d{3}-\d{7}这个表达式能匹配两种以连字号分隔的电话号码：一种是三位区号，8位本地号(如010-12345678)，一种是4位区号，7位本地号(0376-2233445)。

\(0\d{2}\)[- ]?\d{8}|0\d{2}[- ]?\d{8}这个表达式匹配3位区号的电话号码，其中区号可以用小括号括起来，也可以不用，区号与本地号间可以用连字号或空格间隔，也可以没有间隔。你可以试试用分枝条件把这个表达式扩展成也支持4位区号的。

\d{5}-\d{4}|\d{5}这个表达式用于匹配美国的邮政编码。美国邮编的规则是5位数字，或者用连字号间隔的9位数字。之所以要给出这个例子是因为它能说明一个问题：**使用分枝条件时，要注意各个条件的顺序**。如果你把它改成\d{5}|\d{5}-\d{4}的话，那么就只会匹配5位的邮编(以及9位邮编的前5位)。原因是匹配分枝条件时，将会从左到右地测试每个条件，如果满足了某个分枝的话，就不会去再管其它的条件了。

### 分组

我们已经提到了怎么重复单个字符（直接在字符后面加上限定符就行了）；但如果想要重复多个字符又该怎么办？你可以用小括号来指定**子表达式**(也叫做**分组**)，然后你就可以指定这个子表达式的重复次数了，你也可以对子表达式进行其它一些操作(后面会有介绍)。

(\d{1,3}\.){3}\d{1,3}是一个简单的IP地址匹配表达式。要理解这个表达式，请按下列顺序分析它：\d{1,3}匹配1到3位的数字，(\d{1,3}\.){3}匹配三位数字加上一个英文句号(这个整体也就是这个**分组**)重复3次，最后再加上一个一到三位的数字(\d{1,3})。

IP地址中每个数字都不能大于255. 经常有人问我, 01.02.03.04 这样前面带有0的数字, 是不是正确的IP地址呢? 答案是: 是的, IP 地址里的数字可以包含有前导 0 (leading zeroes).

不幸的是，它也将匹配*256.300.888.999*这种不可能存在的IP地址。如果能使用算术比较的话，或许能简单地解决这个问题，但是正则表达式中并不提供关于数学的任何功能，所以只能使用冗长的分组，选择，字符类来描述一个正确的IP地址：((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)。

理解这个表达式的关键是理解2[0-4]\d|25[0-5]|[01]?\d\d?，这里我就不细说了，你自己应该能分析得出来它的意义。

### 反义

有时需要查找不属于某个能简单定义的字符类的字符。比如想查找除了数字以外，其它任意字符都行的情况，这时需要用到**反义**：

| 代码/语法 | 说明                                       |
| --------- | ------------------------------------------ |
| \W        | 匹配任意不是字母，数字，下划线，汉字的字符 |
| \S        | 匹配任意不是空白符的字符                   |
| \D        | 匹配任意非数字的字符                       |
| \B        | 匹配不是单词开头或结束的位置               |
| [^x]      | 匹配除了x以外的任意字符                    |
| [^aeiou]  | 匹配除了aeiou这几个字母以外的任意字符      |

例子：\S+匹配不包含空白符的字符串。

`<a[^>]+>`匹配用尖括号括起来的以a开头的字符串。

### 后向引用

使用小括号指定一个子表达式后，**匹配这个子表达式的文本**(也就是此分组捕获的内容)可以在表达式或其它程序中作进一步的处理。默认情况下，每个分组会自动拥有一个**组号**，规则是：从左向右，以分组的左括号为标志，第一个出现的分组的组号为1，第二个为2，以此类推。

呃……其实,组号分配还不像我刚说得那么简单：

- 分组0对应整个正则表达式
- 实际上组号分配过程是要从左向右扫描两遍的：第一遍只给未命名组分配，第二遍只给命名组分配－－因此所有命名组的组号都大于未命名的组号
- 你可以使用(?:exp)这样的语法来剥夺一个分组对组号分配的参与权．

**后向引用**用于重复搜索前面某个分组匹配的文本。例如，\1代表分组1匹配的文本。难以理解？请看示例：

\b(\w+)\b\s+\1\b可以用来匹配重复的单词，像*go go*, 或者*kitty kitty*。这个表达式首先是一个单词，也就是单词开始处和结束处之间的多于一个的字母或数字(\b(\w+)\b)，这个单词会被捕获到编号为1的分组中，然后是1个或几个空白符(\s+)，最后是分组1中捕获的内容（也就是前面匹配的那个单词）(\1)。

你也可以自己指定子表达式的**组名**。要指定一个子表达式的组名，请使用这样的语法：(?<Word>\w+)(或者把尖括号换成'也行：(?'Word'\w+)),这样就把\w+的组名指定为Word了。要反向引用这个分组**捕获**的内容，你可以使用\k<Word>,所以上一个例子也可以写成这样：`\b(?<Word>\w+)\b\s+\k<Word>\b`。

使用小括号的时候，还有很多特定用途的语法。下面列出了最常用的一些：

| 分类           | 代码/语法                                                    | 说明                                                         |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 捕获           | (exp)                                                        | 匹配exp,并捕获文本到自动命名的组里                           |
| `(?<name>exp)` | 匹配exp,并捕获文本到名称为name的组里，也可以写成(?'name'exp) |                                                              |
| (?:exp)        | 匹配exp,不捕获匹配的文本，也不给此分组分配组号               |                                                              |
| 零宽断言       | (?=exp)                                                      | 匹配exp前面的位置                                            |
| (?<=exp)       | 匹配exp后面的位置                                            |                                                              |
| (?!exp)        | 匹配后面跟的不是exp的位置                                    |                                                              |
| (?<!exp)       | 匹配前面不是exp的位置                                        |                                                              |
| 注释           | (?#comment)                                                  | 这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读 |

我们已经讨论了前两种语法。第三个(?:exp)不会改变正则表达式的处理方式，只是这样的组匹配的内容不会像前两种那样被捕获到某个组里面，也不会拥有组号。“我为什么会想要这样做？”——好问题，你觉得为什么呢？

### 零宽断言

地球人，是不是觉得这些术语名称太复杂，太难记了？我也有同感。知道有这么一种东西就行了，它叫什么，随它去吧！人若无名，便可专心练剑；物若无名，便可随意取舍……

接下来的四个用于查找在某些内容(但并不包括这些内容)之前或之后的东西，也就是说它们像\b,^,$那样用于指定一个位置，这个位置应该满足一定的条件(即断言)，因此它们也被称为**零宽断言**。最好还是拿例子来说明吧：

断言用来声明一个应该为真的事实。正则表达式中只有当断言为真时才会继续进行匹配。

(?=exp)也叫**零宽度正预测先行断言**，它断言自身出现的位置的后面能匹配表达式exp。比如\b\w+(?=ing\b)，匹配以ing结尾的单词的前面部分(除了ing以外的部分)，如查找*I'm singing while you're dancing.*时，它会匹配sing和danc。

(?<=exp)也叫**零宽度正回顾后发断言**，它断言自身出现的位置的前面能匹配表达式exp。比如(?<=\bre)\w+\b会匹配以re开头的单词的后半部分(除了re以外的部分)，例如在查找*reading a book*时，它匹配ading。

假如你想要给一个很长的数字中每三位间加一个逗号(当然是从右边加起了)，你可以这样查找需要在前面和里面添加逗号的部分：((?<=\d)\d{3})+\b，用它对*1234567890*进行查找时结果是234567890。

下面这个例子同时使用了这两种断言：(?<=\s)\d+(?=\s)匹配以空白符间隔的数字(再次强调，不包括这些空白符)。

### 负向零宽断言

前面我们提到过怎么查找**不是某个字符或不在某个字符类里**的字符的方法(反义)。但是如果我们只是想要**确保某个字符没有出现，但并不想去匹配它**时怎么办？例如，如果我们想查找这样的单词--它里面出现了字母q,但是q后面跟的不是字母u,我们可以尝试这样：

`\b\w*q[^u]\w*\b`匹配包含**后面不是字母u的字母q**的单词。但是如果多做测试(或者你思维足够敏锐，直接就观察出来了)，你会发现，如果q出现在单词的结尾的话，像**Iraq**,**Benq**，这个表达式就会出错。这是因为`[^u]`总要匹配一个字符，所以如果q是单词的最后一个字符的话，后面的`[^u]`将会匹配q后面的单词分隔符(可能是空格，或者是句号或其它的什么)，后面的`\w*\b`将会匹配下一个单词，于是`\b\w*q[^u]\w*\b`就能匹配整个*Iraq fighting*。**负向零宽断言**能解决这样的问题，因为它只匹配一个位置，并不**消费**任何字符。现在，我们可以这样来解决这个问题：`\b\w*q(?!u)\w*\b`。

**零宽度负预测先行断言**(?!exp)，断言此位置的后面不能匹配表达式exp。例如：\d{3}(?!\d)匹配三位数字，而且这三位数字的后面不能是数字；\b((?!abc)\w)+\b匹配不包含连续字符串abc的单词。

同理，我们可以用(?<!exp),**零宽度负回顾后发断言**来断言此位置的前面不能匹配表达式exp：(?<![a-z])\d{7}匹配前面不是小写字母的七位数字。

请详细分析表达式(?<=<(\w+)>).*(?=<\/\1>)，这个表达式最能表现零宽断言的真正用途。

一个更复杂的例子：`(?<=<(\w+)>).*(?=<\/\1>)`匹配不包含属性的简单HTML标签内里的内容。(?<=<(\w+)>)指定了这样的**前缀**：被尖括号括起来的单词(比如可能是`<b>`)，然后是`.*`(任意的字符串),最后是一个**后缀**(?=<\/\1>)。注意后缀里的\/，它用到了前面提过的字符转义；\1则是一个反向引用，引用的正是捕获的第一组，前面的(\w+)匹配的内容，这样如果前缀实际上是<b>的话，后缀就是</b>了。整个表达式匹配的是<b>和</b>之间的内容(再次提醒，不包括前缀和后缀本身)。

### 注释

小括号的另一种用途是通过语法(?#comment)来包含注释。例如：2[0-4]\d(?#200-249)|25[0-5](?#250-255)|[01]?\d\d?(?#0-199)。

要包含注释的话，最好是启用“忽略模式里的空白符”选项，这样在编写表达式时能任意的添加空格，Tab，换行，而实际使用时这些都将被忽略。启用这个选项后，在#后面到这一行结束的所有文本都将被当成注释忽略掉。例如，我们可以前面的一个表达式写成这样：

```
      (?<=    # 断言要匹配的文本的前缀
      <(\w+)> # 查找尖括号括起来的字母或数字(即HTML/XML标签)
      )       # 前缀结束
      .*      # 匹配任意文本
      (?=     # 断言要匹配的文本的后缀
      <\/\1>  # 查找尖括号括起来的内容：前面是一个"/"，后面是先前捕获的标签
      )       # 后缀结
```

### 贪婪与懒惰

当正则表达式中包含能接受重复的限定符时，通常的行为是（在使整个表达式能得到匹配的前提下）匹配**尽可能多**的字符。以这个表达式为例：a.*b，它将会匹配最长的以a开始，以b结束的字符串。如果用它来搜索*aabab*的话，它会匹配整个字符串aabab。这被称为**贪婪**匹配。

有时，我们更需要**懒惰**匹配，也就是匹配**尽可能少**的字符。前面给出的限定符都可以被转化为懒惰匹配模式，只要在它后面加上一个问号?。这样.*?就意味着匹配任意数量的重复，但是在能使整个匹配成功的前提下使用最少的重复。现在看看懒惰版的例子吧：

a.*?b匹配最短的，以a开始，以b结束的字符串。如果把它应用于*aabab*的话，它会匹配aab（第一到第三个字符）和ab（第四到第五个字符）。

为什么第一个匹配是aab（第一到第三个字符）而不是ab（第二到第三个字符）？简单地说，因为正则表达式有另一条规则，比懒惰／贪婪规则的优先级更高：最先开始的匹配拥有最高的优先权——The match that begins earliest wins。

| 代码/语法 | 说明                            |
| --------- | ------------------------------- |
| *?        | 重复任意次，但尽可能少重复      |
| +?        | 重复1次或更多次，但尽可能少重复 |
| ??        | 重复0次或1次，但尽可能少重复    |
| {n,m}?    | 重复n到m次，但尽可能少重复      |
| {n,}?     | 重复n次以上，但尽可能少重复     |

### 处理选项

在C#中，你可以使用[Regex(String, RegexOptions)构造函数](http://msdn2.microsoft.com/zh-cn/library/h5845fdz.aspx)来设置正则表达式的处理选项。如：Regex regex = new Regex(@"\ba\w{6}\b", RegexOptions.IgnoreCase);

上面介绍了几个选项如忽略大小写，处理多行等，这些选项能用来改变处理正则表达式的方式。下面是.Net中常用的正则表达式选项：

| 名称                              | 说明                                                         |
| --------------------------------- | ------------------------------------------------------------ |
| IgnoreCase(忽略大小写)            | 匹配时不区分大小写。                                         |
| Multiline(多行模式)               | 更改^和$的含义，使它们分别在任意一行的行首和行尾匹配，而不仅仅在整个字符串的开头和结尾匹配。(在此模式下,$的精确含意是:匹配\n之前的位置以及字符串结束前的位置.) |
| Singleline(单行模式)              | 更改.的含义，使它与每一个字符匹配（包括换行符\n）。          |
| IgnorePatternWhitespace(忽略空白) | 忽略表达式中的非转义空白并启用由#标记的注释。                |
| ExplicitCapture(显式捕获)         | 仅捕获已被显式命名的组。                                     |

目前（2019/06），只有基于 Webkit/Chromium 的浏览器（如 Chrome, Safari等）才支持 dotAll 选项。

一个经常被问到的问题是：是不是只能同时使用多行模式和单行模式中的一种？答案是：不是。这两个选项之间没有任何关系，除了它们的名字比较相似（以至于让人感到疑惑）以外。事实上，为了避免混淆，在最新的 JavaScript 中，单行模式其实名叫 dotAll，意为点可以匹配所有字符，然而在指定该选项时，用的还是 Singleline 的首字母 s.

### 平衡组/递归匹配

这里介绍的平衡组语法是由.Net Framework支持的；其它语言／库不一定支持这种功能，或者支持此功能但需要使用不同的语法。

有时我们需要匹配像( 100 * ( 50 + 15 ) )这样的可嵌套的层次性结构，这时简单地使用\(.+\)则只会匹配到最左边的左括号和最右边的右括号之间的内容(这里我们讨论的是贪婪模式，懒惰模式也有下面的问题)。假如原来的字符串里的左括号和右括号出现的次数不相等，比如*( 5 / ( 3 + 2 ) ) )*，那我们的匹配结果里两者的个数也不会相等。有没有办法在这样的字符串里匹配到最长的，配对的括号之间的内容呢？

为了避免(和\(把你的大脑彻底搞糊涂，我们还是用尖括号代替圆括号吧。现在我们的问题变成了如何把*xx <aa <bbb> <bbb> aa> yy*这样的字符串里，最长的配对的尖括号内的内容捕获出来？

这里需要用到以下的语法构造：

- (?'group') 把捕获的内容命名为group,并压入**堆栈(Stack)**
- (?'-group') 从堆栈上弹出最后压入堆栈的名为group的捕获内容，如果堆栈本来为空，则本分组的匹配失败
- (?(group)yes|no) 如果堆栈上存在以名为group的捕获内容的话，继续匹配yes部分的表达式，否则继续匹配no部分
- (?!) 零宽负向先行断言，由于没有后缀表达式，试图匹配总是失败

如果你不是一个程序员（或者你自称程序员但是不知道堆栈是什么东西），你就这样理解上面的三种语法吧：第一个就是在黑板上写一个"group"，第二个就是从黑板上擦掉一个"group"，第三个就是看黑板上写的还有没有"group"，如果有就继续匹配yes部分，否则就匹配no部分。

我们需要做的是每碰到了左括号，就在压入一个"Open",每碰到一个右括号，就弹出一个，到了最后就看看堆栈是否为空－－如果不为空那就证明左括号比右括号多，那匹配就应该失败。正则表达式引擎会进行回溯(放弃最前面或最后面的一些字符)，尽量使整个表达式得到匹配。

```
<                         #最外层的左括号
    [^<>]*                #最外层的左括号后面的不是括号的内容
    (
        (
            (?'Open'<)    #碰到了左括号，在黑板上写一个"Open"
            [^<>]*       #匹配左括号后面的不是括号的内容
        )+
        (
            (?'-Open'>)   #碰到了右括号，擦掉一个"Open"
            [^<>]*        #匹配右括号后面不是括号的内容
        )+
    )*
    (?(Open)(?!))         #在遇到最外层的右括号前面，判断黑板上还有没有没擦掉的"Open"；如果还有，则匹配失败

>                         #最外层的右括号
```

平衡组的一个最常见的应用就是匹配HTML,下面这个例子可以匹配嵌套的`<div>`标签：`<div[^>]*>[^<>]*(((?'Open'<div[^>]*>)[^<>]*)+((?'-Open'</div>)[^<>]*)+)*(?(Open)(?!))</div>`.

### 还有些什么东西没提到

上边已经描述了构造正则表达式的大量元素，但是还有很多没有提到的东西。下面是一些未提到的元素的列表，包含语法和简单的说明。你可以在网上找到更详细的参考资料来学习它们--当你需要用到它们的时候。如果你安装了MSDN Library,你也可以在里面找到.net下正则表达式详细的文档。这里的介绍很简略，如果你需要更详细的信息，而又没有在电脑上安装MSDN Library,可以查看[关于正则表达式语言元素的MSDN在线文档](http://msdn.microsoft.com/zh-cn/library/az24scfc.aspx)。

| 代码/语法        | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| \a               | 报警字符(打印它的效果是电脑嘀一声)                           |
| \b               | 通常是单词分界位置，但如果在字符类里使用代表退格             |
| \t               | 制表符，Tab                                                  |
| \r               | 回车                                                         |
| \v               | 竖向制表符                                                   |
| \f               | 换页符                                                       |
| \n               | 换行符                                                       |
| \e               | Escape                                                       |
| \0nn             | ASCII代码中八进制代码为nn的字符                              |
| \xnn             | ASCII代码中十六进制代码为nn的字符                            |
| \unnnn           | Unicode代码中十六进制代码为nnnn的字符                        |
| \cN              | ASCII控制字符。比如\cC代表Ctrl+C                             |
| \A               | 字符串开头(类似^，但不受处理多行选项的影响)                  |
| \Z               | 字符串结尾或行尾(不受处理多行选项的影响)                     |
| \z               | 字符串结尾(类似$，但不受处理多行选项的影响)                  |
| \G               | 当前搜索的开头                                               |
| \p{name}         | Unicode中命名为name的字符类，例如\p{IsGreek}                 |
| (?>exp)          | 贪婪子表达式                                                 |
| (?<x>-<y>exp)    | 平衡组                                                       |
| (?im-nsx:exp)    | 在子表达式exp中改变处理选项                                  |
| (?im-nsx)        | 为表达式后面的部分改变处理选项                               |
| (?(exp)yes\|no)  | 把exp当作零宽正向先行断言，如果在这个位置能匹配，使用yes作为此组的表达式；否则使用no |
| (?(exp)yes)      | 同上，只是使用空表达式作为no                                 |
| (?(name)yes\|no) | 如果命名为name的组捕获到了内容，使用yes作为表达式；否则使用no |
| (?(name)yes)     | 同上，只是使用空表达式作为no                                 |

### 网上的资源及本文参考文献

- [精通正则表达式(第3版)](https://u.jd.com/0yfKdc)
- [微软的正则表达式教程](https://docs.microsoft.com/zh-cn/dotnet/standard/base-types/regular-expressions)
- [System.Text.RegularExpressions.Regex类(微软文档)](https://docs.microsoft.com/zh-cn/dotnet/api/system.text.regularexpressions.regex)
- [专业的正则表达式教学网站(英文)](http://www.regular-expressions.info/)
- [关于.Net下的平衡组的详细讨论（英文）](http://weblogs.asp.net/whaggard/archive/2005/02/20/377025.aspx)



## ViewController Life Cycle

- Start of the life cycle:

  CREATION

- What then?

  - Preparation if being segued to
  - Outlet setting
  - Appearing and disappearing
  - Geometry changes
  - Low-memory situations

- What to do with view controller lifecycle:

  1. Primary Setup

     ```swift
     override func viewDidLoad() {
       super.viewDidLoad() // always let super have a chance in lifecycle methods
       // do the primary set up of the MVC here
       // good time to update View using Model, for example, because my outlets are set
     }
     // DO NOT DO GEOMETRY-RELATED SETUP HERE: BOUNDARYIES NOT SET
     
     // And this method can only be called once
     ```

     ```swift
     override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       // catch View up to date
       // maybe network database: time to catch up
     }
     // Note that this method can be called repeatedly
     ```

     ```swift
     override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       // kick off something expensive thing
     }
     ```
     
     ```swift
     override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       // often undo what you did in viewDidAppear
       // for example, stop a timer that you started or stop observing something
     }
     ```
     
     ```swift
     override func viewDidDisappear(_ animated: Bool) {
       super.viewDidDisappear(animated)
       // cleaning MVC
     }
     ```
     
     when do your geometry work
     
     ```swift
     override func viewWillLayoutSubviews()
     override func viewDidLayoutSubviews()
     ```

  2. Autorotation
  
     ```swift
          
     override func viewWillTransition (
     	to size: CGSize,
     	with coordinator: UIViewControllerTransitionCoordinator
     ) {
     	super.viewWillTransition()
            //Of course the bounds of the view will be changed. So viewWill/DidLayoutSubviews get called upon this
            
            // And we can join in using the coordinator's animate(alongsideTransition:) methods.
     	}
     ```
  
  3. Low memory
  
     Why getting this?
  
     - A build up of very large videos, images or maybe sounds
  
     ```swift
     // When a low-memory situation occurs, iOS will call this method in your Controller ...
     override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
       // Stop pointing to any large-memory things (i.e. let them go away from the heap) that I'm not currently using (e.g. displaying on screen or processing somehow) and I can recreate fairly easily
     }
     
     // IF AN APPLICATION PERSISTS IN USING AN UNFAIR AMOUNT OF MEMORY, IT CAN GET KILLED BY IOS
     ```
  
  4. Waking up from a storyboard
  
     This is very early, even before the outlets are set
  
  ### Summary
  
  1. Instantiated (from storyboard usually)
  
  2. awakeFromNib (only if instantiated from a storyboard)
  
  3. segue preparation happens
  
  4. outlets get set
  
  5. viewDidLoad
  
  6. Each time the Controller's view goes on/off screen ...
  
     viewWillAppear and viewDidAppear
  
     viewWillDisappear and viewDidDisappear
  
  7. Each time geometry changed method are called
  
     viewWillLayoutSubviews and viewDidLayoutSubviews
  
  8. At any time, if memory gets low
  
     didReceiveMemoryWarning 



## About Context

Each `UIView` has a graphics *context*, and all drawing for the view renders into this context before being transferred to the device’s hardware.

iOS updates the context by calling `draw(_:)` whenever the view needs to be updated. This happens when:

- The view is new to the screen.
- Other views on top of it are moved.
- The view’s `hidden` property is changed.
- Your app explicitly calls the `setNeedsDisplay()` or `setNeedsDisplayInRect()` methods on the view.

> *Note*: Any drawing done in `draw(_:)` goes into the view’s graphics context. Be aware that if you start drawing outside of `draw(_:)`, you’ll have to create your own graphics context.



## UIScrollView

Creation:

- Drag out in a storyboard or use 
- UIScrollView(frame:)
- Select a UIView in your storyboard and choose Embed in -> Scroll View from Editor menu

Add Subview:

```swift
if let image = UIImage(name: "bigimage.jpg") {
  let iv = UIImageView(image: image)
  scrollView.addSubview(iv)
}
// Add more subviews if you want
// All of the subviews' frame will be in the UIScrollView's content area's coordinate system
```

Set contentSize:

- common bug is to the above line and forget to say about the content

Scrolling programmatically

```swift
func scrollRectToVisible(CGRect, animated: Bool)
// This will make the scroll view scroll to the rectangle specified as if someone were scrolling with his finger

// This method scrolls the content view so that the area defined by rect is just visible inside the scroll view. If the area is already visible, the method does nothing.

// I don't think there's any zooming going on. Note the JUST VISIBLE INSIDE THE SCROLL VIEW term.
```

Zooming:

- scroll view only modifies the affine transform property of the scroll view when you zoom

- will not work without minimum/maximum specified

  ```swift
  scrollView.minimumZoomScale = 0.5
  scrollView.maximumZoomScale = 2.0
  ```

- will not work without delegate method to specify view to zoom

  ```swift
  func viewForZooming(in scrollView: UIScrollView) -> UIView
  //return the view to be zoomed
  ```

- zooming programmatically

  ```swift
  var zoomScale: CGFloat
  func setZoomScale(CGFloat, animated: Bool)
  func zoom(to rect: CGRect, animated: Bool)
  // This makes sure that the rect just barely fits.
  ```
```
  

Delegate method:

​```swift
func scrollViewDidEndZooming(
  UIScrollView,
	with view: UIView,
  atScale: CGFloat
)

// Delegate method will notify you when zooming ends.
// If you redraw, make sure to reset the tarnsform back to identity.
```

## Multithreading

### Queues

Multithreading is mostly about "queues" in iOS.

Functions (usually closures) are simply lined up in a queue (like at the movies!).

Then those functions are pulled off the queue and executed on an associated thread(s).

Queues can be "serial" (one closure at a time) or "concurrent" (multiple threads servicing it)



### Main Queue

There is a very special serial queue called the "main queue".

ALL UI ACTIVITY MUST OCCUR ON THIS QUEUE AND THIS QUEUE ONLY

DEFINITELY WANT TO TAKE EXPENSIVE THINGS OUT OF THIS



### Global Queues

For non-main-queue work, you're usually going to use a shared, global, concurrent queue.



### Using Queue

Getting a queue

```swift
let mainQueue = DispatchQueue.

let backgroundQueue = DispatchQueue.global(qos: DispatchQos)
DispatchQos.userInteractive	// high priority, only do something short and quick
DispatchQos.userInitiated		// high priority, but might take a little bit of time
DispatchQos.background			// not directly initiated by user, so can run as slow as needed
DispatchQos.utility					// long-running background processes, low priority
```



Put things in queue

```swift
// You can just plop a closure onto a queue and keep running on the current queue
queue.async {...}

// Or you can block the queue waiting until the closure finishes on that other queue
queue.sync {...}
```

>When you invoke something synchronously, it means that the thread that initiated that operation will wait for the task to finish before continuing. Asynchronous means that it will not wait.



Getting non-global queue

- very rarely you might need a queue other than main or global.

  ```swift
  // Your own serial queue (use this only if you have multiple, serially depedent activities)...
  let serialQueue = DispatchQueue(label: "MySerialQ")
  // Your own concurrent queue (rare that you would do this versus global queues)...
  let concurrentQueue = DispatchQueue(label: "MyConcurrentQ", attributes: .concurrent)
  ```

### Another API

```swift
OperationQueue and Operation
// These two supports the "nesting" of dispatching, which is very rare.
```



### Example Of Multithreaded iOS API

```swift
let session = URLSession(configuration: .default)
if let url = URL(string: "http://www.google.com/...") {
  let task = session.dataTask(with: url) {
    (data: Data?, response: URLResponse?, error: Error?) in
    // Don't do UI things here
    Dispatch.main.async {
      // do UI stuff here
    }
  }
  // The task always start out paused
  task.resume()
}
```

and about the timing:

```swift
a: let session = URLSession(configuration: .default)
b: if let url = URL(string: "http://www.google.com/...") {
c:  let task = session.dataTask(with: url) {
    (data: Data?, response: URLResponse?, error: Error?) in
d:    // Don't do UI things here
e:    Dispatch.main.async {
f:      // do UI stuff here
    }
g: 	// do other stuff  
}
  // The task always start out paused
h:  task.resume()
}

i: // possible order: a b c h i d e g f
// or: ...
```

## Cassini Code Collection

### Demo of scrollView and multithreading

```swift
//
//  ImageViewController.swift
//  Cassini
//
//  Created by Xuzh on 2019/7/29.
//  Copyright © 2019 XuZh. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.25
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.bounds.size
            spinner?.stopAnimating()
        }
    }
    
    var imageURL: URL? = DemoURLs.stanford {
        didSet {
            if view.window != nil {
                fetchImage()
            }
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private func fetchImage() {
        spinner.startAnimating()
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                // TODO: terminate this when the image is no longer needed
                // When user makes another request, I want this fetching terminated. How?
                let urlContent = try? Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    if let imageData = urlContent, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
}
```

```swift
//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Xuzh on 2019/7/30.
//  Copyright © 2019 XuZh. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURLs.NASA[identifier] {
                if let imageVC = segue.destination.contents as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
}


extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }else {
            return self
        }
    }
}
```

```swift
//
//  DemoURLs.swift
//  Cassini
//
//  Created by Xuzh on 2019/7/29.
//  Copyright © 2019 XuZh. All rights reserved.
//

import Foundation

struct DemoURLs
{
    static let stanford = Bundle.main.url(forResource: "Oval", withExtension: "jpg")
//    static let stanford = URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg")

    static var NASA: [String: URL] {
        let NASAURLStrings = [
            "Cassini": "https://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
            "Earth": "https://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg",
            "Saturn": "https://www.nasa.gov/sites/default/files/saturn_collage.jpg"
//            "Saturn": "https://cdn.images.express.co.uk/img/dynamic/151/590x/NASA-probed-Saturn-with-its-Cassini-spacecraft-1156016.webp?r=1563714231211"
        ]
        var urls = [String: URL]()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }
}
```

