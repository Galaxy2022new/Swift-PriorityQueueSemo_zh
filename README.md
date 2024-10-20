# SwiftPriorityQueue

[![Swift Versions](https://img.shields.io/badge/Swift-1%2C2%2C3%2C4%2C5-green.svg)](https://swift.org)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/SwiftPriorityQueue.svg)](https://cocoapods.org/pods/SwiftPriorityQueue)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/SwiftPriorityQueue.svg)](https://cocoapods.org/pods/SwiftPriorityQueue)
[![Linux Compatible](https://img.shields.io/badge/Linux-compatible-4BC51D.svg?style=flat)](https://swift.org)
[![Twitter Contact](https://img.shields.io/badge/contact-@davekopec-blue.svg?style=flat)](https://twitter.com/davekopec)

SwiftPriorityQueue 是一个纯粹的 Swift（不包含 Cocoa）实现的通用优先队列数据结构，适用于所有支持 Swift 的平台（如 macOS、iOS、Linux 等）。它具有简单的接口，并且可以使用任何实现了 `Comparable` 的类型。它使用元素之间的比较而不是单独的数值优先级来确定顺序。

在内部，SwiftPriorityQueue 使用经典的二叉堆，实现了 O(lg n) 的 push 和 pop 操作。它包括源代码中的文档、一个基于 A* 的示例迷宫解决程序（适用于 macOS）和单元测试（特别欢迎额外的单元测试的 pull 请求）。

## 特性
* 易于使用的接口
* 小巧、自包含、纯 Swift 代码库
* 经典的二叉堆实现，具有 O(lg n) 的 push 和 pop 操作
* 可通过标准 Swift for...in 循环进行迭代（实现 `Sequence` 和 `IteratorProtocol`）
* 源代码中的文档
* 一个有趣的基于 A* 的迷宫解决示例程序

## 安装

1.3.0 版本及以上支持 Swift 5。使用 1.2.1 版本支持 Swift 4。使用 1.1.2 版本支持 Swift 3 和 Swift 2。使用 1.0 版本支持 Swift 1.2。

### CocoaPods

使用 CocoaPod 的 `SwiftPriorityQueue`。

### Swift Package Manager (SPM)

将此仓库添加为依赖项。

### 手动

将 `SwiftPriorityQueue.swift` 复制到您的项目中。

## 文档
源代码中使用标准 Swift 文档技术（与 Jazzy 兼容）有大量文档。本质上，SwiftPriorityQueue 具有您期望的三个关键方法 - `push()`、`pop()` 和 `peek()`。

### 初始化
当您创建一个新的 `PriorityQueue` 时，您可以指定优先队列是升序还是降序。这意味着什么？如果优先队列是升序的，其最小的值（由它们的 `Comparable` 实现确定，即 `<`）将首先被弹出，如果它是降序的，其最大的值将首先被弹出。
```swift
var pq: PriorityQueue<String> = PriorityQueue<String>(ascending: true)
```
您还可以提供一个起始值数组，这些值将立即被顺序推入优先队列。
```swift
var pq: PriorityQueue<Int> = PriorityQueue<Int>(startingValues: [6, 2, 3, 235, 4, 500])
```
或者您可以同时指定两者。
```swift
var pq: PriorityQueue<Int> = PriorityQueue<Int>(ascending: false, startingValues: [6, 2, 3, 235, 4, 500])
```
或者您可以不指定任何内容。默认情况下，`PriorityQueue` 是降序且为空的。正如您可能注意到的，`PriorityQueue` 采用泛型类型。这种类型必须是 `Comparable`，因为它的比较将用于确定优先级。这意味着您的自定义类型必须实现 `Comparable` 并使用重写的 `<` 来确定优先级。

### 方法
`PriorityQueue` 具有所有标准方法，您期望优先队列数据结构具有。
* `push(element: T)` - 将元素放入优先队列。O(lg n)
* `push(element: T, maxCount: Int) -> T?` - 添加元素时限制优先队列的大小为 `maxCount`。如果添加后优先队列中的元素超过 `maxCount`，则最低优先级元素将被丢弃并返回。请注意，由于这是一个二叉堆，所以只有最高优先级项的检索是高效的。O(n)
* `pop() -> T?` - 返回并移除具有最高（或如果升序则为最低）优先级的元素，或者如果优先队列为空则返回 `nil`。O(lg n)
* `peek() -> T?` - 返回具有最高（或如果升序则为最低）优先级的元素，或者如果优先队列为空则返回 `nil`。O(1)
* `clear()` - 从优先队列中移除所有元素。
* `remove(item: T)` - 从优先队列中移除第一个找到的 *item* 实例。如果未找到则默默返回。O(n)
* `removeAll(item: T)` - 通过重复调用 `remove()` 从优先队列中移除所有 *item* 的实例。如果未找到则默默返回。

### 属性
* `count: Int` - 优先队列中的元素数量。
* `isEmpty: Bool` - 如果优先队列有零个元素，则为 `true`，否则为 `false`。

### 标准 Swift 协议
`PriorityQueue` 实现了 `IteratorProtocol`、`Sequence` 和 `Collection`，因此您可以像对待任何其他 Swift 序列/集合一样对待 `PriorityQueue`。这意味着您可以在 `PriorityQueue` 上使用 Swift 标准库函数，并且可以像这样迭代 `PriorityQueue`：
```swift
for item in pq {  // pq 是 PriorityQueue<String>
    print(item)
}
```
当您这样做时，`PriorityQueue` 中的每个项目都按顺序被弹出。`PriorityQueue` 还实现了 `CustomStringConvertible` 和 `CustomDebugStringConvertible`。
```swift
print(pq)
```
注意：`PriorityQueue` *不是* 线程安全的（不要一次在多个线程上操作它）。

### 有限堆大小示例

假设您只想在优先队列中保留 `maxCount` 最高优先级项。

例如，假设您只希望优先队列一次只有 4 个元素：

```swift
var pq: PriorityQueue<Int> = PriorityQueue<Int>()
let maxCount = 4

pq.push(4, maxCount: maxCount)
pq.push(5, maxCount: maxCount)
pq.push(0, maxCount: maxCount)
pq.push(3, maxCount: maxCount)  
pq.push(6, maxCount: maxCount)     
pq.push(1, maxCount: maxCount)     
```

在这种情况下，推入 4 个元素后，只保留了最小的元素（因为顺序是 `ascending`）。所以，最终的优先队列中有 0, 1, 3, 4 这几个元素。

### 仅供娱乐 - A* (`astar.swift`)
A* 是一个使用优先队列的路径查找算法。随 SwiftPriorityQueue 附带的示例程序是一个使用 A* 的迷宫求解器。如果您想在 `astar.swift` 中重用此算法，您可以在源代码中找到一些文档。

## 作者ship & 许可证
SwiftPriorityQueue 由 David Kopec (@davecom 在 GitHub) 编写，并在 MIT 许可证下发布（见 `LICENSE`）。您可以在我的 GitHub 配置文件页面上找到我的联系信息。我鼓励您在 GitHub 上提交 pull 请求和开问题。感谢多年来的所有贡献者。
