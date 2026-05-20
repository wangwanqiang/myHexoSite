---
title: Go语言笔记
categories:
  - Go
  - 开发
tags:
  - Go
abbrlink: aa66
date: 2022-03-23 20:15:25
comments: true
---

# Go语言笔记

参考：https://www.runoob.com/go/go-tutorial.html

## Go语言的优势

Go语言（也称为Golang）是由Google开发的一种静态强类型、编译型、并发型，并具有垃圾回收功能的编程语言。它具有以下优势：

1. **简单易学**：Go语言语法简洁，易于上手，减少了程序员的认知负担
2. **高性能**：编译成机器码，执行效率高，接近C/C++
3. **并发支持**：内置goroutine（轻量级线程）和channel，简化并发编程
4. **内存安全**：拥有垃圾回收机制，避免内存泄漏
5. **丰富的标准库**：提供了大量实用的标准库，减少开发工作量
6. **工具链完善**：内置构建工具、格式化工具、测试工具等
7. **跨平台**：支持多种操作系统和硬件架构
8. **强类型**：静态类型系统，在编译时就能发现很多错误

## C++转Go语言指南

对于C++程序员来说，Go语言既有许多熟悉的概念，也有一些需要适应的新特性。本章节将帮助C++程序员快速理解和掌握Go语言。

### 1. 语言哲学与主要区别

C++和Go虽然都是静态类型的编译型语言，但它们的设计哲学有很大不同：

| 特性 | C++ | Go |
|------|-----|-----|
| 复杂度 | 复杂，提供多种编程范式 | 简洁，专注于实用主义 |
| 内存管理 | 手动内存管理（new/delete） | 自动垃圾回收 |
| 并发模型 | 基于线程和锁 | 基于goroutine和channel |
| 编译速度 | 较慢 | 非常快 |
| 错误处理 | 基于异常 | 基于返回值 |
| 模板 | 复杂的模板系统 | 简单的泛型支持（Go 1.18+） |

### 2. 基础语法对比

#### 程序结构

C++:
```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

Go:
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

#### 变量声明

C++:
```cpp
int a = 10;
const int b = 20;
int c, d;
```

Go:
```go
var a int = 10
const b int = 20
var c, d int
// 类型推导
var e = 30
// 短变量声明（函数内）
f := 40
```

#### 函数定义

C++:
```cpp
int add(int a, int b) {
    return a + b;
}

// 函数重载
double add(double a, double b) {
    return a + b;
}
```

Go:
```go
func add(a, b int) int {
    return a + b
}

// Go不支持函数重载，但可以使用可变参数或接口
func addVariadic(args ...int) int {
    sum := 0
    for _, v := range args {
        sum += v
    }
    return sum
}
```

### 3. 内存管理

C++程序员需要特别注意Go的自动内存管理机制：

#### 堆与栈分配

C++:
```cpp
// 栈上分配
int a = 10;
// 堆上分配（需要手动释放）
int* p = new int(20);
delete p;  // 必须手动释放
```

Go:
```go
// Go会自动决定变量分配在堆上还是栈上
// 不需要手动管理内存
var a int = 10
p := new(int)
*p = 20
// 不需要手动释放，垃圾回收器会处理
```

#### 切片与数组

C++:
```cpp
// 数组
int arr[5] = {1, 2, 3, 4, 5};
// 动态数组（需要手动管理内存）
std::vector<int> vec = {1, 2, 3, 4, 5};
vec.push_back(6);
```

Go:
```go
// 数组
var arr [5]int = [5]int{1, 2, 3, 4, 5}
// 切片（Go的动态数组，自动管理内存）
slice := []int{1, 2, 3, 4, 5}
slice = append(slice, 6)
```

### 4. 面向对象编程

Go没有类和继承，但可以通过结构体和接口实现类似的功能：

#### 结构体与方法

C++:
```cpp
class Rectangle {
private:
    double width;
    double height;
public:
    Rectangle(double w, double h) : width(w), height(h) {}
    double area() const {
        return width * height;
    }
    void scale(double factor) {
        width *= factor;
        height *= factor;
    }
};

// 使用
Rectangle rect(10, 5);
std::cout << rect.area() << std::endl;
rect.scale(2);
```

Go:
```go
type Rectangle struct {
    Width  float64
    Height float64
}

// 值接收器方法
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// 指针接收器方法（可修改结构体）
func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

// 使用
rect := Rectangle{10, 5}
fmt.Println(rect.Area())
rect.Scale(2)
```

#### 接口实现

C++:
```cpp
class Shape {
public:
    virtual ~Shape() = default;
    virtual double area() const = 0;
};

class Circle : public Shape {
private:
    double radius;
public:
    Circle(double r) : radius(r) {}
    double area() const override {
        return 3.14 * radius * radius;
    }
};
```

Go:
```go
type Shape interface {
    Area() float64
}

type Circle struct {
    Radius float64
}

// 隐式实现Shape接口
func (c Circle) Area() float64 {
    return 3.14 * c.Radius * c.Radius
}
```

### 5. 并发编程

这是Go语言最强大的特性之一，相比C++的线程模型有很大不同：

C++:
```cpp
#include <thread>
#include <vector>
#include <iostream>

void printHello(int id) {
    std::cout << "Hello from thread " << id << std::endl;
}

int main() {
    std::vector<std::thread> threads;
    for (int i = 0; i < 5; i++) {
        threads.push_back(std::thread(printHello, i));
    }
    for (auto& t : threads) {
        t.join();
    }
    return 0;
}
```

Go:
```go
package main

import (
    "fmt"
    "time"
)

func printHello(id int) {
    fmt.Printf("Hello from goroutine %d\n", id)
}

func main() {
    // 启动5个goroutine
    for i := 0; i < 5; i++ {
        go printHello(i)  // 只需添加go关键字
    }
    
    // 等待goroutine完成（实际项目中应使用sync.WaitGroup）
    time.Sleep(time.Second)
}
```

#### 通道（Channel）

Go的通道提供了一种在goroutine之间安全传递数据的方式：

```go
func main() {
    // 创建一个整型通道
    ch := make(chan int)
    
    // 启动一个goroutine发送数据
    go func() {
        ch <- 42  // 发送数据到通道
    }()
    
    // 在主goroutine中接收数据
    value := <-ch  // 从通道接收数据
    fmt.Println("Received:", value)
    
    // 关闭通道
    close(ch)
}
```

### 6. 错误处理

Go使用返回值而不是异常来处理错误：

C++:
```cpp
try {
    if (b == 0) {
        throw std::runtime_error("Division by zero");
    }
    int result = a / b;
} catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
}
```

Go:
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}
```

