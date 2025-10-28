//
//  ValueView.swift
//  DateCalculator
//
//  Created by Dmitri  on 24.10.25.
//

import UIKit

//MARK: - Values View
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
    private let directionIcon = UIImageView()
    private let directionView = UIView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupDirectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
        setupDirectionView()
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
        
        //refreshLayout()
        if shouldRefresh {
            refreshLayout()        // пересоздаём лейблы и стек
        } else {
            updateLabelsValues()   // просто обновляем цифры
        }
        
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
        //subviews.forEach { $0.removeFromSuperview() }
        subviews.filter { $0 != directionView }.forEach { $0.removeFromSuperview() }
        
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
        stack.spacing = 2
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
            for _ in 0..<labelCount - row {
                let label = AnimatedLabel()
                //label.text = "0"
                label.textAlignment = .right
                label.textColor = UIColor.label.withAlphaComponent(0.6)
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
            valueLabels[0][0].textColor = C.mazarineBlue//UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.00)
        } else if layoutType == .grid {
            
            valueLabels[segmentIndex][0].textColor = C.mazarineBlue
            for (rowIndex, rowLables) in valueLabels.enumerated() {
                for label in rowLables where rowIndex != segmentIndex {
                    label.textColor = UIColor.secondaryLabel.withAlphaComponent(0.5)
                }
            }
            
        }
    }

