//
//  astar.swift
//  SwiftPriorityQueue
//
//  Created by Robert on 2024/10/20.
//  Copyright © 2024 Oak Snow Consulting. All rights reserved.
//

import Foundation

// A* 算法的节点类，用于表示每一个搜索的节点
class AStarNode: Comparable, Hashable {
    var point: Point    // 该节点在迷宫中的位置
    var gCost: Float    // 从起点到该节点的代价
    var hCost: Float    // 从该节点到目标的启发式代价（曼哈顿距离）
    var fCost: Float { return gCost + hCost } // 总代价，fCost = gCost + hCost
    var parent: AStarNode?  // 该节点的父节点，用于回溯路径


    // 初始化节点
    init(point: Point, gCost: Float, hCost: Float, parent: AStarNode? = nil) {
        self.point = point
        self.gCost = gCost
        self.hCost = hCost
        self.parent = parent
    }

    // Hashable 协议
    func hash(into hasher: inout Hasher) {
        hasher.combine(point)
    }

    // 比较两个节点，fCost 小的优先
    static func < (lhs: AStarNode, rhs: AStarNode) -> Bool {
        return lhs.fCost < rhs.fCost
    }

    // 比较两个节点是否相等
    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
        return lhs.point == rhs.point
    }
}

// A* 算法的实现
func astar(_ start: Point, goalTestFn: (Point) -> Bool, successorFn: (Point) -> [Point], heuristicFn: (Point) -> Float) -> [Point]? {
    var openList = PriorityQueue<AStarNode>(ascending: true) // 优先队列用于存储待探索的节点
    var closedList: Set<Point> = [] // 存储已经探索过的节点
    
    // 将起点节点加入优先队列
    let startNode = AStarNode(point: start, gCost: 0, hCost: heuristicFn(start))
    openList.push(startNode)

    // 开始搜索
    while let currentNode = openList.pop() {
        if goalTestFn(currentNode.point) {
            // 如果当前节点是目标，回溯路径并返回
            var path: [Point] = []
            var node: AStarNode? = currentNode
            while let currentNode = node {
                path.append(currentNode.point)
                node = currentNode.parent
            }
            return path.reversed() // 返回反向路径
        }

        // 将当前节点标记为已探索
        closedList.insert(currentNode.point)
        
        // 遍历后继节点
        for successor in successorFn(currentNode.point) {
            if closedList.contains(successor) { continue } // 如果后继节点已探索，跳过

            // 计算后继节点的代价
            let tentativeGCost = currentNode.gCost + 1 // 假设代价为1（可以根据需求调整）
            let hCost = heuristicFn(successor)
            
            if let existingNode = openList.heap.first(where: { $0.point == successor }) {
                // 如果该节点已在开放列表中，且新的代价更小，更新该节点
                if tentativeGCost < existingNode.gCost {
                    existingNode.gCost = tentativeGCost
                    existingNode.parent = currentNode
                }
            } else {
                // 如果该节点不在开放列表中，将其加入
                let successorNode = AStarNode(point: successor, gCost: tentativeGCost, hCost: hCost, parent: currentNode)
                openList.push(successorNode)
            }
        }
    }

    return nil // 如果找不到路径，返回 nil
}
