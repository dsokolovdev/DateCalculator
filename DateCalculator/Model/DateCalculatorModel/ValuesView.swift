//
//  ValueView.swift
//  DateCalculator
//
//  Created by Dmitri  on 24.10.25.
//

import UIKit

final class ValuesView: UIView, LayoutDisplayable {

    // MARK: - Public Properties
    var layoutType: LayoutType = .row { didSet { refreshLayout() } }
    
    // MARK: - Private Properties
    private var segments: [String] = [] //{ didSet { refreshLayout() } }
    private var segmentIndex: Int = 0 //{ didSet { refreshLayout() } }
    private var startDate: Date?
    private var endDate: Date?
    
    private var valueLabels = [[UILabel]]()
    private var rows: Int = 1
    private var hasLaidOutOnce = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !segments.isEmpty else { return }
        
        updateLablesConstraints()
        
        if !hasLaidOutOnce {
            hasLaidOutOnce = true
            refreshLayout()
        }
    }
    
    // MARK: - Public API
    /// Принудительно обновить layout (например, если хочешь обновить значения)
    func refreshLayout() {
        guard !segments.isEmpty else { return }
        updateLabels()
        updateViews()
        updateLabelsValues()
        updateLabelsColor()
    }
    
    func updateDates(from start: Date, to end: Date) {
        startDate = start
        endDate = end
        updateLabelsValues()
    }
}
//MARK: - Delegate
extension ValuesView: ValuesViewUpdatable {
    func updateValues(segments: [String], selectedIndex: Int, from start: Date, to end: Date) {
        let shouldRefresh = self.segments != segments || self.segmentIndex != selectedIndex
        
        self.segments = segments
        self.segmentIndex = selectedIndex
        self.startDate = start
        self.endDate = end
        
        refreshLayout()
//        if shouldRefresh {
//            refreshLayout()        // пересоздаём лейблы и стек
//        } else {
//            updateLabelsValues()   // просто обновляем цифры
//        }
        
        print("ValuesView - Delegate: segmentIndex:\(segmentIndex)")

        //self.updateDates(from: start, to: end)
    }
}

//MARK: - View
extension ValuesView {
    private func setupAppearance() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
}

//MARK: - SubView
extension ValuesView {
    private func updateViews() {
        subviews.forEach { $0.removeFromSuperview() }
        
        switch layoutType {
        case .row:
            let hStack = makeHStack(labels: valueLabels.first ?? [])
            addNewSubview(hStack)
            
        case .grid:
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.alignment = .fill
            vStack.distribution = .fillEqually
            vStack.spacing = 2
            
            for rowLabels in valueLabels {
                let hStack = makeHStack(labels: rowLabels)
                vStack.addArrangedSubview(hStack)
            }
            addNewSubview(vStack)
        }
    }
    
    private func makeHStack(labels: [UILabel]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: labels)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }
    
    private func addNewSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Lables
extension ValuesView {
    
    private func updateLabels() {
        valueLabels.removeAll()
        rows = layoutType == .row ? 1 : segments.count
        let fontSize = (max: 30.0, min: 18.0)
        let size = layoutType == .row ? 30 : fontSize.max - (fontSize.max - fontSize.min)/4 * Double(segments.count)
        let labelCount = layoutType == .row ? segments.count - segmentIndex : segments.count
        
        for row in 0..<rows {
            var rowLabels: [UILabel] = []
            for space in 0..<labelCount - row {
                let label = UILabel()
                //label.text = "0"
                label.textAlignment = .right
                label.textColor = .secondaryLabel
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.8
                label.font = .systemFont(ofSize: size, weight: .medium)
                
//                if space > 0 {
//                    updateConstraintsfor(label: label)
//                }
                
                rowLabels.append(label)
            }
            valueLabels.append(rowLabels)
        }
    }
    
    private func updateLablesConstraints() {
        let spacing: CGFloat = 8
        let segmentWidth = (bounds.width - spacing * 2) / CGFloat(segments.count)
        for row in valueLabels {
            for (index, label) in row.enumerated() {
                if index > 0 {
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.widthAnchor.constraint(equalToConstant: segmentWidth).isActive = true
                }
            }
        }
    }
    
    private func updateLabelsColor() {
        if layoutType == .row {
            valueLabels[0][0].textColor = .label
        } else if layoutType == .grid {
            print(segmentIndex)
            valueLabels[segmentIndex][0].textColor = .label
            
        }
    }