### 7. 实用技巧

1. **使用Go的格式化工具**：`gofmt`或`go fmt`可以自动格式化代码，保持一致的代码风格

2. **使用Go模块管理依赖**：`go mod init`、`go get`、`go mod tidy`等命令

3. **使用`defer`进行资源清理**：替代C++中的RAII模式

4. **使用`go vet`检查代码问题**：静态代码分析工具

5. **使用接口进行抽象**：Go的接口是隐式的，更容易实现组合而非继承

6. **避免过度使用指针**：Go的垃圾回收器很高效，不必像C++那样频繁使用指针优化性能

7. **学习Go的标准库**：Go的标准库非常强大，涵盖了网络、文件操作、加密等多种功能

通过理解这些关键区别和转换技巧，C++程序员可以更快地适应Go语言的开发风格，并充分利用Go的简洁性和高效的并发模型。

## 安装和环境配置

Go语言的安装非常简单，以下是针对不同操作系统的基本安装步骤：

### Windows安装

1. 访问[Go官方下载页面](https://golang.org/dl/)下载Windows安装包
2. 运行安装包并按照提示完成安装
3. 安装完成后，打开命令提示符，输入`go version`验证安装是否成功

### Linux/Mac安装

```bash
# Linux (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install golang-go

# Mac (使用Homebrew)
brew install go

# 验证安装
go version
```

### 环境变量配置

安装完成后，建议配置以下环境变量：

1. **GOPATH**: Go的工作目录，用于存放代码和依赖
2. **GOROOT**: Go的安装目录（通常由安装程序自动设置）
3. **PATH**: 包含Go的bin目录，以便在任何位置执行Go命令

## Go模块管理

Go模块是Go 1.11版本引入的官方依赖管理工具，使用方法如下：

```bash
# 在项目目录初始化Go模块
go mod init myproject

# 添加依赖
go get github.com/pkg/errors

# 安装所有依赖
go mod tidy

# 构建项目
go build

# 运行项目
go run main.go
```

### Go模块的高级用法

```bash
# 查看当前模块的依赖图
go mod graph

# 查看指定包的详细信息
go list -m -json github.com/pkg/errors

# 升级依赖到最新版本
go get -u github.com/pkg/errors

# 升级依赖到指定版本
go get github.com/pkg/errors@v0.9.1

# 清理未使用的依赖
go mod tidy

# 验证依赖
go mod verify

# 创建vendor目录（包含所有依赖的副本）
go mod vendor

# 使用vendor目录构建
go build -mod=vendor
```

### go.mod文件详解

go.mod文件是Go模块的核心，包含了模块的基本信息和依赖声明：

```go
module github.com/user/myproject

go 1.17

require (
    github.com/pkg/errors v0.9.1
    github.com/sirupsen/logrus v1.8.1
)

require (
    github.com/davecgh/go-spew v1.1.1 // indirect
    github.com/pmezard/go-difflib v1.0.0 // indirect
    github.com/stretchr/testify v1.7.0 // indirect
    golang.org/x/sys v0.0.0-20211030050608-9e8e0b390896 // indirect
)
```

## Go语言的常见陷阱

### 1. 切片的共享底层数组

```go
package main

import "fmt"

func main() {
    s := []int{1, 2, 3, 4, 5}
    t := s[1:3]  // t和s共享底层数组
    t[0] = 100   // 修改t也会影响s
    fmt.Println(s)  // [1 100 3 4 5]
    fmt.Println(t)  // [100 3]
}
```

### 2. map的并发访问

```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    m := make(map[string]int)
    var wg sync.WaitGroup
    
    // 多个goroutine同时修改map会导致panic
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func(i int) {
            defer wg.Done()
            m[fmt.Sprintf("key%d", i)] = i
        }(i)
    }
    
    wg.Wait()
    fmt.Println(m)
}
```

解决方法：使用sync.Map或加锁保护

```go
// 使用sync.Map
var m sync.Map

// 使用互斥锁
var m = make(map[string]int)
var mu sync.Mutex

// 在访问map时加锁
mu.Lock()
m["key"] = value
mu.Unlock()
```

### 3. for循环中的闭包引用变量

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    for i := 0; i < 5; i++ {
        // 错误的写法：所有goroutine共享同一个i变量
        go func() {
            fmt.Println(i)  // 可能输出5个5，因为循环结束时i=5
        }()
    }
    
    time.Sleep(1 * time.Second)
    
    // 正确的写法：通过参数传递当前的i值
    for i := 0; i < 5; i++ {
        go func(i int) {
            fmt.Println(i)  // 输出0,1,2,3,4（顺序可能不同）
        }(i)
    }
    
    time.Sleep(1 * time.Second)
}
```

### 4. nil接口不等于nil指针

```go
package main

import "fmt"

func main() {
    var p *int = nil
    var i interface{} = p
    
    fmt.Println(p == nil)  // true
    fmt.Println(i == nil)  // false，因为i包含了类型信息(*int)
}
```

### 5. 指针作为值接收器与指针接收器的区别

```go
package main

import "fmt"

type Person struct {
    Name string
}

// 值接收器：会复制结构体
func (p Person) SetName1(name string) {
    p.Name = name  // 只会修改副本，不会影响原结构体
}

// 指针接收器：直接操作原结构体
func (p *Person) SetName2(name string) {
    p.Name = name  // 会修改原结构体
}

func main() {
    p := Person{Name: "张三"}
    p.SetName1("李四")
    fmt.Println(p.Name)  // 张三，没有变化
    
    p.SetName2("王五")
    fmt.Println(p.Name)  // 王五，发生了变化
}
```

## 空白标识符

空白标识符（_）在Go语言中有多种用途：

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // 1. 忽略导入包但不使用的警告
    _ = fmt.Println
    
    // 2. 忽略函数的返回值
    _ = os.Mkdir("test", 0755)
    
    // 3. 忽略多返回值中的某些值
    file, _ := os.Open("test.txt")  // 忽略错误
    if file != nil {
        defer file.Close()
    }
    
    // 4. 在for range中忽略索引或值
    numbers := []int{1, 2, 3, 4, 5}
    for _, v := range numbers {
        fmt.Println(v)  // 只关心值，不关心索引
    }
    
    // 5. 用于类型断言但只关心类型是否匹配
    var i interface{} = 42
    if _, ok := i.(int); ok {
        fmt.Println("i是int类型")
    }
}
```

