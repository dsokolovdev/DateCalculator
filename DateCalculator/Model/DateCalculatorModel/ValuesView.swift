//
//  ValueView.swift
//  DateCalculator
//
//  Created by Dmitry on 24.10.25.
//
//  Description:
//  Displays calculated date differences (Year / Month / Week / Day)
//  in either Row or Grid layout style. Automatically updates when
//  user changes segments or selected dates.

import UIKit

//MARK: - Values View
/// A reusable view that displays date differences (Year / Month / Week / Day)
/// in either Row or Grid layouts, and highlights the active segment.
final class ValuesView: UIView, LayoutDisplayable {
    
    // MARK: - Public Properties
    /// Current layout type. Triggers a layout refresh when changed.
    var layoutType: LayoutType = .row { didSet { refreshLayout() } }
    
    // MARK: - Private Properties
    /// Visible period names (e.g., ["Year", "Month", "Week", "Day"]).
    private var segments: [String] = []
    /// Currently selected segment index (used to emphasize the active column/row).
    private var segmentIndex: Int = 0
    /// Start and end dates for difference calculation.
    private var startDate: Date?
    private var endDate: Date?
    
    /// 2D matrix of value labels. In `.row` mode it's one row; in `.grid` mode row count == segments.count.
    private var valueLabels = [[UILabel]]()
    /// Cached number of rows based on layout.
    private var rows: Int = 1
    /// Guards against repeated initial layout refresh on first layout pass.
    private var hasLaidOutOnce = false
    /// Small arrow image that indicates direction (start → end or start ← end).
    private let directionIcon = UIImageView()
    /// Container view for the direction arrow (rounded, with subtle shadow).
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
    
    // MARK: - Layout Cycle
    /// Performs first-time layout refresh and updates width constraints each pass.
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !segments.isEmpty else { return }
        
        updateLabelsConstraints()
        
        if !hasLaidOutOnce {
            hasLaidOutOnce = true
            refreshLayout()
        }
    }
    
    // MARK: - Public API
    /// Forces layout refresh (rebuilds labels/stacks and recolors active segment).
    /// Call when you need to update values or after switching layout type.
    func refreshLayout() {
        guard !segments.isEmpty else { return }
        updateLabels()
        updateViews()
        updateLabelsValues()
        updateLabelsColor()
    }
    
    /// Updates current date range and refreshes numeric values.
    /// - Parameters:
    ///   - start: Start date of the calculation range.
    ///   - end: End date of the calculation range.
    func updateDates(from start: Date, to end: Date) {
        startDate = start
        endDate = end
        updateLabelsValues()
    }
}

//MARK: - Delegate (ValuesViewUpdatable)
extension ValuesView: ValuesViewUpdatable {
    /// Receives new segments / selected index / dates from the ViewModel and updates the view.
    /// - Parameters:
    ///   - segments: Visible segments (e.g. ["Year","Month","Week","Day"])
    ///   - selectedIndex: Selected segment index to emphasize.
    ///   - start: Start date.
    ///   - end: End date.
    func updateValues(segments: [String], selectedIndex: Int, from start: Date, to end: Date) {
        let shouldRefresh = self.segments != segments || self.segmentIndex != selectedIndex
        
        self.segments = segments
        self.segmentIndex = selectedIndex
        self.startDate = start
        self.endDate = end
        
        if shouldRefresh {
            refreshLayout()        // Recreate labels and stacks only when layout type or visible segments change
        } else {
            updateLabelsValues()   // update labels text
        }
    }
}

//MARK: - View Appearance
extension ValuesView {
    /// Configures background, corner radius and subtle shadow.
    private func setupAppearance() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 20 * scaleFactor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
}

//MARK: - Subviews & Containers
extension ValuesView {
    /// Rebuilds subviews according to the current `layoutType`.
    /// Removes previous stacks (but keeps directionView) and inserts a single container:
    ///  - `.row`: one horizontal stack with labels
    ///  - `.grid`: vertical stack containing multiple horizontal stacks
    private func updateViews() {
        
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
    
    /// Creates a horizontal stack for a row of value labels.
    private func makeHStack(labels: [UILabel]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: labels)
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }
    
    /// Adds a subview and pins it with consistent insets.
    /// This ensures uniform padding regardless of layout mode.
    private func addNewSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 8 * scaleFactor),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8 * scaleFactor),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8 * scaleFactor),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8 * scaleFactor)
        ])
    }
}

// MARK: - Labels (Create / Size / Color / Values)
extension ValuesView {
    
    // MARK: Create
    /// Recreates the labels matrix (1 row for `.row`, N rows for `.grid`).
    /// Called from `refreshLayout()` before rebuilding container stacks.
    private func updateLabels() {
        valueLabels.removeAll()
        rows = layoutType == .row ? 1 : segments.count
        
        let fontSize = (max: 32.0 * scaleFactor, min: 20.0 * scaleFactor)
        let size = layoutType == .row ? fontSize.max : fontSize.max - (fontSize.max - fontSize.min)/4 * Double(segments.count)
        let labelCount = layoutType == .row ? segments.count - segmentIndex : segments.count
        
        for row in 0..<rows {
            var rowLabels: [UILabel] = []
            for _ in 0..<labelCount - row {
                let label = AnimatedLabel()
                
                label.textAlignment = .right
                label.textColor = UIColor.label.withAlphaComponent(0.6)
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.8
                label.font = .systemFont(ofSize: size, weight: .medium)
                
                rowLabels.append(label)
            }
            valueLabels.append(rowLabels)
        }
    }
    
