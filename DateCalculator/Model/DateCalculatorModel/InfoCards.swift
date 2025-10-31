//
//  InfoCardsContainer.swift
//  DateCalculator
//
//  Created by Dmitri on 21.10.25.
//
//  Description:
//  Defines reusable InfoCard views (Western, Chinese, Year, and Statistics)
//  used in the Date Calculator app. Provides a generic container that
//  manages creation, updating, and animated appearance of cards.
//

import UIKit

// MARK: - Updatable Card Protocol
/// A generic protocol for reusable info cards.
/// Each card type defines its own `ModelData` for content updates.
protocol UpdatableCard: AnyObject {
    associatedtype ModelData
    func update(with data: ModelData)
    func asView() -> UIView
}

// MARK: - InfoCards Container (Main Manager)
/// Main entry point for managing and displaying all info cards (e.g. Horoscope, Year, Statistics).
final class InfoCards {
    
    // MARK: - Info Card Type
    /// Defines categories of cards and their associated color themes.
    enum InfoCardType {
        case western
        case chinese
        case year
        case statistics
        
        /// Background color for each card type.
        var backgroundColor: UIColor {
            switch self {
            case .western:    return  C.Cards.selectedBlue
            case .chinese:    return  C.Cards.waterfall
            case .year:       return  C.Cards.sourLemon
            case .statistics: return  C.Cards.customGrey
            }
        }
        
        /// Title color for labels used inside the card.
        var titleColor: UIColor {
            switch self {
            case .western:    return  C.Cards.selectedBlue
            case .chinese:    return  C.Cards.waterfall
            case .year:       return  C.Cards.sourLemon
            case .statistics: return  C.Cards.customGrey
            }
        }
    }
    
    // MARK: - AnyUpdatableCard Wrapper
    /// Type-erased wrapper that allows storing different card types in one dictionary.
    final class AnyUpdatableCard {
        private let _asView: () -> UIView
        private let _update: (Any) -> Void
        
        init<T: UpdatableCard>(_ card: T) {
            _asView = { card.asView() }
            _update = { data in
                if let typedData = data as? T.ModelData {
                    card.update(with: typedData)
                }
            }
        }
        
        func asView() -> UIView { _asView() }
        func update(with data: Any) { _update(data) }
    }
    
    // MARK: - InfoCard (Western, Chinese, Year)
    /// Generic card displaying horoscope or year information.
    /// Supports emoji or SF Symbol icons and smooth transitions.
    final class InfoCard: UpdatableCard {
        
        // MARK: - Model
        struct ModelData {
            let title: String
            let icon: String
            let name: String
            var color: UIColor? = nil
        }
        
        private var lastName: String?
        let cardType: InfoCardType
        
        private let titleLabel = UILabel()
        private let iconLabel = UILabel()
        private let nameLabel = UILabel()
        private let cardView = UIView()
        private let overlay = UIView()
        
        // MARK: - Init
        init(cardType: InfoCardType) {
            self.cardType = cardType
            setupLabels()
            setupView()
        }
        
        // MARK: - Setup
        private func setupLabels() {
            titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
            titleLabel.textAlignment = .center
            titleLabel.textColor = C.Cards.titleLabelColor(for: cardType.backgroundColor)
            
            iconLabel.font = .systemFont(ofSize: 34, weight: .regular)
            iconLabel.textAlignment = .center
            
            nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
            nameLabel.textAlignment = .center
            nameLabel.textColor = C.Cards.nameLabelColor(for: cardType.backgroundColor)
        }
        
        /// Builds the card container, overlay, and layout stack.
        private func setupView() {
            cardView.backgroundColor = .systemBackground
            cardView.layer.cornerRadius = 10
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowRadius = 4
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            let overlayView = UIView()
            overlayView.backgroundColor = cardType.backgroundColor
            overlayView.layer.cornerRadius = 10
            overlayView.layer.masksToBounds = true
            overlayView.translatesAutoresizingMaskIntoConstraints = false
            
            let stack = UIStackView(arrangedSubviews: [titleLabel, iconLabel, nameLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            cardView.addSubview(overlayView)
            overlayView.addSubview(stack)
            
            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: cardView.topAnchor),
                overlayView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                overlayView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
                
                stack.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 6),
                stack.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -6),
                
