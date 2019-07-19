## 注释部分备案

整理后的代码详见具体文件

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

## 整个`Concentration`游戏的逻辑

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



## Arrays Have `Shuffle`

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

## Initializing a UIView

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

    private func configureCornerLabel(_ label: UILabel)
    {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero// In case the width of the size is set already
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)

        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
            .rotated(by: CGFloat.pi)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }


    override func draw(_ rect: CGRect)
    {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
				
      	// suitString is inside the extension(for image searching purpose only). Somehow the good-looking ones can't be used inside file name
        if isFaceUp
        {
            if let faceCardImage = UIImage(named: rankString + suitString, in:Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                faceCardImage.draw(in: bounds.zoom(by: playingCardScale))
            }
            else
            {
                drawPips()
            }
        }
        else
        {
            if let cardBackImage = UIImage(named: "cardback",in:Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                cardBackImage.draw(in: bounds)
            }
        }
    }

    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1, 1], [1, 1, 1], [2, 2], [2, 1, 2], [2, 2, 2], [2, 1, 2, 2], [2, 2, 2, 2], [2, 2, 1, 2, 2], [2, 2, 2, 2, 2]]

        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString
        {
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
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
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
        return CGPoint(x: x + dx, y: y + dy)
    }
}

```

