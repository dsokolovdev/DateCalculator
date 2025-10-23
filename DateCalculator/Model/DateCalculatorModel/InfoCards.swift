//
//  InfoCardsContainer.swift
//  DateCalculator
//
//  Created by Dmitri  on 21.10.25.
//

import UIKit

// MARK: - Протокол для всех карточек
protocol UpdatableCard: AnyObject {
    associatedtype ModelData
    func update(with data: ModelData)
    func asView() -> UIView
}

// MARK: - Главный контейнер карточек
final class InfoCards {
    
    // MARK: - Типы карточек
    enum InfoCardType {
        case western
        case chinese
        case year
        case statistics
        
        var backgroundColor: UIColor {
            switch self {
            case .western:    return .secondarySystemBackground //.systemGray6
            case .chinese:    return .systemBlue.withAlphaComponent(0.12) //UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1.00)// UIColor(red: 0.78, green: 0.84, blue: 0.90, alpha: 0.70) //.systemGreen.withAlphaComponent(0.12)
            case .year:       return .systemYellow.withAlphaComponent(0.15) //UIColor(red: 0.97, green: 0.95, blue: 0.89, alpha: 1.00) //.systemYellow.withAlphaComponent(0.15)
            case .statistics: return .tertiarySystemBackground //.white
            }
        }
    }
    
    // MARK: - Универсальная обертка для разных типов карточек
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
    
    // MARK: - Карточка гороскопов и года
    final class InfoCard: UpdatableCard {
        struct ModelData {
            let title: String
            let icon: String
            let name: String
        }
        
        let cardType: InfoCardType
        private let titleLabel = UILabel()
        private let iconLabel = UILabel()
        private let nameLabel = UILabel()
        private let cardView = UIView()
        private let overlay = UIView()
        
        init(cardType: InfoCardType) {
            self.cardType = cardType
            setupLabels()
            setupView()
        }
        
        private func setupLabels() {
            titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
            titleLabel.textAlignment = .center
            titleLabel.textColor = .secondaryLabel
            
            iconLabel.font = .systemFont(ofSize: 34, weight: .regular)
            iconLabel.textAlignment = .center
            
            nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
            nameLabel.textAlignment = .center
            nameLabel.textColor = .label
        }
        
        private func setupView() {
            let stack = UIStackView(arrangedSubviews: [titleLabel, iconLabel, nameLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.translatesAutoresizingMaskIntoConstraints = false
            
//            overlay.backgroundColor = cardType.backgroundColor
//            overlay.layer.cornerRadius = 10
//            overlay.layer.masksToBounds = true
//            
//            cardView.addSubview(overlay)
//            overlay.addSubview(stack)
            
            cardView.addSubview(stack)
            cardView.backgroundColor = cardType.backgroundColor
            cardView.layer.cornerRadius = 10
            cardView.layer.shadowOpacity = 0.1
            cardView.layer.shadowRadius = 4
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
                stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
                cardView.widthAnchor.constraint(equalToConstant: 130),
                cardView.heightAnchor.constraint(equalToConstant: 90)
            ])
        }
        
        func asView() -> UIView { cardView }
        
        func update(with data: ModelData) {
            UIView.transition(with: cardView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
                titleLabel.text = data.title
                iconLabel.text = data.icon
                nameLabel.text = data.name
            }
        }
    }
    
    // MARK: - Карточка статистики
    final class StatisticsCard: UpdatableCard {
        struct ModelData {
            let dataTitle: String
            let name1: String
            let data1: String
            let total1: String
            let name2: String
            let data2: String
            let total2: String
            let name3: String
            let data3: String
            let total3: String
        }
        
        let cardType: InfoCardType
        //for names of data
        private let titleLabel = UILabel()
        private let name1Label = UILabel()
        private let name2Label = UILabel()
        private let name3Label = UILabel()
        private let data1Label = UILabel()
        private let data2Label = UILabel()
        private let data3Label = UILabel()
        private let total1Label = UILabel()
        private let total2Label = UILabel()
        private let total3Label = UILabel()
        
