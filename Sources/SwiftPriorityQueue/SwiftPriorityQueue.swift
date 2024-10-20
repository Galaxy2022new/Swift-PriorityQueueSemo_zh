//
//  SwiftPriorityQueue.swift
//  SwiftPriorityQueue
//
//  Created by Robert on 2024/10/20.
//  Copyright © 2024 Oak Snow Consulting. All rights reserved.
//
//  这是一个通用的优先队列实现，采用二叉堆结构
//  该文件实现了一个支持泛型的优先队列，适用于所有支持 Swift 的平台
//

public struct PriorityQueue<T: Comparable> {
    
    /// 存储堆元素的数组
    fileprivate(set) var heap = [T]()
    
    /// 用于决定元素顺序的比较函数
    private let ordered: (T, T) -> Bool
    
    /// 初始化优先队列
    /// - Parameters:
    ///   - ascending: 是否升序排列，默认为 false（降序）
    ///   - startingValues: 初始值数组，默认为空
    public init(ascending: Bool = false, startingValues: [T] = []) {
        self.ordered = ascending ? { $0 > $1 } : { $0 < $1 }
        self.heap = startingValues
        for i in stride(from: heap.count / 2 - 1, through: 0, by: -1) {
            sink(i)
        }
    }
    
    /// 返回堆中元素的数量
    public var count: Int { return heap.count }
    
    /// 检查堆是否为空
    public var isEmpty: Bool { return heap.isEmpty }
    
    /// 向优先队列中添加一个元素
    /// - Parameter element: 要添加的元素
    public mutating func push(_ element: T) {
        heap.append(element)
        swim(heap.count - 1)
    }
    
    /// 向优先队列中添加一个元素，限制最大元素数量
    /// - Parameters:
    ///   - element: 要添加的元素
    ///   - maxCount: 堆中允许的最大元素数量
    /// - Returns: 如果元素被替换，返回被替换的元素，否则返回 nil
    public mutating func push(_ element: T, maxCount: Int) -> T? {
        precondition(maxCount > 0)
        if count >= maxCount, let discard = heap.max(by: ordered), ordered(discard, element) {
            return element
        }
        push(element)
        return count > maxCount ? pop() : nil
    }

    /// 移除并返回优先队列中的最高优先级元素
    /// - Returns: 被移除的元素，如果队列为空则返回 nil
    public mutating func pop() -> T? {
        guard !heap.isEmpty else { return nil }
        let lastElement = heap.removeLast()
        if heap.isEmpty { return lastElement }
        let firstElement = heap[0]
        heap[0] = lastElement
        sink(0)
        return firstElement
    }
    
    /// 移除指定的元素
    /// - Parameter item: 要移除的元素
    public mutating func remove(_ item: T) {
        guard let index = heap.firstIndex(of: item) else { return }
        heap.swapAt(index, heap.count - 1)
        heap.removeLast()
        sink(index)
        swim(index)
    }
    
    /// 移除所有指定的元素
    /// - Parameter item: 要移除的元素
    public mutating func removeAll(_ item: T) {
        heap.removeAll { $0 == item }
        for i in stride(from: heap.count / 2 - 1, through: 0, by: -1) {
            sink(i)
        }
    }
    
    /// 返回堆顶元素，但不移除
    /// - Returns: 堆顶元素，如果堆为空则返回 nil
    public func peek() -> T? {
        return heap.first
    }
    
    /// 清空优先队列
    public mutating func clear() {
        heap.removeAll(keepingCapacity: false)
    }
    
    /// 下沉操作，从给定索引开始向下调整堆
    /// - Parameter index: 要下沉的元素索引
    private mutating func sink(_ index: Int) {
        var index = index
        while let j = largerChild(of: index), ordered(heap[index], heap[j]) {
            heap.swapAt(index, j)
            index = j
        }
    }
    
    /// 上浮操作，从给定索引开始向上调整堆
    /// - Parameter index: 要上浮的元素索引
    private mutating func swim(_ index: Int) {
        var index = index
        while index > 0, ordered(heap[parent(of: index)], heap[index]) {
            heap.swapAt(parent(of: index), index)
            index = parent(of: index)
        }
    }
    
    private func parent(of index: Int) -> Int {
        return (index - 1) / 2
    }

    private func largerChild(of index: Int) -> Int? {
        let left = 2 * index + 1
        let right = left + 1
        guard left < heap.count else { return nil }
        return (right < heap.count && ordered(heap[left], heap[right])) ? right : left
    }
}

// 遍历协议实现
extension PriorityQueue: Sequence, IteratorProtocol {
    public typealias Element = T
    public mutating func next() -> Element? { return pop() }
}