## 数据类型

## 数据类型

值类型是 int、float、string、bool、struct和array，直接存储值，分配栈的内存空间，被函数调用完之后会释放。

引用类型是 slice、map、chan和值类型对应的指针，存储是一个地址（指针）,指针指向内存中真正存储数据的首地址，内存通常在堆分配，通过GC回收。

1. new 与 make 的区别

new 的参数要求传入一个类型，而不是一个值，它会申请该类型的内存大小空间，并初始化为对应的零值，返回该指向类型空间的一个指针。

make 也用于内存分配，但它只用于引用对象 slice、map、channel的内存创建，返回的类型是类型本身。

## 变量声明与初始化

Go语言有多种变量声明和初始化的方式：

```go
package main

import "fmt"

func main() {
    // 1. 标准声明（先声明后赋值）
    var a int
    a = 10
    
    // 2. 声明并初始化
    var b int = 20
    
    // 3. 类型推导（编译器自动推断类型）
    var c = 30
    
    // 4. 短变量声明（只能在函数内部使用）
    d := 40
    
    // 5. 多变量声明
    var e, f int = 50, 60
    var g, h = 70, "hello"
    i, j := 80, "world"
    
    // 6. 批量声明
    var (
        k int = 90
        l string = "Go"
        m bool = true
    )
    
    fmt.Println(a, b, c, d, e, f, g, h, i, j, k, l, m)
}
```

## 流程控制

### 条件语句

```go
package main

import "fmt"

func main() {
    // if语句
    age := 18
    if age >= 18 {
        fmt.Println("成年人")
    } else if age >= 6 {
        fmt.Println("未成年人")
    } else {
        fmt.Println("儿童")
    }
    
    // if语句可以包含一个初始化语句
    if score := 95; score >= 90 {
        fmt.Println("优秀")
    } else if score >= 80 {
        fmt.Println("良好")
    } else {
        fmt.Println("一般")
    }
}
```

### 循环语句

Go语言只有for一种循环结构，但可以实现多种循环方式：

```go
package main

import "fmt"

func main() {
    // 1. 标准for循环
    for i := 0; i < 5; i++ {
        fmt.Println(i)
    }
    
    // 2. for循环（类似while）
    j := 0
    for j < 5 {
        fmt.Println(j)
        j++
    }
    
    // 3. 无限循环
    /*
    for {
        fmt.Println("无限循环")
        break // 取消注释可以退出循环
    }
    */
    
    // 4. for range循环（遍历数组、切片、映射等）
    numbers := []int{1, 2, 3, 4, 5}
    for index, value := range numbers {
        fmt.Printf("索引: %d, 值: %d\n", index, value)
    }
}
```

## 基础语法

## 基础语语法

1. 当标识符（包括常量、变量、类型、函数名、结构字段等等）以一个大写字母开头，如：Group1，那么使用这种形式的标识符的对象就可以被外部包的代码所使用（客户端程序需要先导入这个包），这被称为导出（像面向对象语言中的 public）；标识符如果以小写字母开头，则对包外是不可见的，但是他们在整个包的内部是可见并且可用的（像面向对象语言中的 protected ）。
2. 第一行代码 package main 定义包名。你必须在源文件中非注释的第一行指明这个文件属于哪个包，如：package main。package main表示一个可独立执行的程序，每个 Go 应用程序都包含一个名为 main 的包。

3. Go 语言的字符串可以通过 + 实现
4. 常量定义：const identifier [type] = value

```go
package main

import "fmt"

func main() {
   const LENGTH int = 10
   const WIDTH int = 5  
   var area int
   const a, b, c = 1, false, "str" //多重赋值

   area = LENGTH * WIDTH
   fmt.Printf("面积为 : %d", area)
   println()
   println(a, b, c)  
}
```
5. iota，特殊常量，可以认为是一个可以被编译器修改的常量。iota 在 const关键字出现时将被重置为 0(const 内部的第一行之前)，const 中每新增一行常量声明将使 iota 计数一次(iota 可理解为 const 语句块中的行索引)。
6. select 是 Go 中的一个控制结构，类似于用于通信的 switch 语句。每个 case 必须是一个通信操作，要么是发送要么是接收。
7. go 语言函数可以返回多个值。
8. Go 语言切片是对数组的抽象。Go 数组的长度不可改变，在特定场景中这样的集合就不太适用，Go 中提供了一种灵活，功能强悍的内置类型切片("动态数组")，与数组相比切片的长度是不固定的，可以追加元素，在追加时可能使切片的容量增大。

## 错误处理

Go语言使用错误值而非异常来表示错误状态。错误类型是一个内置接口：

```go
// error接口定义
type error interface {
    Error() string
}

package main

import (
    "errors"
    "fmt"
)

// 自定义错误
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为零")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 0)
    if err != nil {
        fmt.Println("发生错误:", err)
    } else {
        fmt.Println("结果:", result)
    }
}
```

## 指针

指针是存储另一个变量内存地址的变量。Go语言的指针使用非常安全，不支持指针运算。

```go
package main

import "fmt"

func main() {
    // 声明变量
    a := 10
    
    // 声明指针变量
    var p *int
    p = &a // p指向a的内存地址
    
    // 短变量声明方式创建指针
    q := &a
    
    fmt.Println("a的值:", a)
    fmt.Println("a的地址:", &a)
    fmt.Println("p存储的地址:", p)
    fmt.Println("p指向的值:", *p) // 解引用操作
    
    // 通过指针修改值
    *p = 20
    fmt.Println("修改后a的值:", a)
    fmt.Println("q指向的值:", *q)
}
```

## 结构体

结构体是一种复合数据类型，它组合了零个或多个任意类型的命名变量。

