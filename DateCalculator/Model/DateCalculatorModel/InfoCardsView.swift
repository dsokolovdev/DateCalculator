////
////  InfoCards.swift
////  DateCalculator
////
////  Created by Dmitri  on 21.10.25.
////
//
//import UIKit
//
//// MARK: - Протокол для карточек
//protocol UpdatableCard: AnyObject {
//    associatedtype DataModel
//    func update(with data: DataModel)
//    func asView() -> UIView
//}
//
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
//    enum InfoCardType {
//        case western, chinese, year, statistics
//
//        var backgroundColor: UIColor {
//            switch self {
//            case .western:    return .systemGray6
//            case .chinese:    return .systemGreen.withAlphaComponent(0.1)
//            case .year:       return .systemYellow.withAlphaComponent(0.1)
//            case .statistics: return .secondarySystemBackground
//            }
//        }
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
//// MARK: - Простая карточка (для Western, Chinese, Year)
//final class InfoCard: UpdatableCard {
//    struct DataModel {
//        let title: String
//        let icon: String
//        let name: String
//    }
//
//    private let type: InfoCardsContainer.InfoCardType
//    private let cardView = UIView()
//    private let titleLabel = UILabel()
//    private let iconLabel  = UILabel()
//    private let nameLabel  = UILabel()
//
//    init(type: InfoCardsContainer.InfoCardType) {
//        self.type = type
//        setupUI()
//    }
//
//    private func setupUI() {
//        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = .secondaryLabel
//
//        iconLabel.font = .systemFont(ofSize: 34, weight: .regular)
//        iconLabel.textAlignment = .center
//
//        nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
//        nameLabel.textAlignment = .center
//        nameLabel.textColor = .label
//
//        let stack = UIStackView(arrangedSubviews: [titleLabel, iconLabel, nameLabel])
//        stack.axis = .vertical
//        stack.spacing = 4
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        cardView.addSubview(stack)
//        cardView.backgroundColor = type.backgroundColor
//        cardView.layer.cornerRadius = 10
//        cardView.layer.shadowOpacity = 0.1
//        cardView.layer.shadowRadius  = 4
//        cardView.layer.shadowOffset  = CGSize(width: 0, height: 2)
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
//            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
//            cardView.widthAnchor.constraint(equalToConstant: 130),
//            cardView.heightAnchor.constraint(equalToConstant: 90)
//        ])
//    }
//
//    func asView() -> UIView { cardView }
//
//    func update(with data: DataModel) {
//        titleLabel.text = data.title
//        iconLabel.text  = data.icon
//        nameLabel.text  = data.name
//    }
//}
//
//// MARK: - Карточка статистики
//final class StatisticsCard: UpdatableCard {
//    struct DataModel {
//        let title: String
//        let weekDay: String
//        let day: String
//        let week: String
//    }
//
//    private let type: InfoCardsContainer.InfoCardType
//    private let cardView = UIView()
//    private let titleLabel   = UILabel()
//    private let weekDayLabel = UILabel()
//    private let dayLabel     = UILabel()
//    private let weekLabel    = UILabel()
//
//    init(type: InfoCardsContainer.InfoCardType) {
//        self.type = type
//        setupUI()
//    }
//
//    private func setupUI() {
//        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = .secondaryLabel
//
//        [weekDayLabel, dayLabel, weekLabel].forEach {
//            $0.font = .systemFont(ofSize: 13, weight: .medium)
//            $0.textAlignment = .center
//            $0.textColor = .label
//        }
//
//        let stack = UIStackView(arrangedSubviews: [titleLabel, weekDayLabel, dayLabel, weekLabel])
//        stack.axis = .vertical
//        stack.spacing = 4
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        cardView.addSubview(stack)
//        cardView.backgroundColor = type.backgroundColor
//        cardView.layer.cornerRadius = 10
//        cardView.layer.shadowOpacity = 0.1
//        cardView.layer.shadowRadius  = 4
//        cardView.layer.shadowOffset  = CGSize(width: 0, height: 2)
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 6),
//            stack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
//            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
//            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
//            cardView.widthAnchor.constraint(equalToConstant: 130),
//            cardView.heightAnchor.constraint(equalToConstant: 90)
//        ])
//    }
//
//    func asView() -> UIView { cardView }
//
//    func update(with data: DataModel) {
//        titleLabel.text   = data.title
//        weekDayLabel.text = data.weekDay
//        dayLabel.text     = data.day
//        weekLabel.text    = data.week
//    }
//}
//