                cardView.widthAnchor.constraint(equalToConstant: 130),
                cardView.heightAnchor.constraint(equalToConstant: 90)
            ])
            
            cardView.layer.shadowPath = UIBezierPath(
                roundedRect: CGRect(x: 0, y: 0, width: 130, height: 90),
                cornerRadius: 10
            ).cgPath
        }
        
        func asView() -> UIView { cardView }
        
        // MARK: - Update
        /// Smoothly updates the content (emoji/SF Symbol, title, name) with animations.
        func update(with data: ModelData) {
            let hasTypeChanged = data.name != lastName
            lastName = data.name
            
            UIView.transition(with: cardView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
                titleLabel.text = data.title
                nameLabel.text  = data.name
                
                // Case: SF Symbol (used for Year card)
                if data.title == "Year" {
                    let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
                    if let image = UIImage(systemName: data.icon, withConfiguration: config)?
                        .withTintColor(data.color ?? .secondaryLabel, renderingMode: .alwaysOriginal) {
                        
                        let attachment = NSTextAttachment()
                        attachment.image = image
                        let attrString = NSAttributedString(attachment: attachment)
                        
                        if hasTypeChanged {
                            animateIconTransition(to: attrString)
                        } else {
                            iconLabel.attributedText = attrString
                        }
                    }
                } else {
                    // Case: Emoji or text icon
                    if hasTypeChanged {
                        animateIconTransition(to: data.icon, color: data.color)
                    } else {
                        iconLabel.text = data.icon
                        iconLabel.textColor = data.color ?? .label
                    }
                }
            }
        }
        
        // MARK: - Animations
        private func animateIconTransition(to text: String, color: UIColor?) {
            UIView.animate(withDuration: 0.25, animations: {
                self.iconLabel.alpha = 0.3
                self.iconLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }, completion: { _ in
                self.iconLabel.text = text
                self.iconLabel.textColor = color ?? .label
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.3,
                               options: [.curveEaseOut]) {
                    self.iconLabel.alpha = 1.0
                    self.iconLabel.transform = .identity
                }
            })
        }
        
        private func animateIconTransition(to attributedText: NSAttributedString) {
            UIView.animate(withDuration: 0.25, animations: {
                self.iconLabel.alpha = 0.3
                self.iconLabel.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }, completion: { _ in
                self.iconLabel.attributedText = attributedText
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.3,
                               options: [.curveEaseOut]) {
                    self.iconLabel.alpha = 1.0
                    self.iconLabel.transform = .identity
                }
            })
        }
    }
    
    // MARK: - Statistics Card
    /// Displays a compact summary with three data rows (e.g., Month / Week / Day).
    final class StatisticsCard: UpdatableCard {
        
        // MARK: - Model
        struct ModelData {
            let dataTitle: String
            let name1: String; let data1: String; let total1: String
            let name2: String; let data2: String; let total2: String
            let name3: String; let data3: String; let total3: String
        }
        
        let cardType: InfoCardType
        private let titleLabel = UILabel()
        private let name1Label = UILabel(), name2Label = UILabel(), name3Label = UILabel()
        private let data1Label = UILabel(), data2Label = UILabel(), data3Label = UILabel()
        private let total1Label = UILabel(), total2Label = UILabel(), total3Label = UILabel()
        private let cardView = UIView()
        
        // MARK: - Init
        init(cardType: InfoCardType) {
            self.cardType = cardType
            setupLabels()
            setupView()
        }
        
        // MARK: - Setup
        private func setupLabels() {
            titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
            titleLabel.textAlignment = .center
            titleLabel.textColor = .label
            
            [name1Label, name2Label, name3Label].forEach {
                $0.font = .systemFont(ofSize: 13, weight: .regular)
                $0.textAlignment = .left
                $0.textColor = .secondaryLabel
            }
            
            [data1Label, data2Label, data3Label].forEach {
                $0.font = .systemFont(ofSize: 13, weight: .medium)
                $0.textAlignment = .right
                $0.textColor = .label
            }
            
            [total1Label, total2Label, total3Label].forEach {
                $0.font = .systemFont(ofSize: 13, weight: .medium)
                $0.textAlignment = .right
                $0.textColor = .secondaryLabel
            }
        }
        
        /// Builds the stacked layout for the statistics card.
        private func setupView() {
            let stack0 = UIStackView(arrangedSubviews: [titleLabel])
            let stack1 = UIStackView(arrangedSubviews: [name1Label, data1Label, total1Label])
            let stack2 = UIStackView(arrangedSubviews: [name2Label, data2Label, total2Label])
            let stack3 = UIStackView(arrangedSubviews: [name3Label, data3Label, total3Label])
            
            [stack0, stack1, stack2, stack3].forEach {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 0
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
            let stack = UIStackView(arrangedSubviews: [stack0, stack1, stack2, stack3])
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            cardView.addSubview(stack)
            cardView.backgroundColor = cardType.backgroundColor
            cardView.layer.cornerRadius = 10
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowRadius = 4
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
                stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 6),
                stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -6),
                stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
                cardView.widthAnchor.constraint(equalToConstant: 130),
                cardView.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
        
        func asView() -> UIView { cardView }
        
        // MARK: - Update
        func update(with data: ModelData) {
            UIView.transition(with: cardView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
                titleLabel.text = data.dataTitle
                name1Label.text = data.name1; data1Label.text = data.data1; total1Label.text = data.total1
                name2Label.text = data.name2; data2Label.text = data.data2; total2Label.text = data.total2
                name3Label.text = data.name3; data3Label.text = data.data3; total3Label.text = data.total3
                
                // Custom day color (Sunday / Saturday)
                if data.dataTitle == "Sunday" {
                    titleLabel.textColor = C.chiGong
                } else if data.dataTitle == "Saturday" {
                    titleLabel.textColor = C.royalBlue
                } else {
                    titleLabel.textColor = .label
                }
            }
        }
    }
    
    // MARK: - Container
    /// Holds and manages all cards inside a horizontal stack view.
    final class Container {
        enum CardID {
            case westernZodiac, westernElement
            case chineseZodiac, chineseElement, chineseEnergy
            case year
            case statistics
        }
        
        private(set) var cards: [CardID: AnyUpdatableCard] = [:]
        let containerView = UIStackView()
        
        init() {
            containerView.axis = .horizontal
            containerView.alignment = .center
            containerView.spacing = 10
            containerView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        /// Adds a new card to the container.
        func addCard<T: UpdatableCard>(_ card: T, id: CardID) {
            let wrapped = AnyUpdatableCard(card)
            cards[id] = wrapped
            containerView.addArrangedSubview(wrapped.asView())
        }
        
        /// Updates the specified card by its identifier.
        func updateCard(id: CardID, with data: Any) {
            cards[id]?.update(with: data)
        }
    }
}

// MARK: - Appearance Animation
extension InfoCards.Container {
    /// Smooth entrance animation for cards when the view loads.
    func animateAppearance() {
        for (index, view) in containerView.arrangedSubviews.enumerated() {
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 20, y: 0)
            UIView.animate(
                withDuration: 0.5,
                delay: Double(index) * 0.05,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: [.curveEaseOut]
            ) {
                view.alpha = 1
                view.transform = .identity
            }
        }
    }
}