//    private func updateLabelsValues() {
//        guard let startDate, let endDate else { return }
//        updateDirectionIcon()
//        // вспомогательный короткий форматтер
//        func f(_ value: Int?) -> String {
//            guard let v = value else { return "0" }
//            return abs(v).formatted(.number)
//        }
//        
//        func animateLabelTextChange(_ label: UILabel, newText: String) {
//            guard label.text != newText else { return }
//            UIView.transition(with: label, duration: 0.25, options: [.transitionCrossDissolve, .allowUserInteraction], animations: { label.text = newText }, completion: nil)
//        }
//        
//        if layoutType == .row {
//            if segments.count == 4 {
//                switch segmentIndex {
//                case 0:
//                    let diff = startDate.getDifference(to: endDate, components: .cYMWD)
//                    let values = [f(diff.year), f(diff.month), f(diff.weekOfMonth), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 1:
//                    let diff = startDate.getDifference(to: endDate, components: .cMWD)
//                    let values = [f(diff.month), f(diff.weekOfMonth), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 2:
//                    let diff = startDate.getDifference(to: endDate, components: .cWD)
//                    let values = [f(diff.weekOfYear), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 3:
//                    let diff = startDate.getDifference(to: endDate, components: .cD)
//                    let values = [f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                default: break
//                }
//            } else if segments.count == 3 && segments[1] == "Month" {
//                switch segmentIndex {
//                case 0:
//                    let diff = startDate.getDifference(to: endDate, components: .cYMD)
//                    let values = [f(diff.year), f(diff.month), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 1:
//                    let diff = startDate.getDifference(to: endDate, components: .cMD)
//                    let values = [f(diff.month), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 2:
//                    let diff = startDate.getDifference(to: endDate, components: .cD)
//                    let values = [f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                default: break
//                }
//            } else if segments.count == 3 && segments[1] == "Week" {
//                switch segmentIndex {
//                case 0:
//                    let diff = startDate.getDifference(to: endDate, components: .cYWD)
//                    let values = [f(diff.year), f(diff.weekOfYear), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 1:
//                    let diff = startDate.getDifference(to: endDate, components: .cWD)
//                    let values = [f(diff.weekOfYear), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 2:
//                    let diff = startDate.getDifference(to: endDate, components: .cD)
//                    let values = [f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                default: break
//                }
//            } else if segments.count == 2 {
//                switch segmentIndex {
//                case 0:
//                    let diff = startDate.getDifference(to: endDate, components: .cYD)
//                    let values = [f(diff.year), f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                case 1:
//                    let diff = startDate.getDifference(to: endDate, components: .cD)
//                    let values = [f(diff.day)]
//                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
//                        animateLabelTextChange(label, newText: values[i])
//                    }
//                default: break
//                }
//            }
//        } else if layoutType == .grid {
//            var values = [[String]]()
//            
//            if segments.count == 4 {
//                let diff0 = startDate.getDifference(to: endDate, components: .cYMWD)
//                values.append([f(diff0.year), f(diff0.month), f(diff0.weekOfMonth), f(diff0.day)])
//                
//                let diff1 = startDate.getDifference(to: endDate, components: .cMWD)
//                values.append([f(diff1.month), f(diff1.weekOfMonth), f(diff1.day)])
//                
//                let diff2 = startDate.getDifference(to: endDate, components: .cWD)
//                values.append([f(diff2.weekOfYear), f(diff2.day)])
//                
//                let diff3 = startDate.getDifference(to: endDate, components: .cD)
//                values.append([f(diff3.day)])
//                
//            } else if segments.count == 3 && segments[1] == "Month" {
//                let diff0 = startDate.getDifference(to: endDate, components: .cYMD)
//                values.append([f(diff0.year), f(diff0.month), f(diff0.day)])
//                
//                let diff1 = startDate.getDifference(to: endDate, components: .cMD)
//                values.append([f(diff1.month), f(diff1.day)])
//                
//                let diff2 = startDate.getDifference(to: endDate, components: .cD)
//                values.append([f(diff2.day)])
//                
//            } else if segments.count == 3 && segments[1] == "Week" {
//                let diff0 = startDate.getDifference(to: endDate, components: .cYWD)
//                values.append([f(diff0.year), f(diff0.weekOfYear), f(diff0.day)])
//                
//                let diff1 = startDate.getDifference(to: endDate, components: .cWD)
//                values.append([f(diff1.weekOfYear), f(diff1.day)])
//                
//                let diff2 = startDate.getDifference(to: endDate, components: .cD)
//                values.append([f(diff2.day)])
//                
//            } else if segments.count == 2 {
//                let diff0 = startDate.getDifference(to: endDate, components: .cYD)
//                values.append([f(diff0.year), f(diff0.day)])
//                
//                let diff1 = startDate.getDifference(to: endDate, components: .cD)
//                values.append([f(diff1.day)])
//            }
//            
//            // применяем к меткам
//            for (rowIndex, rowLabels) in valueLabels.enumerated() where rowIndex < values.count {
//                for (colIndex, label) in rowLabels.enumerated() where colIndex < values[rowIndex].count {
//                    animateLabelTextChange(label, newText: values[rowIndex][colIndex])
//                }
//            }
//        }
//    }
//}

    private func updateLabelsValues() {
        guard let startDate, let endDate else { return }
        updateDirectionIcon()
        // вспомогательный короткий форматтер
        func f(_ value: Int?) -> String {
            guard let v = value else { return "0" }
            return abs(v).formatted(.number)
        }
        
        if layoutType == .row {
            if segments.count == 4 {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYMWD)
                    let values = [f(diff.year), f(diff.month), f(diff.weekOfMonth), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cMWD)
                    let values = [f(diff.month), f(diff.weekOfMonth), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cWD)
                    let values = [f(diff.weekOfYear), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 3:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 3 && segments[1] == "Month" {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYMD)
                    let values = [f(diff.year), f(diff.month), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cMD)
                    let values = [f(diff.month), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 3 && segments[1] == "Week" {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYWD)
                    let values = [f(diff.year), f(diff.weekOfYear), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cWD)
                    let values = [f(diff.weekOfYear), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 2:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                default: break
                }
            } else if segments.count == 2 {
                switch segmentIndex {
                case 0:
                    let diff = startDate.getDifference(to: endDate, components: .cYD)
                    let values = [f(diff.year), f(diff.day)]
                    for (i, label) in (valueLabels.first ?? []).enumerated() where i < values.count {
                        label.text = values[i]
                    }
                case 1:
                    let diff = startDate.getDifference(to: endDate, components: .cD)
                    let values = [f(diff.day)]
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
                values.append([f(diff0.year), f(diff0.month), f(diff0.weekOfMonth), f(diff0.day)])
                
                let diff1 = startDate.getDifference(to: endDate, components: .cMWD)
                values.append([f(diff1.month), f(diff1.weekOfMonth), f(diff1.day)])
                
                let diff2 = startDate.getDifference(to: endDate, components: .cWD)
                values.append([f(diff2.weekOfYear), f(diff2.day)])
                
                let diff3 = startDate.getDifference(to: endDate, components: .cD)
                values.append([f(diff3.day)])
                
            } else if segments.count == 3 && segments[1] == "Month" {
                let diff0 = startDate.getDifference(to: endDate, components: .cYMD)
                values.append([f(diff0.year), f(diff0.month), f(diff0.day)])
                
                let diff1 = startDate.getDifference(to: endDate, components: .cMD)
                values.append([f(diff1.month), f(diff1.day)])
                
                let diff2 = startDate.getDifference(to: endDate, components: .cD)
                values.append([f(diff2.day)])
                
            } else if segments.count == 3 && segments[1] == "Week" {
                let diff0 = startDate.getDifference(to: endDate, components: .cYWD)
                values.append([f(diff0.year), f(diff0.weekOfYear), f(diff0.day)])
                
                let diff1 = startDate.getDifference(to: endDate, components: .cWD)
                values.append([f(diff1.weekOfYear), f(diff1.day)])
                
                let diff2 = startDate.getDifference(to: endDate, components: .cD)
                values.append([f(diff2.day)])
                
            } else if segments.count == 2 {
                let diff0 = startDate.getDifference(to: endDate, components: .cYD)
                values.append([f(diff0.year), f(diff0.day)])
                
                let diff1 = startDate.getDifference(to: endDate, components: .cD)
                values.append([f(diff1.day)])
            }
            
            // применяем к меткам
            for (rowIndex, rowLabels) in valueLabels.enumerated() where rowIndex < values.count {
                for (colIndex, label) in rowLabels.enumerated() where colIndex < values[rowIndex].count {
                    label.text = values[rowIndex][colIndex]
                }
            }
        }
    }
}
    
extension ValuesView {
    private func setupDirectionView() {
        addSubview(directionView)
        directionView.translatesAutoresizingMaskIntoConstraints = false
        directionView.backgroundColor = .systemBackground
        directionView.layer.cornerRadius = 9
        directionView.layer.shadowColor = UIColor.black.cgColor
        directionView.layer.shadowOpacity = 0.05
        directionView.layer.shadowRadius = 4
        directionView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        directionView.alpha = 1.0
        clipsToBounds = false

        NSLayoutConstraint.activate([
            directionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            directionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            directionView.widthAnchor.constraint(equalToConstant: 18),
            directionView.heightAnchor.constraint(equalToConstant: 18)
        ])

        setupDirectionIcon()
    }
    
    private func setupDirectionIcon() {
        directionView.addSubview(directionIcon)
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.contentMode = .scaleAspectFit
        directionIcon.tintColor = .systemGreen
        //directionIcon.image = UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        directionIcon.alpha = 1.0

        NSLayoutConstraint.activate([
            directionIcon.topAnchor.constraint(equalTo: directionView.topAnchor, constant: 2),
            directionIcon.bottomAnchor.constraint(equalTo: directionView.bottomAnchor, constant: -2),
            directionIcon.leadingAnchor.constraint(equalTo: directionView.leadingAnchor, constant: 2),
            directionIcon.trailingAnchor.constraint(equalTo: directionView.trailingAnchor, constant: -2)
        ])
    }
    
    private func updateDirectionIcon() {
        guard let startDate, let endDate else { return }
        let isReversed = startDate > endDate
        
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        let symbolName = isReversed ? "arrow.left" : "arrow.right"
        let color = isReversed ? UIColor.systemRed : UIColor.systemGreen
        
        directionIcon.image = UIImage(systemName: symbolName, withConfiguration: config)
        directionIcon.tintColor = color.withAlphaComponent(0.85)
        
        UIView.animate(withDuration: 0.25) {
            self.directionView.alpha = startDate == endDate ? 0.0 : 1.0
        }
        UIView.transition(with: directionIcon, duration: 0.25, options: [.transitionCrossDissolve]) {
            self.directionIcon.alpha = 1.0
        }
    }
    
//    private func updateDirectionIcon() {
//        guard let startDate, let endDate else { return }
//
//        let isReversed = startDate > endDate
//        let rotationAngle: CGFloat = isReversed ? .pi : 0 // поворот на 180° влево
//        let color = isReversed ? UIColor.systemRed : UIColor.systemGreen
//
//        // Если иконка ещё не установлена
//        if directionIcon.image == nil {
//            let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
//            directionIcon.image = UIImage(systemName: "arrow.right", withConfiguration: config)
//        }
//
//        // Анимация плавного поворота
//        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
//            self.directionIcon.transform = CGAffineTransform(rotationAngle: rotationAngle)
//            self.directionIcon.tintColor = color.withAlphaComponent(0.85)
//        }
//    }
}
