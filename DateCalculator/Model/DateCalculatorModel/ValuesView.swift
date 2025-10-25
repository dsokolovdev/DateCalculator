//
//  ValueView.swift
//  DateCalculator
//
//  Created by Dmitri  on 24.10.25.
//

import UIKit

//final class ValuesView: UIView, LayoutDisplayable {
//    
//    var layoutType: LayoutType = .row //{ didSet { updateLayout() } }
//    
////    enum LayoutMode { case row, grid }
////    var mode: LayoutMode = .row { didSet { updateLayout() } }
//    
//    
//    
//    private var valueLabels = [[UILabel]]()
//    private var hStacks = [UIStackView]()
//    private var vStack = [UIStackView]()
//    private var rows: Int = 1
//    
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupAppearance()
//    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupAppearance()
//        //fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupAppearance() {
//        backgroundColor = .systemBackground
//        layer.cornerRadius = 20
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.05
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 0, height: 2.5)
//    }
//    
//    private func updateViews(for segments: [String]) {
//        subviews.forEach { $0.removeFromSuperview() }
//        
//        switch layoutType {
//        case .row:
//            let hStack = makeHStack(labels: valueLabels.first ?? [])
//            addNewSubview(hStack)
//            
//        case .grid:
//            let vStack = UIStackView()
//            vStack.axis = .vertical
//            vStack.alignment = .fill
//            vStack.distribution = .fillEqually
//            vStack.spacing = 8
//            
//            for rowLabels in valueLabels {
//                let hStack = makeHStack(labels: rowLabels)
//                vStack.addArrangedSubview(hStack)
//            }
//            addNewSubview(vStack)
//            
//            //in case view shoud autoresize if number of rows changed
////            invalidateIntrinsicContentSize()
////            layoutIfNeeded()
//        }
//        
//    }
//    
//    private func makeHStack(labels: [UILabel]) -> UIStackView {
//        let stack = UIStackView(arrangedSubviews: labels)
//        stack.axis = .horizontal
//        stack.spacing = 8
//        stack.distribution = .fillEqually
//        stack.alignment = .fill
//        return stack
//    }
//    
//    func updateLayout(for segments: [String]) {
//        updateLables(for: segments)
//        updateViews(for: segments)
//    }
//    
//    func addNewSubview(_ subview: UIView) {
//        addSubview(subview)
//        subview.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            subview.topAnchor.constraint(equalTo: topAnchor),
//            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
//            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
//            subview.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//    
//    //MARK: - Public API
//    private func updateLables(for segments: [String]) {
//        valueLabels.removeAll()
//        rows = layoutType == .row ? 1 : segments.count
//        for _ in 0..<rows {
//            var rowLabels: [UILabel] = []
//            for _ in 0..<segments.count {
//                let label = UILabel()
//                label.text = "0"
//                label.textAlignment = .right
//                label.textColor = .label
//                label.adjustsFontSizeToFitWidth = true
//                label.minimumScaleFactor = 0.8
//                label.font = .systemFont(ofSize: 26, weight: .medium)
//                rowLabels.append(label)
//            }
//            valueLabels.append(rowLabels)
//        }
//        //updateLayout()
//    }
//}

import UIKit

final class ValuesView: UIView, LayoutDisplayable {
    
    // MARK: - Public Properties
    
    /// Тип расположения: row или grid
    var layoutType: LayoutType = .row {
        didSet { refreshLayout() } // ⚙️ Автообновление при смене типа
    }
    
    /// Список сегментов, для которых нужно отрисовать лейблы
    var segments: [String] = [] {
        didSet { refreshLayout() } // ⚙️ Автообновление при смене сегментов
    }
    
    var segmentIndex: Int = 0 {
        didSet { refreshLayout() }
    }
    
    // MARK: - Private Properties
    
    private var valueLabels = [[UILabel]]()
    private var rows: Int = 1
    private var didSetupLabelConstraints = false
    
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
        guard !didSetupLabelConstraints, !segments.isEmpty else { return }
        didSetupLabelConstraints = true
        refreshLayout()
    }
    
    // MARK: - Setup
    
    private func setupAppearance() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
    
    // MARK: - Public API
    
    /// Принудительно обновить layout (например, если хочешь обновить значения)
    func refreshLayout() {
        guard !segments.isEmpty else { return }
        updateLabels()
        updateViews()
    }
    
    // MARK: - Private
    
    private func updateLabels() {
        valueLabels.removeAll()
        rows = layoutType == .row ? 1 : segments.count
        let fontSize = (max: 30.0, min: 18.0)
        let size = layoutType == .row ? 30 : fontSize.max - (fontSize.max - fontSize.min)/4 * Double(segments.count)
        let labelCount = layoutType == .row ? segments.count - segmentIndex : segments.count
        
        print("Segments: \(segments.count), segmentIndex: \(segmentIndex), Lables: \(labelCount)")
        
        for row in 0..<rows {
            var rowLabels: [UILabel] = []
            for space in 0..<labelCount - row {
                let label = UILabel()
                label.text = "0"
                label.textAlignment = .right
                label.textColor = .label
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = 0.8
                label.font = .systemFont(ofSize: size, weight: .medium)
                
                if space > 0 {
                    updateConstraintsfor(label: label)
                }
                
                rowLabels.append(label)
            }
            valueLabels.append(rowLabels)
        }
    }
    
    private func updateConstraintsfor(label: UILabel){
        let spacing: CGFloat = 8
        let segmentWidth = (bounds.width - spacing * 2) / CGFloat(segments.count)
        label.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = label.widthAnchor.constraint(equalToConstant: CGFloat(segmentWidth))
        label.addConstraint(widthConstraint)
    }
    
    private func updateViews() {
        subviews.forEach { $0.removeFromSuperview() }
        
        switch layoutType {
        case .row:
            let hStack = makeHStack(labels: valueLabels.first ?? [])
            addFullSizeSubview(hStack)
            
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
            addFullSizeSubview(vStack)
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
    
    private func addFullSizeSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func updateValues(){
        
    }
}


///// Configures a container for numerical results.
//private func setupValuesView() {
//    valuesView = UIView()
//    view.addSubview(valuesView)
//    valuesView.translatesAutoresizingMaskIntoConstraints = false
//    valuesView.backgroundColor = .systemBackground
//    valuesView.layer.cornerRadius = 20
//    valuesView.layer.shadowColor = UIColor.black.cgColor
//    valuesView.layer.shadowOpacity = 0.05
//    valuesView.layer.shadowRadius = 4
//    valuesView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
//    
//    NSLayoutConstraint.activate([
//        valuesView.topAnchor.constraint(equalTo: periodSegmentedControlBarView.bottomAnchor, constant: 8),
//        valuesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//        valuesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//        valuesView.heightAnchor.constraint(equalToConstant: 80)
//    ])
//}

