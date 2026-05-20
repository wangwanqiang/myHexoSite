---
title: 读书笔记：iOS视图控制器与控件
id: 36
categories:
  - iOS
  - Objective-C
abbrlink: aea9
date: 2015-05-19 05:55:16
comments: true
tags:
  - iOS
  - UIKit
  - 视图控制器
  - 控件
---

# iOS 视图控制器

视图控制器（View Controller）是iOS应用架构中的核心组件，负责管理视图层次结构、处理用户交互和控制应用流程。理解和掌握视图控制器是iOS开发的基础。

## 视图控制器之间的切换

在iOS开发中，视图控制器之间的切换有多种方式，每种方式适用于不同的场景。

### 1. Push导航切换

使用UINavigationController进行push切换，适合有层级关系的页面：

```objc
// 创建目标视图控制器
SecondViewController *secondVC = [[SecondViewController alloc] init];

// Push切换
[self.navigationController pushViewController:secondVC animated:YES];
```

返回时使用：

```objc
[self.navigationController popViewControllerAnimated:YES];

// 返回到根控制器
[self.navigationController popToRootViewControllerAnimated:YES];

// 返回到指定控制器
[self.navigationController popToViewController:targetVC animated:YES];
```

### 2. Modal模态切换

模态切换适合展示独立的任务流程：

```objc
// 创建模态视图控制器
ModalViewController *modalVC = [[ModalViewController alloc] init];

// 模态展示
[self presentViewController:modalVC animated:YES completion:nil];

// 关闭模态视图
[self dismissViewControllerAnimated:YES completion:nil];
```

iOS 13以后支持多场景（Multi-Window），模态切换需要设置`modalPresentationStyle`：

```objc
modalVC.modalPresentationStyle = UIModalPresentationFullScreen; // 全屏展示
modalVC.modalPresentationStyle = UIModalPresentationPageSheet; // 页面表单样式
modalVC.modalPresentationStyle = UIModalPresentationFormSheet; // 表单样式
```

### 3. UITabBarController切换

适用于底部标签栏的多页面切换：

```objc
// 创建标签栏控制器
UITabBarController *tabBarController = [[UITabBarController alloc] init];

// 创建各个标签页
FirstViewController *firstVC = [[FirstViewController alloc] init];
firstVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                   image:[UIImage imageNamed:@"home"]
                                                     tag:0];

SecondViewController *secondVC = [[SecondViewController alloc] init];
secondVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现"
                                                     image:[UIImage imageNamed:@"discover"]
                                                       tag:1];

// 设置视图控制器数组
tabBarController.viewControllers = @[firstVC, secondVC];
```

### 4. 自定义切换动画

可以通过UIViewControllerAnimatedTransitioning协议实现自定义切换动画：

```objc
// 实现UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 自定义动画实现
}
```

## 视图控制器之间传递数据

视图控制器之间的数据传递是iOS开发中的常见需求，主要有以下几种方式。

### 1. 通知中心（NSNotificationCenter）

通知中心是一种简单的解耦方式，适合一对多的通信：

```objc
// 发布通知（发送方）
NSDictionary *userInfo = @{@"key": @"value"};
[[NSNotificationCenter defaultCenter] postNotificationName:@"CustomNotification"
                                                    object:self
                                                  userInfo:userInfo];

// 监听通知（接收方）
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(handleNotification:)
                                             name:@"CustomNotification"
                                           object:nil];

// 处理通知
- (void)handleNotification:(NSNotification *)notification {
    id value = notification.userInfo[@"key"];
    NSLog(@"Received value: %@", value);
}

// 移除监听
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```

**优点**：简单方便，两个类之间不需要有直接关系
**缺点**：不适合一对一的紧密通信，调试困难

### 2. 代理模式（Delegate）

代理模式是iOS开发中最常用的数据传递方式：