```go
package main

import "fmt"

// 定义结构体
 type Person struct {
    Name string
    Age  int
    City string
}

func main() {
    // 创建结构体实例
    var p1 Person
    p1.Name = "张三"
    p1.Age = 30
    p1.City = "北京"
    
    // 使用键值对创建
    p2 := Person{
        Name: "李四",
        Age:  25,
        City: "上海",
    }
    
    // 使用位置初始化（注意顺序必须与结构体定义一致）
    p3 := Person{"王五", 35, "广州"}
    
    // 创建结构体指针
    p4 := &Person{"赵六", 40, "深圳"}
    
    fmt.Println(p1)
    fmt.Println(p2)
    fmt.Println(p3)
    fmt.Println(*p4)
    
    // 访问指针结构体的字段可以使用简化语法
    fmt.Println(p4.Name)
}
```

## 结构体方法

方法是与特定类型关联的函数，可以为结构体添加方法。

```go
package main

import "fmt"

// 定义结构体
 type Rectangle struct {
    Width, Height float64
}

// 定义结构体方法（接收器为值类型）
 func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// 定义结构体方法（接收器为指针类型，可以修改结构体的值）
 func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

func main() {
    rect := Rectangle{10, 5}
    fmt.Println("面积:", rect.Area()) // 调用值方法
    
    rect.Scale(2) // 调用指针方法，修改rect的值
    fmt.Println("缩放后的矩形:", rect)
    fmt.Println("缩放后的面积:", rect.Area())
}
```

## 接口

Go语言的接口是隐式实现的，不需要显式声明实现了哪个接口。只要一个类型拥有接口要求的所有方法，它就自动实现了该接口。

```go
package main

import "fmt"

// 定义接口
 type Shape interface {
    Area() float64
}

// 矩形结构体
 type Rectangle struct {
    Width  float64
    Height float64
}

// 圆结构体
 type Circle struct {
    Radius float64
}

// 矩形实现Area方法
 func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// 圆实现Area方法
 func (c Circle) Area() float64 {
    return 3.14 * c.Radius * c.Radius
}

// 计算形状面积的函数，接受任何实现了Shape接口的类型
 func PrintArea(s Shape) {
    fmt.Printf("面积是: %f\n", s.Area())
}

func main() {
    r := Rectangle{Width: 10, Height: 5}
    c := Circle{Radius: 3}
    
    PrintArea(r) // 输出: 面积是: 50.000000
    PrintArea(c) // 输出: 面积是: 28.260000
}
```

## 切片操作

切片是Go语言中非常重要的数据结构，以下是一些常用的切片操作：

```go
package main

import "fmt"

func main() {
    // 创建切片
    var s1 []int                  // 声明空切片
    s2 := []int{1, 2, 3, 4, 5}    // 直接初始化
    s3 := make([]int, 5)          // 使用make创建，长度为5
    s4 := make([]int, 5, 10)      // 使用make创建，长度为5，容量为10
    
    // 切片操作（左闭右开）
    s5 := s2[1:3]  // 包含索引1，不包含索引3，结果: [2 3]
    s6 := s2[2:]   // 从索引2到末尾，结果: [3 4 5]
    s7 := s2[:3]   // 从开头到索引3（不包含），结果: [1 2 3]
    
    // 追加元素
    s8 := append(s2, 6, 7, 8)  // 添加多个元素
    
    // 追加切片
    s9 := append(s8, s5...)    // 注意...语法
    
    // 复制切片
    src := []int{1, 2, 3}
    dst := make([]int, 3)
    copy(dst, src)
    
    fmt.Println("s1:", s1)
    fmt.Println("s2:", s2)
    fmt.Println("s3:", s3)
    fmt.Println("s4:", s4)
    fmt.Println("s5:", s5)
    fmt.Println("s6:", s6)
    fmt.Println("s7:", s7)
    fmt.Println("s8:", s8)
    fmt.Println("s9:", s9)
    fmt.Println("src:", src)
    fmt.Println("dst:", dst)
    
    // 获取切片长度和容量
    fmt.Println("s2长度:", len(s2), "容量:", cap(s2))
}
```

## 映射(Map)

映射是一种键值对数据结构，类似于其他语言中的字典或哈希表。

```go
package main

import "fmt"

func main() {
    // 创建映射
    var m1 map[string]int                     // 声明空映射（需要使用make初始化）
    m2 := make(map[string]int)                // 使用make创建映射
    m3 := map[string]int{                     // 直接初始化映射
        "apple":  5,
        "orange": 3,
        "banana": 7,
    }
    
    // 添加或更新元素
    m2["golang"] = 100
    m2["python"] = 80
    m3["pear"] = 2
    m3["apple"] = 10  // 更新已有元素
    
    // 获取元素
    fmt.Println("m2["golang"]:", m2["golang"])
    
    // 检查键是否存在
    value, exists := m2["java"]
    if exists {
        fmt.Println("java存在，值为:", value)
    } else {
        fmt.Println("java不存在")
    }
    
    // 删除元素
    delete(m3, "orange")
    
    // 遍历映射（顺序是随机的）
    for key, value := range m3 {
        fmt.Printf("%s: %d\n", key, value)
    }
    
    // 获取映射长度
    fmt.Println("m3长度:", len(m3))
}
```

## defer语句

defer语句用于延迟执行函数，通常用于资源清理、关闭文件等场景。

```go
package main

import "fmt"

func main() {
    // 基本使用
    defer fmt.Println("这是最后执行的")
    fmt.Println("这是先执行的")
    
    // 多个defer语句的执行顺序是后进先出(LIFO)
    defer fmt.Println("defer 1")
    defer fmt.Println("defer 2")
    defer fmt.Println("defer 3")
    
    // defer用于资源清理
    file := openFile("test.txt")
    defer closeFile(file)  // 确保文件会被关闭
    
    // 处理文件...
    
    // defer函数的参数在定义时就会求值
    x := 1
    defer fmt.Printf("x的值: %d\n", x)  // 这里会输出x的值: 1
    x = 100  // 后面的修改不会影响defer语句中的x值
}

func openFile(filename string) string {
    fmt.Printf("打开文件: %s\n", filename)
    return filename
}

func closeFile(filename string) {
    fmt.Printf("关闭文件: %s\n", filename)
}
```

## panic和recover

Go语言使用panic和recover机制来处理程序运行时的严重错误。

```go
package main

import "fmt"

func main() {
    // 使用defer和recover捕获panic
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("恢复程序", r)
        }
    }()
    
    // 故意触发panic
    divide(10, 0)
    
    // 下面的代码不会执行，除非panic被recover
    fmt.Println("程序继续执行")
}

func divide(a, b int) {
    if b == 0 {
        panic("除数不能为零") // 触发panic
    }
    fmt.Println("结果:", a/b)
}
```

