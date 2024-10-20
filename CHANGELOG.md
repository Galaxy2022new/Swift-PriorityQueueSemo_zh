### 1.4.0
- 添加了带有大小限制的 push()，移除最低优先级项（感谢 @reedes）
- 添加了一些断言和测试（感谢 @vale-cocoa）

### 1.3.1
- pop() 性能改进（感谢 @peteraisher）
- 一些基本性能测试（感谢 @peteraisher）

### 1.3.0
- 支持 Swift 5

### 1.2.1
- 修复了 remove() 中的一个关键错误并添加了测试
- 重新组织项目以在 Linux 上进行测试
- 更新了 Package.swift 的格式，以符合 Swift 4

### 1.2.0
> 注意：1.2.0 是第一个与 Swift 2 和 Swift 3 的以前版本不兼容的 SwiftPriorityQueue版本。从这一点开始，使用 Swift 2 和 Swift 3 的用户应该使用 SwiftPriorityQueue 的 1.1.2 版本。

- 支持 Swift 4
- 移除了支持 Swift 2 的预处理器宏和代码

### 1.1.2
- 添加了接受自定义顺序函数的初始化器
- watchOS 添加到 podspec

### 1.1.1
- 添加了 remove(item: T) 方法，用于在任意位置移除一个项目
- 添加了 removeAll(item: T) 方法，用于移除多个相同项目

### 1.1.0
- 支持 Swift 3

### 1.0.3
- 仅 Swift 2 的最后一个版本
- 改进了单元测试

### 1.0.2
- 更好的 Swift 2 支持

### 1.0.1
- 访问控制错误修复
- 文档添加

### 1.0
- 初始稳定版本
- 支持 Swift 1.2 的最后一个版本