```objc
// 定义协议（SecondViewController.h）
@protocol SecondViewControllerDelegate <NSObject>
- (void)didReceiveData:(NSString *)data;
@end

@interface SecondViewController : UIViewController
@property (nonatomic, assign) id<SecondViewControllerDelegate> delegate;
@end

// 实现协议（发送方 - SecondViewController.m）
- (void)someAction {
    if ([self.delegate respondsToSelector:@selector(didReceiveData:)]) {
        [self.delegate didReceiveData:@"Hello from SecondVC"];
    }
}

// 使用代理（接收方）
SecondViewController *secondVC = [[SecondViewController alloc] init];
secondVC.delegate = self; // 协议赋值采用assign，避免循环引用
```

**注意**：代理属性应使用`assign`而非`strong`，避免循环引用

### 3. Block回调

Block是现代iOS开发中广泛使用的回调方式：

```objc
// 定义Block属性（SecondViewController.h）
typedef void (^DataCompletionBlock)(NSString *data);

@interface SecondViewController : UIViewController
@property (nonatomic, copy) DataCompletionBlock completionBlock;
@end

// 调用Block（发送方 - SecondViewController.m）
- (void)someAction {
    if (self.completionBlock) {
        self.completionBlock(@"Hello via Block");
    }
}

// 使用Block（接收方）
SecondViewController *secondVC = [[SecondViewController alloc] init];
secondVC.completionBlock = ^(NSString *data) {
    NSLog(@"Received: %@", data);
};
```

**注意**：Block属性应使用`copy`来保存block

### 4. 属性直接传值

适用于顺序展示的视图控制器：

```objc
// 方式一：直接在push前设置属性
SecondViewController *secondVC = [[SecondViewController alloc] init];
secondVC.dataString = @"Hello";
[self.navigationController pushViewController:secondVC animated:YES];

// 方式二：通过构造方法传值
@implementation SecondViewController

+ (instancetype)controllerWithData:(NSString *)data {
    SecondViewController *vc = [[SecondViewController alloc] init];
    vc.dataString = data;
    return vc;
}

@end

// 使用
SecondViewController *secondVC = [SecondViewController controllerWithData:@"Hello"];
```

### 5. 使用NSUserDefaults传递数据

适用于需要持久化保存的数据：

```objc
// 保存数据
[[NSUserDefaults standardUserDefaults] setObject:@"value" forKey:@"key"];
[[NSUserDefaults standardUserDefaults] synchronize];

// 读取数据
NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"key"];
```

---

# iOS 控件

iOS提供了丰富的UI控件，用于构建用户界面。以下是常用控件的使用方法。

## UILabel - 文本标签

用于显示静态文本：

```objc
UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 30)];
label.text = @"Hello, iOS!";
label.textColor = [UIColor blackColor];
label.textAlignment = NSTextAlignmentCenter;
label.font = [UIFont systemFontOfSize:17.0];
[self.view addSubview:label];

// 常用属性
label.numberOfLines = 0; // 多行显示，0表示不限制
label.lineBreakMode = NSLineBreakByWordWrapping; // 换行模式
label.adjustsFontSizeToFitWidth = YES; // 自动调整字体大小
```

## UIControl基类

`UIControl`是按钮、文本框等控件的基类，提供了事件处理机制。

### 控件事件类型

| 事件 | 说明 |
|------|------|
| UIControlEventTouchDown | 按下 |
| UIControlEventTouchDownRepeat | 重复按下 |
| UIControlEventTouchUpInside | 在控件内部松开 |
| UIControlEventTouchUpOutside | 在控件外部松开 |
| UIControlEventTouchCancel | 取消触摸 |
| UIControlEventValueChanged | 值改变 |
| UIControlEventEditingChanged | 编辑改变 |

## UIButton - 按钮

### 创建按钮

```objc
// 工厂方法创建（推荐）
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];

// 设置按钮位置和大小
button.frame = CGRectMake(100, 200, 120, 44);

// 设置标题
[button setTitle:@"点击我" forState:UIControlStateNormal];
[button setTitle:@"按下状态" forState:UIControlStateHighlighted];

// 设置颜色
[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

// 添加点击事件
[button addTarget:self
            action:selector( buttonClicked:)
  forControlEvents:UIControlEventTouchUpInside];
```

### 按钮类型