## 并发

Go语言通过goroutine实现并发，goroutine是轻量级线程，由Go运行时管理。

```go
package main

import (
    "fmt"
    "time"
)

// 启动一个goroutine
func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    go say("world") // 启动一个新的goroutine
    say("hello")    // 当前goroutine执行
}
```

通道(channel)用于在goroutine之间传递数据，确保数据同步。

```go
package main

import "fmt"

func main() {
    // 创建一个整型通道
    ch := make(chan int)
    
    // 启动一个goroutine
    go func() {
        ch <- 42 // 发送数据到通道
    }()
    
    value := <-ch // 从通道接收数据
    fmt.Println("收到的数值:", value)
    
    // 关闭通道
    close(ch)
}
```

## 标准库的使用

Go语言有丰富的标准库，以下是一些常用标准库的使用示例：

### 字符串处理 (strings包)

```go
package main

import (
    "fmt"
    "strings"
)

func main() {
    s := "Hello, Go!"
    
    // 判断字符串是否包含子串
    fmt.Println(strings.Contains(s, "Go"))  // true
    
    // 统计子串出现次数
    fmt.Println(strings.Count(s, "l"))  // 2
    
    // 判断字符串是否以某前缀开头
    fmt.Println(strings.HasPrefix(s, "Hello"))  // true
    
    // 判断字符串是否以某后缀结尾
    fmt.Println(strings.HasSuffix(s, "!"))  // true
    
    // 查找子串位置
    fmt.Println(strings.Index(s, "Go"))  // 7
    
    // 替换子串
    fmt.Println(strings.Replace(s, "Go", "World", -1))  // Hello, World!
    
    // 分割字符串
    parts := strings.Split("a,b,c,d", ",")
    fmt.Println(parts)  // [a b c d]
    
    // 连接字符串
    joined := strings.Join(parts, "-")
    fmt.Println(joined)  // a-b-c-d
    
    // 转换大小写
    fmt.Println(strings.ToUpper(s))  // HELLO, GO!
    fmt.Println(strings.ToLower(s))  // hello, go!
}
```

### 文件操作 (os和io/ioutil包)

```go
package main

import (
    "fmt"
    "io/ioutil"
    "os"
)

func main() {
    // 创建文件
    file, err := os.Create("test.txt")
    if err != nil {
        fmt.Println("创建文件失败:", err)
        return
    }
    defer file.Close()
    
    // 写入内容
    file.WriteString("Hello, Go!")
    file.Sync()
    
    // 读取文件全部内容
    content, err := ioutil.ReadFile("test.txt")
    if err != nil {
        fmt.Println("读取文件失败:", err)
        return
    }
    fmt.Println("文件内容:", string(content))
    
    // 检查文件是否存在
    _, err = os.Stat("test.txt")
    if os.IsNotExist(err) {
        fmt.Println("文件不存在")
    } else {
        fmt.Println("文件存在")
    }
    
    // 删除文件
    err = os.Remove("test.txt")
    if err != nil {
        fmt.Println("删除文件失败:", err)
    }
}
```

### Context包 (用于控制goroutine的生命周期)

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // 创建一个带有取消功能的context
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()  // 确保在main函数退出时取消context
    
    // 启动一个goroutine
    go worker(ctx, "worker1")
    
    // 让程序运行一会儿
    time.Sleep(3 * time.Second)
    
    // 取消context，通知worker停止工作
    fmt.Println("取消任务")
    cancel()
    
    // 等待一会儿，让worker有时间响应取消信号
    time.Sleep(1 * time.Second)
    fmt.Println("程序退出")
}

// worker函数会监听context的取消信号
func worker(ctx context.Context, name string) {
    for {
        select {
        case <-ctx.Done():
            // 接收到取消信号
            fmt.Printf("%s: 收到取消信号，停止工作\n", name)
            return
        default:
            // 正常工作
            fmt.Printf("%s: 正在工作...\n", name)
            time.Sleep(1 * time.Second)
        }
    }
}
```

## 类型断言

类型断言用于检查接口值的具体类型，或者将接口值转换为指定类型。

```go
package main

import "fmt"

func main() {
    // 定义一个接口变量
    var i interface{}
    i = 42
    
    // 类型断言（带检查）
    value, ok := i.(int)
    if ok {
        fmt.Printf("i的类型是int，值为: %d\n", value)
    } else {
        fmt.Println("i的类型不是int")
    }
    
    // 类型断言（不带检查，失败会panic）
    // s := i.(string) // 这会引发panic
    
    // 使用switch进行类型断言
    i = "hello"
    switch v := i.(type) {
    case int:
        fmt.Printf("这是一个整数: %d\n", v)
    case string:
        fmt.Printf("这是一个字符串: %s\n", v)
    case bool:
        fmt.Printf("这是一个布尔值: %t\n", v)
    default:
        fmt.Printf("未知类型: %T\n", v)
    }
}
```

## 包结构

1. 权限：所有成员在包内均可见，无论是不是在一个源码文件中。但只有首字母大写的为可导出成员，在包外可见。
2. 源码必须使用UTF-8。
3. 包内每个源文件都可以定义一个或多个初始化函数，但编译器不保证执行顺序。编译器先初始化全局变量，然后才开始执行初始化函数。最后才执行main包的main函数。
4. 内部包：所有保存在internal目录下的包（包含自身）仅能被其父目录下的包（包含所有层次的子目录）访问。

## 反射

反射是指在程序运行时动态地获取变量的类型信息和值信息的能力。Go语言提供了reflect包来支持反射。

```go
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var x float64 = 3.4
    v := reflect.ValueOf(x)
    
    // 获取变量类型
    fmt.Println("类型:", v.Type())
    
    // 获取变量值
    fmt.Println("值:", v.Float())
    
    // 判断是否可以设置值（这里会返回false，因为v是x的副本）
    fmt.Println("可设置:", v.CanSet())
}
```

## 测试

Go语言内置了测试框架，通过go test命令运行测试。测试文件通常以_test.go结尾。

```go
// example.go
package example

func Add(a, b int) int {
    return a + b
}

// example_test.go
package example

import "testing"