        private let cardView = UIView()
        
        init(cardType: InfoCardType) {
            self.cardType = cardType
            setupLabels()
            setupView()
        }
        
        private func setupLabels() {
            titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
            titleLabel.textAlignment = .center
            titleLabel.textColor = .secondaryLabel
            
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
        
        func update(with data: ModelData) {
            UIView.transition(with: cardView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
                titleLabel.text = data.dataTitle
                name1Label.text = data.name1
                data1Label.text = data.data1
                total1Label.text = data.total1
                name2Label.text = data.name2
                data2Label.text = data.data2
                total2Label.text = data.total2
                name3Label.text = data.name3
                data3Label.text = data.data3
                total3Label.text = data.total3
            }
        }
    }
    
    // MARK: - Контейнер для всех карточек
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
        
        func addCard<T: UpdatableCard>(_ card: T, id: CardID) {
            let wrapped = AnyUpdatableCard(card)
            cards[id] = wrapped
            containerView.addArrangedSubview(wrapped.asView())
        }
        
        func updateCard(id: CardID, with data: Any) {
            cards[id]?.update(with: data)
        }
    }
}

extension InfoCards.Container {
    
    /// Анимированное появление карточек при загрузке
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

//MARK: - Separate classes implementations
//
//// MARK: - Протокол для всех карточек
//protocol UpdatableCard: AnyObject {
//    associatedtype DataModel
//    func update(with data: DataModel)
//    func asView() -> UIView
//}
//// MARK: - Type Erasure (обертка)
//final class AnyUpdatableCard {
//    private let _asView: () -> UIView
//    private let _update: (Any) -> Void
//
//    init<T: UpdatableCard>(_ card: T) {
//        _asView = { card.asView() }
//        _update = { data in
//            if let typedData = data as? T.DataModel {
//                card.update(with: typedData)
//            }
//        }
//    }
//
//    func asView() -> UIView { _asView() }
//    func update(with data: Any) { _update(data) }
//}
//
//// MARK: - Контейнер карточек
//final class InfoCardsContainer {
//
//    enum CardID {
//        case westernZodiac, westernElement
//        case chineseZodiac, chineseElement, chineseEnergy
//        case year
//        case statistics
//    }
//
//    private(set) var cards: [CardID: AnyUpdatableCard] = [:]
//    let containerView = UIStackView()
//
//    init() {
//        containerView.axis = .horizontal
//        containerView.alignment = .center
//        containerView.spacing = 10
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    // Добавление карточек
//    func addCard<T: UpdatableCard>(_ card: T, id: CardID) {
//        let wrapped = AnyUpdatableCard(card)
//        cards[id] = wrapped
//        containerView.addArrangedSubview(wrapped.asView())
//    }
//    
//    // Обновление карточки по ID
//    func updateCard(id: CardID, with data: Any) {
//        cards[id]?.update(with: data)
//    }
//}
//
//final class InfoCards {
//    // Тип/группа карточки → отвечает за стиль (фон)
//    enum InfoCardType {
//        case western
//        case chinese
//        case year
//        case statistics
//        
//        var backgroundColor: UIColor {
//            switch self {
//            case .western:    return .systemGray6
//            case .chinese:    return .systemGreen.withAlphaComponent(0.10)
//            case .year:       return .systemYellow.withAlphaComponent(0.10)
//            case .statistics: return .secondarySystemBackground // лучше чем .white для тёмной темы
//            }
//        }
//    }
//    
//    
//    // MARK: - InfoCard (гороскопы и год)
//    final class InfoCard: UpdatableCard {
//        
//        struct DataModel {
//            let title: String
//            let icon: String
//            let name: String
//        }
//        
//        let cardType: InfoCardType
//        private let titleLabel = UILabel()
//        private let iconLabel = UILabel()
//        private let nameLabel = UILabel()
//        private let cardView = UIView()
//        
//        init(cardType: InfoCardType) {
//            self.cardType = cardType
//            setupLabels()
//            setupView(type: cardType)
//        }
//        
//        private func setupLabels() {
//            titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//            titleLabel.textAlignment = .center
//            titleLabel.textColor = .secondaryLabel
//            
//            iconLabel.font = .systemFont(ofSize: 34, weight: .regular)
//            iconLabel.textAlignment = .center
//            
//            nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
//            nameLabel.textAlignment = .center
//            nameLabel.textColor = .label
//        }
//        
//        private func setupView(type: InfoCardType) {
//            let stack = UIStackView(arrangedSubviews: [titleLabel, iconLabel, nameLabel])
//            stack.axis = .vertical
//            stack.spacing = 4
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            
//            cardView.addSubview(stack)
//            cardView.backgroundColor = type.backgroundColor
//            cardView.layer.cornerRadius = 10
//            cardView.layer.shadowOpacity = 0.1
//            cardView.layer.shadowRadius = 4
//            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
//            cardView.translatesAutoresizingMaskIntoConstraints = false
//            
//            NSLayoutConstraint.activate([
//                stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
//                stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//                stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//                stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
//                cardView.widthAnchor.constraint(equalToConstant: 130),
//                cardView.heightAnchor.constraint(equalToConstant: 90)
//            ])
//        }
//        
//        func asView() -> UIView { cardView }
//        
//        func update(with data: DataModel) {
//            titleLabel.text = data.title
//            iconLabel.text = data.icon
//            nameLabel.text = data.name
//        }
//    }
//    
//    
//    // MARK: - StatisticsCard
//    final class StatisticsCard: UpdatableCard {
//        
//        struct DataModel {
//            let title: String
//            let weekDay: String
//            let day: String
//            let week: String
//        }
//        let cardType: InfoCardType
//        private let titleLabel = UILabel()
//        private let weekDayLabel = UILabel()
//        private let dayLabel = UILabel()
//        private let weekLabel = UILabel()
//        private let cardView = UIView()
//        
//        init(cardType: InfoCardType) {
//            self.cardType = cardType
//            setupLabels()
//            setupView(type: cardType)
//        }
//        
//        private func setupLabels() {
//            titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//            titleLabel.textAlignment = .center
//            titleLabel.textColor = .secondaryLabel
//            
//            [weekDayLabel, dayLabel, weekLabel].forEach {
//                $0.font = .systemFont(ofSize: 13, weight: .medium)
//                $0.textAlignment = .center
//                $0.textColor = .label
//            }
//        }
//        
//        private func setupView(type: InfoCardType) {
//            let stack = UIStackView(arrangedSubviews: [titleLabel, weekDayLabel, dayLabel, weekLabel])
//            stack.axis = .vertical
//            stack.spacing = 4
//            stack.translatesAutoresizingMaskIntoConstraints = false
//            
//            cardView.addSubview(stack)
//            cardView.backgroundColor = type.backgroundColor
//            cardView.layer.cornerRadius = 10
//            cardView.layer.shadowOpacity = 0.1
//            cardView.layer.shadowRadius = 4
//            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
//            cardView.translatesAutoresizingMaskIntoConstraints = false
//            
//            NSLayoutConstraint.activate([
//                stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
//                stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//                stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//                stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
//                cardView.widthAnchor.constraint(equalToConstant: 130),
//                cardView.heightAnchor.constraint(equalToConstant: 90)
//            ])
//        }
//        
//        func asView() -> UIView { cardView }
//        
//        func update(with data: DataModel) {
//            titleLabel.text = data.title
//            weekDayLabel.text = data.weekDay
//            dayLabel.text = data.day
//            weekLabel.text = data.week
//        }
//    }
//}