| 类型 | 说明 |
|------|------|
| UIButtonTypeSystem | 系统默认样式 |
| UIButtonTypeCustom | 自定义样式（无默认外观） |
| UIButtonTypeDetailDisclosure | 详情Disclosure |
| UIButtonTypeInfoLight | 信息图标（浅色） |
| UIButtonTypeInfoDark | 信息图标（深色） |
| UIButtonTypeContactAdd | 添加图标 |

**重要**：如果需要自定义按钮背景图片或样式，请使用`UIButtonTypeCustom`，否则可能出现意外显示效果。

### 按钮状态处理

```objc
// 设置不同状态的背景图片
[button setBackgroundImage:[UIImage imageNamed:@"btn_normal"] forState:UIControlStateNormal];
[button setBackgroundImage:[UIImage imageNamed:@"btn_highlighted"] forState:UIControlStateHighlighted];
[button setBackgroundImage:[UIImage imageNamed:@"btn_disabled"] forState:UIControlStateDisabled];

// 设置图片
[button setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
[button setImage:[UIImage imageNamed:@"icon_selected"] forState:UIControlStateSelected];
```

### Cancel事件

按钮的`UIControlEventTouchCancel`事件在以下情况下触发：
- 来电话时
- 锁屏时
- 系统弹出alert时
- 其他中断触摸的事件

```objc
[button addTarget:self
            action:@selector(buttonCancelled)
  forControlEvents:UIControlEventTouchCancel];
```

## UIActivityIndicatorView - 风火轮

用于显示加载状态：

```objc
// 创建风火轮
UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];

// 设置位置
indicator.center = CGPointMake(200, 300);

// 开始动画
[indicator startAnimating];

// 停止动画
[indicator stopAnimating];

// 是否正在动画
BOOL isAnimating = indicator.isAnimating;
```

### 样式类型

| 样式 | 说明 |
|------|------|
| UIActivityIndicatorViewStyleMedium | 中等大小 |
| UIActivityIndicatorViewStyleLarge | 大尺寸 |
| UIActivityIndicatorViewStyleSmall | 小尺寸（iOS 5+） |

### 显示到状态栏

```objc
// 创建并自动显示到状态栏
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
```

## UITextField - 文本输入框

```objc
UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 280, 44)];
textField.borderStyle = UITextBorderStyleRoundedRect;
textField.placeholder = @"请输入内容";
textField.delegate = self;

// 清除按钮
textField.clearButtonMode = UITextFieldViewModeWhileEditing;

// 键盘类型
textField.keyboardType = UIKeyboardTypeDefault;

// 返回键类型
textField.returnKeyType = UIReturnKeyDone;

[self.view addSubview:textField];

// 实现UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
```

## UISwitch - 开关

```objc
UISwitch *switchControl = [[UISwitch alloc] init];
switchControl.on = YES; // 设置初始状态
[switchControl addTarget:self
                  action:@selector(switchChanged:)
        forControlEvents:UIControlEventValueChanged];
```

## UISlider - 滑块

```objc
UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, 280, 30)];
slider.minimumValue = 0;
slider.maximumValue = 100;
slider.value = 50;
[slider addTarget:self
           action:@selector(sliderChanged:)
 forControlEvents:UIControlEventValueChanged];
```

## UIImageView - 图片视图

```objc
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 280, 200)];
imageView.image = [UIImage imageNamed:@"photo"];

// 内容模式
imageView.contentMode = UIViewContentModeScaleAspectFit; // 等比例缩放

[self.view addSubview:imageView];
```

## UITextView - 多行文本视图

```objc
UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, 280, 150)];
textView.text = @"这是多行文本视图";
textView.font = [UIFont systemFontOfSize:17];
textView.editable = NO; // 是否可编辑

[self.view addSubview:textView];
```

## 总结

| 控件 | 用途 | 关键类 |
|------|------|--------|
| UILabel | 显示静态文本 | 文本内容、字体、对齐 |
| UIButton | 可点击按钮 | 状态、事件处理 |
| UIActivityIndicatorView | 加载指示器 | 开始/停止动画 |
| UITextField | 单行输入 | 代理、键盘设置 |
| UISwitch | 开关选择 | on/off状态 |
| UISlider | 滑块选择 | 范围值 |
| UIImageView | 图片显示 | 图像、内容模式 |
| UITextView | 多行文本 | 编辑、滚动 |