func TestAdd(t *testing.T) {
    result := Add(1, 2)
    if result != 3 {
        t.Errorf("Add(1, 2) = %d; want 3", result)
    }
}
```

运行测试命令：

```bash
$ go test
```

---

## 泛型（Go 1.18+）

Go 1.18引入了泛型支持，这是Go语言最重要的新特性之一。

### 类型参数和类型约束

```go
package main

import "fmt"

// 类型约束：使用interface{}指定类型必须可比较
type Comparable interface {
    comparable
}

// 泛型函数：交换任意类型的两个值
func Swap[T any](a, b T) (T, T) {
    return b, a
}

// 泛型结构体
type Stack[T any] struct {
    items []T
}

func (s *Stack[T]) Push(item T) {
    s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() (T, bool) {
    if len(s.items) == 0 {
        var zero T
        return zero, false
    }
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}

// 泛型接口
type Container[T any] interface {
    Get() T
    Put(T)
}

// 类型约束：限制可以是哪些类型
type Number interface {
    int | int32 | int64 | float32 | float64
}

// 求和函数，只支持数值类型
func Sum[T Number](nums []T) T {
    var sum T
    for _, n := range nums {
        sum += n
    }
    return sum
}

func main() {
    // 泛型函数调用
    a, b := Swap(1, 2)
    fmt.Println("Swap:", a, b)

    str1, str2 := Swap("hello", "world")
    fmt.Println("Swap string:", str1, str2)

    // 泛型结构体使用
    stack := Stack[int]{}
    stack.Push(1)
    stack.Push(2)
    val, ok := stack.Pop()
    fmt.Println("Pop:", val, ok)

    // 泛型求和
    fmt.Println("Sum int:", Sum([]int{1, 2, 3}))
    fmt.Println("Sum float:", Sum([]float64{1.1, 2.2, 3.3}))
}
```

### 泛型使用场景

| 场景 | 示例 |
|------|------|
| 数据结构 | Stack, Queue, Tree, LinkedList |
| 算法 | Sort, Filter, Map |
| 容器 | Cache, Pool |
| 工具函数 | Swap, Min, Max |

---

## 错误处理进阶

Go 1.20+增强了错误处理，提供了错误链和错误组支持。

### 错误包装

```go
package main

import (
    "errors"
    "fmt"
)

// 错误包装
func readFile(filename string) error {
    return errors.New("file not found")
}

func processData(filename string) error {
    err := readFile(filename)
    if err != nil {
        return fmt.Errorf("processData failed: %w", err)
    }
    return nil
}

func main() {
    err := processData("test.txt")
    if err != nil {
        // errors.Is 检查错误链
        if errors.Is(err, errors.New("file not found")) {
            fmt.Println("文件不存在")
        }

        // errors.As 提取错误类型
        var pathErr *errors.PathError
        if errors.As(err, &pathErr) {
            fmt.Println("路径错误:", pathErr.Path)
        }

        fmt.Println("完整错误:", err)
    }
}
```

### 错误组（Go 1.20+）

```go
package main

import (
    "errors"
    "fmt"
    "slices"
)

func task1() error {
    return nil
}

func task2() error {
    return errors.New("task2 failed")
}

func task3() error {
    return nil
}

func main() {
    // 使用slices.Concurrent 执行多个任务
    errs := slices.Concurrently(false,
        task1,
        task2,
        task3,
    )

    // 合并错误
    combined := errors.Join(errs...)
    if combined != nil {
        fmt.Println("发生错误:", combined)
    }
}
```

### 自定义错误类型

```go
package main

import (
    "fmt"
    "time"
)

// 自定义错误类型
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

type NetworkError struct {
    Address string
    Cause   error
    Timeout time.Duration
}

func (e *NetworkError) Error() string {
    return fmt.Sprintf("network error to %s: %v (timeout: %v)",
        e.Address, e.Cause, e.Timeout)
}

func (e *NetworkError) Unwrap() error {
    return e.Cause
}

func validate(data string) error {
    if data == "" {
        return &ValidationError{Field: "data", Message: "cannot be empty"}
    }
    return nil
}

func connect(addr string) error {
    return &NetworkError{
        Address: addr,
        Cause:   errors.New("connection refused"),
        Timeout: 5 * time.Second,
    }
}

func main() {
    // 验证错误
    err := validate("")
    if err != nil {
        var ve *ValidationError
        if errors.As(err, &ve) {
            fmt.Printf("验证失败: %s - %s\n", ve.Field, ve.Message)
        }
    }

    // 网络错误
    err = connect("localhost:8080")
    var ne *NetworkError
    if errors.As(err, &ne) {
        fmt.Printf("网络错误: 地址=%s, 超时=%v\n", ne.Address, ne.Timeout)
    }
}
```

---

## 并发编程进阶

### Context包

Context用于在goroutine之间传递截止时间、取消信号和其他请求范围的值。

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func main() {
    // 创建带超时的context
    ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
    defer cancel()

    // 创建可取消的context
    ctx2, cancel2 := context.WithCancel(context.Background())

    // 模拟长时间运行的任务
    done := make(chan string)

    go func() {
        select {
        case <-ctx.Done():
            done <- "timeout"
        case <-ctx2.Done():
            done <- "cancelled"
        case <-time.After(5 * time.Second):
            done <- "completed"
        }
    }()

    // 在1秒后取消
    go func() {
        time.Sleep(1 * time.Second)
        cancel2()
    }()

    fmt.Println("Result:", <-done)
}
```

### sync包详解

```go
package main

import (
    "fmt"
    "sync"
    "sync/atomic"
    "time"
)

func syncExamples() {
    // WaitGroup：等待一组goroutine完成
    var wg sync.WaitGroup
    for i := 0; i < 3; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            fmt.Printf("Goroutine %d 完成\n", id)
        }(i)
    }
    wg.Wait()

    // Mutex：保护共享资源
    var mu sync.Mutex
    counter := 0
    for i := 0; i < 1000; i++ {
        go func() {
            mu.Lock()
            counter++
            mu.Unlock()
        }()
    }
    time.Sleep(time.Millisecond)
    fmt.Println("Counter:", counter)

    // RWMutex：读写锁，允许多个读操作并发
    var rwmu sync.RWMutex
    data := make(map[string]int)

    // 写操作
    rwmu.Lock()
    data["key"] = 100
    rwmu.Unlock()

    // 读操作（可以并发）
    rwmu.RLock()
    fmt.Println("Read:", data["key"])
    rwmu.RUnlock()

    // Once：只执行一次
    var once sync.Once
    for i := 0; i < 3; i++ {
        once.Do(func() {
            fmt.Println("Once: 只执行一次")
        })
    }

    // Pool：对象池，减少GC压力
    var pool sync.Pool
    pool.New = func() interface{} {
        return make([]byte, 1024)
    }

    buf := pool.Get().([]byte)
    defer pool.Put(buf)
    fmt.Println("Pool get:", len(buf))

    // Map：并发安全的map
    var concurrentMap sync.Map
    concurrentMap.Store("key1", "value1")
    val, ok := concurrentMap.Load("key1")
    fmt.Println("Map load:", val, ok)

    // Atomic：原子操作
    var atomicCounter int64
    atomic.AddInt64(&atomicCounter, 1)
    atomic.AddInt64(&atomicCounter, 2)
    fmt.Println("Atomic counter:", atomic.LoadInt64(&atomicCounter))
}
```

### Select语句

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    // 基本select：等待多个通道
    ch1 := make(chan string)
    ch2 := make(chan string)

    go func() {
        time.Sleep(time.Second)
        ch1 <- "通道1"
    }()

    go func() {
        time.Sleep(500 * time.Millisecond)
        ch2 <- "通道2"
    }()

    // 等待第一个完成的通道
    select {
    case msg := <-ch1:
        fmt.Println("收到:", msg)
    case msg := <-ch2:
        fmt.Println("收到:", msg)
    case <-time.After(100 * time.Millisecond):
        fmt.Println("超时")
    }

    // default case：非阻塞
    select {
    case msg := <-ch1:
        fmt.Println("收到:", msg)
    default:
        fmt.Println("没有数据")
    }
}
```

---

## 网络编程

### HTTP服务器

```go
package main