    // MARK: Size (Constraints)
    /// Updates width constraints for labels to distribute evenly per row.
    /// Width is applied to labels with index > 0 to keep the first value flexible.
    private func updateLabelsConstraints() {
        let spacing: CGFloat = 8 * scaleFactor
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
    
    // MARK: Color
    /// Highlights active segment and dims the rest depending on layout.
    /// Safeguards against index issues when segments/labels change asynchronously.
    private func updateLabelsColor() {
        guard valueLabels.indices.contains(segmentIndex), valueLabels[segmentIndex].indices.contains(0) else { return }
        
        if layoutType == .row {
            valueLabels[0][0].textColor = C.mazarineBlue
        } else if layoutType == .grid {
            
            valueLabels[segmentIndex][0].textColor = C.mazarineBlue
            for (rowIndex, rowLables) in valueLabels.enumerated() {
                for label in rowLables where rowIndex != segmentIndex {
                    label.textColor = UIColor.secondaryLabel.withAlphaComponent(0.5)
                }
            }
            
        }
    }
    
    // MARK: Values (Calculations)
    /// Calculates values for all visible labels based on current `segments`, `segmentIndex`, and the `(startDate, endDate)` range.
    private func updateLabelsValues() {
        guard let startDate, let endDate else { return }
        updateDirectionIcon()
        
        // вспомогательный короткий форматтер
        func formatter(_ value: Int?) -> String {
            guard let v = value else { return "0" }
            return abs(v).formatted(.number)
        }
        
        if layoutType == .row {
            updateValuesForRowLayout(startDate: startDate, endDate: endDate, f: formatter)
            
        } else if layoutType == .grid {
            updateValuesForGridLayout(startDate: startDate, endDate: endDate, f: formatter)
        }
    }
    
    // MARK: - Calculation Helpers (Grid)
    /// Populates `valueLabels` for `.grid` layout. Each row corresponds to the segment view starting at a certain level.
    private func updateValuesForGridLayout(startDate: Date, endDate: Date, f: (Int?) -> String) {
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
    
    // MARK: - Calculation Helpers (Row)
    /// Populates `valueLabels` for `.row` layout. The single horizontal row changes depending on selected segment index.
    private func updateValuesForRowLayout(startDate: Date, endDate: Date, f: (Int?) -> String) {
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
    }
}

// MARK: - Direction Indicator (Arrow)
extension ValuesView {
    /// Creates a small rounded badge with an arrow that indicates date order (→ or ←).
    private func setupDirectionView() {
        addSubview(directionView)
        directionView.translatesAutoresizingMaskIntoConstraints = false
        directionView.backgroundColor = .systemBackground
        directionView.layer.cornerRadius = 10 * scaleFactor
        directionView.layer.shadowColor = UIColor.black.cgColor
        directionView.layer.shadowOpacity = 0.05
        directionView.layer.shadowRadius = 4
        directionView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        directionView.alpha = 1.0
        clipsToBounds = false
        
        NSLayoutConstraint.activate([
            directionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8 * scaleFactor),
            directionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8 * scaleFactor),
            directionView.widthAnchor.constraint(equalToConstant: 20 * scaleFactor),
            directionView.heightAnchor.constraint(equalToConstant: 20 * scaleFactor)
        ])
        
        setupDirectionIcon()
    }
    
    /// Adds and constraints the arrow icon inside the direction badge.
    private func setupDirectionIcon() {
        directionView.addSubview(directionIcon)
        directionIcon.translatesAutoresizingMaskIntoConstraints = false
        directionIcon.contentMode = .scaleAspectFit
        directionIcon.tintColor = .systemGreen
        directionIcon.alpha = 1.0
        
        NSLayoutConstraint.activate([
            directionIcon.topAnchor.constraint(equalTo: directionView.topAnchor, constant: 2),
            directionIcon.bottomAnchor.constraint(equalTo: directionView.bottomAnchor, constant: -2),
            directionIcon.leadingAnchor.constraint(equalTo: directionView.leadingAnchor, constant: 2),
            directionIcon.trailingAnchor.constraint(equalTo: directionView.trailingAnchor, constant: -2)
        ])
    }
    
    /// Updates arrow direction and color based on whether `startDate` > `endDate`.
    private func updateDirectionIcon() {
        
        guard let startDate, let endDate else { return }
        let isReversed = startDate > endDate
        
        let config = UIImage.SymbolConfiguration(pointSize: 13 * scaleFactor, weight: .bold)
        let symbolName = isReversed ? "arrow.left" : "arrow.right"
        let color = isReversed ? C.veryBerry : C.mediterraneanSea
        
        directionIcon.image = UIImage(systemName: symbolName, withConfiguration: config)
        directionIcon.tintColor = color.withAlphaComponent(0.85)
        
        UIView.animate(withDuration: 0.25) {
            self.directionView.alpha = startDate == endDate ? 0.0 : 1.0
        }
        UIView.transition(with: directionIcon, duration: 0.25, options: [.transitionCrossDissolve]) {
            self.directionIcon.alpha = 1.0
        }
    }
}