    private func updateLabelsValues(){
        guard let startDate, let endDate else { return }
        if layoutType == .row {
            if segments.count == 4 {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYMWD)
                    let values = [
                        "\(diff.year ?? 0)",
                        "\(diff.month ?? 0)",
                        "\(diff.weekOfMonth ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cMWD)
                    let values = [
                        "\(diff.month ?? 0)",
                        "\(diff.weekOfMonth ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cWD)
                    let values = [
                        "\(diff.weekOfYear ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 3:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 3 && segments[1] == "Month" {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYMD)
                    let values = [
                        "\(diff.year ?? 0)",
                        "\(diff.month ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cMD)
                    let values = [
                        "\(diff.month ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 3 && segments[1] == "Week" {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYWD)
                    let values = [
                        "\(diff.year ?? 0)",
                        "\(diff.weekOfYear ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cWD)
                    let values = [
                        "\(diff.weekOfYear ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 2 {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYD)
                    let values = [
                        "\(diff.year ?? 0)",
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [
                        "\(diff.day ?? 0)"
                    ]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            }
        } else if layoutType == .grid {
            var values = [[String]]()
            if segments.count == 4 {
                let diff0 = startDate.getDifference(to: endDate, components: .cYMWD)
                let values0 = [
                    "\(diff0.year ?? 0)",
                    "\(diff0.month ?? 0)",
                    "\(diff0.weekOfMonth ?? 0)",
                    "\(diff0.day ?? 0)"
                ]
                values.append(values0)
                
                let diff1 = startDate.getDifference(to: endDate, components: .cMWD)
                let values1 = [
                    "\(diff1.month ?? 0)",
                    "\(diff1.weekOfMonth ?? 0)",
                    "\(diff1.day ?? 0)"
                ]
                values.append(values1)
                
                let diff2 = startDate.getDifference(to: endDate, components: .cWD)
                let values2 = [
                    "\(diff2.weekOfYear ?? 0)",
                    "\(diff2.day ?? 0)"
                ]
                values.append(values2)
                
                let diff3 = startDate.getDifference(to: endDate, components: .cD)
                let values3 = [
                    "\(diff3.day ?? 0)"
                ]
                values.append(values3)
                
                for (rowIndex, rowLable) in valueLabels.enumerated() where rowIndex < values.count {
                    for (colIndex, label) in rowLable.enumerated() where colIndex < values[rowIndex].count {
                        label.text = values[rowIndex][colIndex]
                    }
                }
            } else if segments.count == 3 && segments[1] == "Month" {
                let diff0 = startDate.getDifference(to: endDate, components: .cYMD)
                let values0 = [
                    "\(diff0.year ?? 0)",
                    "\(diff0.month ?? 0)",
                    "\(diff0.day ?? 0)"
                ]
                values.append(values0)
                
                let diff1 = startDate.getDifference(to: endDate, components: .cMD)
                let values1 = [
                    "\(diff1.month ?? 0)",
                    "\(diff1.day ?? 0)"
                ]
                values.append(values1)
                
                let diff2 = startDate.getDifference(to: endDate, components: .cD)
                let values2 = [
                    "\(diff2.day ?? 0)"
                ]
                values.append(values2)
                
                for (rowIndex, rowLable) in valueLabels.enumerated() where rowIndex < values.count {
                    for (colIndex, label) in rowLable.enumerated() where colIndex < values[rowIndex].count {
                        label.text = values[rowIndex][colIndex]
                    }
                }
            } else if segments.count == 3 && segments[1] == "Week" {
                let diff0 = startDate.getDifference(to: endDate, components: .cYWD)
                let values0 = [
                    "\(diff0.year ?? 0)",
                    "\(diff0.weekOfYear ?? 0)",
                    "\(diff0.day ?? 0)"
                ]
                values.append(values0)
                
                let diff1 = startDate.getDifference(to: endDate, components: .cWD)
                let values1 = [
                    "\(diff1.weekOfYear ?? 0)",
                    "\(diff1.day ?? 0)"
                ]
                values.append(values1)
                
                let diff2 = startDate.getDifference(to: endDate, components: .cD)
                let values2 = [
                    "\(diff2.day ?? 0)"
                ]
                values.append(values2)
                
                for (rowIndex, rowLable) in valueLabels.enumerated() where rowIndex < values.count {
                    for (colIndex, label) in rowLable.enumerated() where colIndex < values[rowIndex].count {
                        label.text = values[rowIndex][colIndex]
                    }
                }
            } else if segments.count == 2 {
                let diff0 = startDate.getDifference(to: endDate, components: .cYD)
                let values0 = [
                    "\(diff0.year ?? 0)",
                    "\(diff0.day ?? 0)"
                ]
                values.append(values0)
                
                let diff1 = startDate.getDifference(to: endDate, components: .cD)
                let values1 = [
                    "\(diff1.day ?? 0)"
                ]
                values.append(values1)
                
                for (rowIndex, rowLable) in valueLabels.enumerated() where rowIndex < values.count {
                    for (colIndex, label) in rowLable.enumerated() where colIndex < values[rowIndex].count {
                        label.text = values[rowIndex][colIndex]
                    }
                }
            }
        }
    }
}