import (
    "encoding/json"
    "fmt"
    "net/http"
)

type Response struct {
    Message string `json:"message"`
    Status  int    `json:"status"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    json.NewEncoder(w).Encode(Response{Message: "OK", Status: 200})
}

func main() {
    // 注册处理器
    http.HandleFunc("/health", healthHandler)

    // 自定义ServeMux
    mux := http.NewServeMux()
    mux.HandleFunc("/api/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "API endpoint: %s", r.URL.Path)
    })

    // 中间件示例
    handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        fmt.Printf("Request: %s %s\n", r.Method, r.URL.Path)
        mux.ServeHTTP(w, r)
    })

    // 启动服务器
    fmt.Println("Server started on :8080")
    http.ListenAndServe(":8080", handler)
}
```

### HTTP客户端

```go
package main

import (
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "time"
)

type Post struct {
    UserID int    `json:"userId"`
    ID     int    `json:"id"`
    Title  string `json:"title"`
    Body   string `json:"body"`
}

func httpClientExample() {
    // 创建客户端
    client := &http.Client{
        Timeout: 10 * time.Second,
    }

    // GET请求
    resp, err := client.Get("https://jsonplaceholder.typicode.com/posts/1")
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer resp.Body.Close()

    body, _ := io.ReadAll(resp.Body)
    var post Post
    json.Unmarshal(body, &post)
    fmt.Printf("GET: %+v\n", post)

    // POST请求
    post2 := Post{UserID: 1, Title: "Test", Body: "Content"}
    jsonData, _ := json.Marshal(post2)
    resp, err = client.Post(
        "https://jsonplaceholder.typicode.com/posts",
        "application/json",
        nil,
    )
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer resp.Body.Close()
    fmt.Println("POST status:", resp.Status)
}
```

---

## JSON处理

```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name    string   `json:"name"`
    Age     int      `json:"age"`
    Email   string   `json:"email,omitempty"`
    Skills  []string `json:"skills"`
    Address Address  `json:"address"`
}

type Address struct {
    City    string `json:"city"`
    Country string `json:"country"`
}

func jsonExamples() {
    // 结构体转JSON
    person := Person{
        Name:   "张三",
        Age:    30,
        Skills: []string{"Go", "Python"},
        Address: Address{
            City:    "北京",
            Country: "中国",
        },
    }

    // Marshal
    jsonData, err := json.Marshal(person)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("JSON:", string(jsonData))

    // 格式化输出
    jsonData, _ = json.MarshalIndent(person, "", "  ")
    fmt.Println("Formatted JSON:", string(jsonData))

    // JSON转结构体
    jsonStr := `{"name":"李四","age":25,"skills":["Java","C++"],"address":{"city":"上海","country":"中国"}}`
    var person2 Person
    json.Unmarshal([]byte(jsonStr), &person2)
    fmt.Printf("Parsed: %+v\n", person2)

    // 使用map处理动态JSON
    var jsonMap map[string]interface{}
    json.Unmarshal([]byte(jsonStr), &jsonMap)
    fmt.Println("Map:", jsonMap)

    // 流式解码
    decoder := json.NewDecoder([]Reader(""))
    // for decoder.More() {
    //     decoder.Decode(&result)
    // }
}
```

---

## 依赖注入

Go语言中推荐使用构造函数和接口实现依赖注入。

```go
package main

import "fmt"

// 接口定义
type Logger interface {
    Log(msg string)
}

type Storage interface {
    Save(data string) error
}

// 具体实现
type ConsoleLogger struct{}

func (l ConsoleLogger) Log(msg string) {
    fmt.Println("LOG:", msg)
}

type FileStorage struct {
    filename string
}

func (f FileStorage) Save(data string) error {
    fmt.Println("Saving to file:", f.filename)
    return nil
}

// 服务使用接口
type Service struct {
    logger  Logger
    storage Storage
}

// 构造函数注入依赖
func NewService(logger Logger, storage Storage) *Service {
    return &Service{
        logger:  logger,
        storage: storage,
    }
}

func (s *Service) Process(data string) {
    s.logger.Log("Processing: " + data)
    s.storage.Save(data)
}

func main() {
    // 手动注入
    logger := ConsoleLogger{}
    storage := FileStorage{filename: "data.txt"}
    service := NewService(logger, storage)
    service.Process("test data")
}
```

---

## 设计模式实现

### 单例模式

```go
package main

import (
    "fmt"
    "sync"
)

// 懒汉式（线程安全）
type Singleton struct {
    data string
}

var (
    instance *Singleton
    once     sync.Once
)

func GetInstance() *Singleton {
    once.Do(func() {
        instance = &Singleton{data: "singleton"}
    })
    return instance
}

func main() {
    s1 := GetInstance()
    s2 := GetInstance()
    fmt.Println("Same instance:", s1 == s2)
}
```

### 工厂模式

```go
package main

import "fmt"

// 产品接口
type Product interface {
    Use() string
}

// 具体产品
type ConcreteProductA struct{}

func (p *ConcreteProductA) Use() string {
    return "Using Product A"
}

type ConcreteProductB struct{}

func (p *ConcreteProductB) Use() string {
    return "Using Product B"
}

// 工厂
type Factory struct{}

func (f *Factory) Create(productType string) Product {
    switch productType {
    case "A":
        return &ConcreteProductA{}
    case "B":
        return &ConcreteProductB{}
    default:
        return nil
    }
}

func main() {
    factory := &Factory{}
    productA := factory.Create("A")
    productB := factory.Create("B")
    fmt.Println(productA.Use())
    fmt.Println(productB.Use())
}
```

### 构建器模式

```go
package main

import "fmt"

type Builder interface {
    SetName(name string) Builder
    SetAge(age int) Builder
    SetCity(city string) Builder
    Build() *Person
}

type Person struct {
    Name string
    Age  int
    City string
}

type personBuilder struct {
    name string
    age  int
    city string
}

func (b *personBuilder) SetName(name string) Builder {
    b.name = name
    return b
}

func (b *personBuilder) SetAge(age int) Builder {
    b.age = age
    return b
}

func (b *personBuilder) SetCity(city string) Builder {
    b.city = city
    return b
}

func (b *personBuilder) Build() *Person {
    return &Person{
        Name: b.name,
        Age:  b.age,
        City: b.city,
    }
}

func newPersonBuilder() *personBuilder {
    return &personBuilder{}
}

func main() {
    person := newPersonBuilder().
        SetName("张三").
        SetAge(30).
        SetCity("北京").
        Build()
    fmt.Printf("%+v\n", person)
}
```

---

## 常用工具库推荐

| 类别 | 库名 | 用途 |
|------|------|------|
| Web框架 | Gin, Echo, Fiber | HTTP服务 |
| 数据库 | GORM, sqlx | ORM和SQL构建 |
| CLI | Cobra, Viper | 命令行工具 |
| 日志 | Zap, Logrus, zerolog | 高性能日志 |
| 配置 | Viper | 配置管理 |
| 验证 | go-playground/validator | 数据验证 |
| Redis | go-redis | Redis客户端 |
| gRPC | google.golang.org/grpc | RPC框架 |
| WebSocket | gorilla/websocket | WebSocket |
| UUID | google/uuid | UUID生成 |

### Gin框架示例

```go
package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()

    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{"message": "pong"})
    })

    r.POST("/users", func(c *gin.Context) {
        var user struct {
            Name string `json:"name" binding:"required"`
            Age  int    `json:"age"`
        }
        if err := c.ShouldBindJSON(&user); err != nil {
            c.JSON(400, gin.H{"error": err.Error()})
            return
        }
        c.JSON(200, gin.H{"user": user})
    })

    r.Run(":8080")
}
```

### Zap日志库示例

```go
package main

import (
    "go.uber.org/zap"
)

var logger *zap.Logger

func init() {
    var err error
    logger, err = zap.NewProduction()
    if err != nil {
        panic(err)
    }
    defer logger.Sync()
}

func main() {
    logger.Info("应用程序启动",
        zap.String("app", "myapp"),
        zap.Int("port", 8080),
    )

    logger.Error("发生错误",
        zap.String("error", "connection failed"),
    )
}
```

---

## 性能优化建议

### 1. 避免不必要的内存分配

```go
// 错误：每次调用都分配新切片
func badConcat(strs []string) string {
    result := ""
    for _, s := range strs {
        result += s
    }
    return result
}

// 正确：预分配容量
func goodConcat(strs []string) string {
    var builder strings.Builder
    builder.Grow(len(strs) * 10) // 预分配
    for _, s := range strs {
        builder.WriteString(s)
    }
    return builder.String()
}
```

### 2. 使用strings.Builder代替+

```go
// strings.Builder更高效
var b strings.Builder
b.WriteString("Hello")
b.WriteString(" ")
b.WriteString("World")
result := b.String()
```

### 3. 使用sync.Pool复用对象

```go
var bufferPool = sync.Pool{
    New: func() interface{} {
        return make([]byte, 1024)
    },
}

func process() {
    buf := bufferPool.Get().([]byte)
    defer bufferPool.Put(buf)
    // 使用buf
}
```

### 4. 避免反射，尽可能使用接口

```go
// 反射慢
func reflectCompare(a, b interface{}) bool {
    // 使用反射比较
    return false
}

// 接口快
func interfaceCompare(a, b int) bool {
    return a == b
}
```

---

## Go语言学习路线

### 入门阶段（1-2周）
- Go语法基础（变量、数据类型、控制流）
- 函数和错误处理
- 结构体和方法
- 接口

### 进阶阶段（2-4周）
- 切片和映射
- Goroutine和Channel
- 并发模式
- 错误处理进阶

### 高级阶段（1-2月）
- Go模块管理
- 测试和基准测试
- 反射和接口设计
- 性能优化

### 实战阶段（持续）
- Web开发（Gin/Echo）
- 数据库编程（GORM/sqlx）
- 微服务（gRPC、Docker、K8s）
- DevOps工具开发

---

## 总结

Go语言以其简洁、高效、并发友好的特点，成为现代服务端开发的重要选择。本文涵盖了Go语言的核心知识点：

| 模块 | 核心内容 |
|------|----------|
| 基础语法 | 变量、类型、流程控制、函数 |
| 高级特性 | 接口、泛型、错误处理 |
| 并发 | Goroutine、Channel、sync包、Context |
| 工具链 | go mod、go test、go fmt |
| 标准库 | IO、网络、JSON、时间和日期 |
| 生态系统 | Gin、GORM、Zap等常用库 |

掌握这些内容后，你将能够熟练使用Go语言进行开发。需要持续实践和阅读优秀开源项目的代码，不断提升技术水平。

Go语言的哲学是"简单、实用"，在学习过程中要注重实践，多写代码，多参与开源项目，才能真正掌握这门语言的精髓。
