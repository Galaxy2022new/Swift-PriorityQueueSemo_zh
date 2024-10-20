//
//  AppDelegate.swift
//  MazeSolver
//
//  Created by Robert on 2024/10/20.
//  Copyright © 2024 Oak Snow Consulting. All rights reserved.
//
//  这是一个使用 A* 算法通过 SwiftPriorityQueue 的迷宫搜索示例
//  该文件包含应用程序的入口和主要的视图控制逻辑
//

import Cocoa

// Cell 枚举表示迷宫中的一个网格位置
enum Cell {
    case empty      // 空单元格
    case blocked    // 被阻塞的单元格
    case start      // 起点
    case goal       // 目标
    case path       // 路径

    // 根据单元格类型返回对应的颜色
    func color() -> CGColor {
        switch self {
        case .empty: return NSColor.white.cgColor
        case .blocked: return NSColor.black.cgColor
        case .start: return NSColor.green.cgColor
        case .goal: return NSColor.red.cgColor
        case .path: return NSColor.yellow.cgColor
        }
    }
}

// Point 结构体表示迷宫中单元格的行和列
struct Point: Hashable {
    let x: Int // 行
    let y: Int // 列
}

// MazeView 类用于绘制和管理迷宫视图
class MazeView: NSView {
    let NUM_ROWS: Int = 20
    let NUM_COLS: Int = 20
    var hasStart: Bool = false // 是否已经设置起点
    var start: Point = Point(x: -1, y: -1) // 起点的位置
    var goal: Point = Point(x: -1, y: -1) // 目标的位置
    var path: [Point] = [] // 迷宫中的路径
    var position: [[Cell]] = Array(repeating: Array(repeating: .empty, count: 20), count: 20) // 迷宫的状态
    var cellLayers: [[CALayer]] = [] // 单元格的图层

    // 初始化单元格
    override func awakeFromNib() {
        wantsLayer = true // 允许使用图层
        let width: CGFloat = self.bounds.size.width // 视图宽度
        let height: CGFloat = self.bounds.size.height // 视图高度
        
        // 初始化每个单元格
        for i in 0..<NUM_ROWS {
            cellLayers.append([]) // 为每一行创建一个空的图层数组
            for j in 0..<NUM_COLS {
                let temp: CALayer = CALayer() // 创建一个新的图层
                let cell: Cell = arc4random_uniform(5) == 0 ? .blocked : .empty  // 随机阻塞生成
                position[i][j] = cell // 更新位置状态
                temp.borderColor = NSColor.purple.cgColor // 单元格边框颜色
                temp.backgroundColor = cell.color() // 单元格背景颜色
                temp.frame = CGRect(x: CGFloat(j) * (width / CGFloat(NUM_COLS)), // 设置单元格位置
                                    y: CGFloat(i) * (height / CGFloat(NUM_ROWS)),
                                    width: (width / CGFloat(NUM_COLS)),
                                    height: (height / CGFloat(NUM_ROWS)))
                layer?.addSublayer(temp) // 将单元格图层添加到视图层中
                cellLayers[i].append(temp) // 将单元格图层存储到 cellLayers 中
            }
        }
    }
    
    // 当鼠标点击时，放置起点和目标单元格，然后进行 A* 搜索
    override func mouseDown(with theEvent: NSEvent) {
        let width: CGFloat = self.bounds.size.width // 视图宽度
        let height: CGFloat = self.bounds.size.height // 视图高度
        let mousePlace: NSPoint = self.convert(theEvent.locationInWindow, from: nil) // 获取鼠标位置
        let col: Int = Int(mousePlace.x / (width / CGFloat(NUM_COLS))) // 计算点击的列
        let row: Int = Int(mousePlace.y / (height / CGFloat(NUM_ROWS))) // 计算点击的行
        
        // 只能在空单元格上点击
        if position[row][col] != .empty { return }
        
        // 更新单元格的颜色并添加动画
        func updateCell(at point: Point, to cell: Cell, duration: Double = 0.5) {
            position[point.x][point.y] = cell
            CATransaction.begin()
            CATransaction.setValue(NSNumber(value: duration), forKey: kCATransactionAnimationDuration)
            cellLayers[point.x][point.y].backgroundColor = position[point.x][point.y].color()
            CATransaction.commit()
        }
        
        if !hasStart {
            // 设定起点
            if start.x != -1 {
                position[start.x][start.y] = .empty // 清空之前的起点
                position[goal.x][goal.y] = .empty // 清空之前的终点
                cellLayers[start.x][start.y].backgroundColor = position[start.x][start.y].color() // 更新图层颜色
                cellLayers[goal.x][goal.y].backgroundColor = position[goal.x][goal.y].color()
            }
            for p in path {  // 清除之前的路径
                if p != start && p != goal {
                    updateCell(at: p, to: .empty)
                }
            }
            // 设定起点
            updateCell(at: Point(x: row, y: col), to: .start)
            hasStart = true // 更新起点设置状态
            start = Point(x: row, y: col) // 更新起点坐标
        } else {
            // 设定目标
            updateCell(at: Point(x: row, y: col), to: .goal)
            hasStart = false // 更新起点设置状态
            goal = Point(x: row, y: col) // 更新目标坐标
            
            // 找路径
            func goalTest(_ x: Point) -> Bool {
                return x == goal // 检查是否到达目标
            }
            
            // 计算当前单元格的后继单元格（只能上下左右移动）创建一个包含移动方向的数组来进行多个边界检查
            func successors(_ p: Point) -> [Point] {
                let moves = [(1, 0), (-1, 0), (0, 1), (0, -1)] // 下、上、右、左的移动方向
                return moves.compactMap { (dx, dy) in
                    let newX = p.x + dx
                    let newY = p.y + dy
                    return (newX >= 0 && newX < NUM_ROWS && newY >= 0 && newY < NUM_COLS && position[newX][newY] != .blocked) ? Point(x: newX, y: newY) : nil
                }
            }
            
            // 启发式函数：计算当前单元格到目标单元格的曼哈顿距离
            func heuristic(_ p: Point) -> Float {
                let xdist = abs(p.x - goal.x) // x 方向的距离
                let ydist = abs(p.y - goal.y) // y 方向的距离
                return Float(xdist + ydist) // 返回总距离
            }
            
            // 使用 A* 算法查找路径
            if let pathResult = astar(start, goalTestFn: goalTest, successorFn: successors, heuristicFn: heuristic) {
                path = pathResult // 更新路径
                for p in path { // 遍历路径
                    if p != start && p != goal {
                        updateCell(at: p, to: .path)
                    }
                }
            }
        }
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow! // 窗口引用
    // 应用程序启动后执行
    func applicationDidFinishLaunching(_ aNotification: Notification) {}
    // 应用程序即将终止时执行
    func applicationWillTerminate(_ aNotification: Notification) {}
}
