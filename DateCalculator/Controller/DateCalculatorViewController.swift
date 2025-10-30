//
//  DateCalculatorViewController.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on 10.10.25.
//
//  Description:
//  Main screen of the Date Calculator app.
//  Provides a simple and elegant interface for calculating
//  the difference between two dates, switching layouts, and managing settings.
//

import UIKit

/// Main screen of the Date Calculator app.
/// Displays calculation modes, allows layout switching, and provides access to Settings.
final class DateCalculatorViewController: UIViewController {

    // MARK: - Properties
    private let viewModel:  DateCalculatorViewModel
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private var currentDateType: DateCalculatorViewModel.DateType = .from
    private var currentLayout: LayoutType = .row {
        didSet { valuesView.layoutType = currentLayout }
    }
    private var isCalculateModeActive = false
    private var isSelectingStartDate = true
    private var valueLabels: [UILabel] = []
    private var infoCardsCount: Int = 6
    private var infoCards = InfoCards.Container()
    
    private var settingsButton: UIBarButtonItem!
    private var calculateButton: UIBarButtonItem!
    private var viewButton: UIBarButtonItem!
    
    private let valuesView = ValuesView()
    
    //private lazy var currentSegmentIndex: Int = 0 { didSet { valuesView.segmentIndex = periodSegmentedControl.selectedSegmentIndex}  }
    private lazy var lastSegmentTitle: String = viewModel.visibleSegments[0]
    
    init(viewModel: DateCalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private var dates: (from: Date, to: Date) { viewModel.getDates() }
    private var startDate: Date { viewModel.getDates().from }
    private var endDate: Date { viewModel.getDates().to }
    
    //MARK: - UI Elements
    private var periodSegmentedControlBarView: UIView!
    private var periodSegmentedControl: UISegmentedControl!
    //private var valuesView: UIView!
    private var valuesStack: UIStackView!
    private var infoScrollView: UIScrollView!
    private var startDateLabel: UILabel!
    private var endDateLabel: UILabel!
    private var datesToolbar: UIToolbar!
    private var startButton: UIBarButtonItem!
    private var swapButton: UIBarButtonItem!
    private var endButton: UIBarButtonItem!
    private var datePicker: UIDatePicker!
    private var todayButton: UIBarButtonItem!
    private var backButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    private var bottomToolbar: UIToolbar!
    
    private var datesToolbarFixed: UIToolbar!
    private var startItem: UIBarButtonItem!
    private var endItem: UIBarButtonItem!
    private var swapItem: UIBarButtonItem!
    
    
    private var datesToolbarFixedBtn: UIToolbar!
    private var sItem: UIBarButtonItem!
    private var eItem: UIBarButtonItem!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.94, alpha: 1.0) //UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        //navigationController?.view.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.94, alpha: 1.0)
        viewModel.datePickerDelegate = self
        viewModel.segmentsDelegate = self
        viewModel.valuesDelegate = valuesView
        //viewModel.animationDelegate = self
        
        view.backgroundColor = .systemBackground
        title = K.Titles.appName
        
        setupNavigationBar()
        setupPeriodSegmentedControlBarView()
        //viewModel.segmentsDelegate = self
        setupValuesView()
        setupBottomToolbar()
        setupDatePicker()
        setupDatesButtonsToolbar()
        setupDateButtonsBarLables()
        setupScrollView()
        setupDatesButtonsToolbarLabels()
        
        
        viewModel.handleDateChange(startDate, for: currentDateType)
        let (western, chinese) = viewModel.getHoroscopes(for: Date())
        updateHoroscopeCards(date: startDate, western: western, chinese: chinese)
        viewModel.notifyValuesDelegate()
        
        
        // 🧩 Настраиваем умные внутренние поля
            view.preservesSuperviewLayoutMargins = true
            view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //valuesView.refreshLayout()
       // updateValuesView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        updateSegments(viewModel.visibleSegments)
        //valuesView.segments = viewModel.visibleSegments
        //valuesView.segmentIndex = periodSegmentedControl.selectedSegmentIndex
        //valuesView.updateDates(from: startDate, to: endDate)
        

    }
}

// MARK: - UPPER BLOCK SETUP
 // MARK: - Navigation Bar Setup
//extension DateCalculatorViewController {
//
//    /// Configures navigation bar with Settings, Layout menu, and Calculate button.
//    private func setupNavigationBar() {
//        let settingsButton = UIBarButtonItem(
//            image: UIImage(systemName: "gearshape"),
//            style: .plain,
//            target: self,
//            action: #selector(openSettings)
//        )
//        navigationItem.leftBarButtonItem = settingsButton
//        
//        let config = UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray])
//        let calculateButton = UIBarButtonItem(
//            image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis", withConfiguration: config),
//            style: .plain,
//            target: self,
//            action: #selector(toggleCalculateMode)
//        )
//
//        let viewMenu = makeViewMenu()
//        let viewButton = UIBarButtonItem(
//            image: UIImage(systemName: currentLayout.iconName),
//            menu: viewMenu
//        )
//        
//        let activeColor = C.mazarineBlue//UIColor(red: 0.15, green: 0.24, blue: 0.46, alpha: 1.00)
//        viewButton.tintColor = activeColor
//
//        navigationItem.rightBarButtonItems = [viewButton, calculateButton]
//    }
//
//    /// Creates and returns a menu for switching between layouts.
//    private func makeViewMenu() -> UIMenu {
//        let activeColor = C.mazarineBlue
//        let inactiveColor = UIColor.systemGray
//        
//        let rowImage = UIImage(systemName: "circle.grid.2x1.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [currentLayout == .row ? activeColor : inactiveColor]))
//        let gridImage = UIImage(systemName: "circle.grid.3x3.fill", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [currentLayout == .grid ? activeColor : inactiveColor]))
//        
//        let actions = [
//            UIAction(
//                title: "Row",
//                image: rowImage,
//                state: currentLayout == .row ? .on : .off,
//                handler: { _ in
//                    self.currentLayout = .row
//                    self.setupNavigationBar()
//                    self.applyLayout(.row)
//                }
//            ),
//            UIAction(
//                title: "Grid",
//                image: gridImage,
//                state: currentLayout == .grid ? .on : .off,
//                handler: { _ in
//                    self.currentLayout = .grid
//                    self.setupNavigationBar()
//                    self.applyLayout(.grid)
//                }
//            )
//        ]
//        
//        func attributedTitle(_ text: String, isActive: Bool) -> NSAttributedString {
//                return NSAttributedString(
//                    string: text,
//                    attributes: [
//                        .foregroundColor: isActive ? activeColor : inactiveColor,
//                        //.font: UIFont.systemFont(ofSize: 15, weight: isActive ? .semibold : .regular)
//                    ]
//                )
//            }
//        
//        actions[0].setValue(attributedTitle("Row", isActive: currentLayout == .row), forKey: "attributedTitle")
//        actions[1].setValue(attributedTitle("Grid", isActive: currentLayout == .grid), forKey: "attributedTitle")
//        
//        return UIMenu(title: "Select Layout", children: actions)
//    }
//}

// MARK: - Navigation Bar Setup
extension DateCalculatorViewController {

    /// Создаёт и конфигурирует navigation bar с кнопками Settings, Layout и Calculate.
    private func setupNavigationBar() {
        // — создаём кнопки только один раз —
        if settingsButton == nil {
            settingsButton = UIBarButtonItem(
                image: UIImage(systemName: "gearshape"),
                style: .plain,
                target: self,
                action: #selector(openSettings)
            )
            navigationItem.leftBarButtonItem = settingsButton
        }

        if calculateButton == nil {
            let config = UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray])
            calculateButton = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis", withConfiguration: config),
                style: .plain,
                target: self,
                action: #selector(toggleCalculateMode)
            )
        }

        if viewButton == nil {
            viewButton = UIBarButtonItem(
                image: UIImage(systemName: currentLayout.iconName),
                menu: makeViewMenu()
            )
            viewButton.tintColor = C.mazarineBlue
        } else {
            // — обновляем только меню и иконку, не пересоздаём объект —
            viewButton.image = UIImage(systemName: currentLayout.iconName)
            viewButton.menu = makeViewMenu()
        }

        // — применяем без анимации, чтобы UIKit не выдал warning —
        UIView.performWithoutAnimation {
            navigationItem.rightBarButtonItems = [viewButton, calculateButton]
            navigationItem.leftBarButtonItem = settingsButton
        }
    }

    /// Формирует меню выбора Layout (Row / Grid) с актуальной подсветкой.
    private func makeViewMenu() -> UIMenu {
        let activeColor = C.mazarineBlue
        let inactiveColor = UIColor.systemGray

        // Активные иконки
        let rowImage = UIImage(
            systemName: "circle.grid.2x1.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                paletteColors: [currentLayout == .row ? activeColor : inactiveColor]
            )
        )
        let gridImage = UIImage(
            systemName: "circle.grid.3x3.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                paletteColors: [currentLayout == .grid ? activeColor : inactiveColor]
            )
        )

        // Действия меню
        let rowAction = UIAction(
            title: "Row",
            image: rowImage,
            state: currentLayout == .row ? .on : .off
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentLayout = .row
            self.viewButton.image = UIImage(systemName: LayoutType.row.iconName)
            self.viewButton.menu = self.makeViewMenu() // просто обновляем меню
            self.applyLayout(.row)
        }

        let gridAction = UIAction(
            title: "Grid",
            image: gridImage,
            state: currentLayout == .grid ? .on : .off
        ) { [weak self] _ in
            guard let self = self else { return }
            self.currentLayout = .grid
            self.viewButton.image = UIImage(systemName: LayoutType.grid.iconName)
            self.viewButton.menu = self.makeViewMenu()
            self.applyLayout(.grid)
        }

        // Красивые цветные подписи
        func attributedTitle(_ text: String, isActive: Bool) -> NSAttributedString {
            NSAttributedString(
                string: text,
                attributes: [.foregroundColor: isActive ? activeColor : inactiveColor]
            )
        }

        rowAction.setValue(attributedTitle("Row", isActive: currentLayout == .row), forKey: "attributedTitle")
        gridAction.setValue(attributedTitle("Grid", isActive: currentLayout == .grid), forKey: "attributedTitle")

        return UIMenu(title: "Select Layout", children: [rowAction, gridAction])
    }
}

 // MARK: - Segmented Control Setup
extension DateCalculatorViewController {
    
    private func setupPeriodSegmentedControlBarView() {
        // Создаём белый контейнер (имитация тулбара)
        periodSegmentedControlBarView = UIView()
        periodSegmentedControlBarView.translatesAutoresizingMaskIntoConstraints = false
        periodSegmentedControlBarView.backgroundColor = .systemBackground
        //periodSegmentedControlBarView.layer.borderColor = UIColor.tertiaryLabel.cgColor //UIColor.systemGray5.cgColor
        //periodSegmentedControlBarView.layer.borderWidth = 0.5
        periodSegmentedControlBarView.layer.cornerRadius = 20
        view.addSubview(periodSegmentedControlBarView)
        
        // Добавляем мягкую тень как у UIToolbar
            periodSegmentedControlBarView.layer.shadowColor = UIColor.label.cgColor
            periodSegmentedControlBarView.layer.shadowOpacity = 0.05       // степень прозрачности тени
            periodSegmentedControlBarView.layer.shadowOffset = CGSize(width: 0, height: 2.5) // направление
            periodSegmentedControlBarView.layer.shadowRadius = 4           // размытие
            periodSegmentedControlBarView.layer.masksToBounds = false      // важно! иначе тень не будет видна

        // Создаём Segmented Control
        let items = ["Year", "Month", "Week", "Day"]
        let activeColor = C.mazarineBlue
        let inactiveColor = UIColor.secondaryLabel
        let activeFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        let inactiveFont = UIFont.systemFont(ofSize: 15, weight: .medium)
        periodSegmentedControl = UISegmentedControl(items: items)
        periodSegmentedControl.selectedSegmentIndex = 1
        periodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        periodSegmentedControl.selectedSegmentTintColor = .systemGray6
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: inactiveColor, .font: inactiveFont], for: .normal)
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: activeColor, .font: activeFont], for: .selected)
        //periodSegmentedControl.setTitleTextAttributes([.foregroundColor: inactiveColor], for: .normal)
        //periodSegmentedControl.setTitleTextAttributes([.foregroundColor: activeColor], for: .selected)
        periodSegmentedControl.subviews.forEach { $0.backgroundColor = .systemBackground }
        periodSegmentedControl.addTarget(self, action: #selector(periodChanged(_:)), for: .valueChanged)

        periodSegmentedControlBarView.addSubview(periodSegmentedControl)

        // Констрейнты
        NSLayoutConstraint.activate([
            periodSegmentedControlBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            periodSegmentedControlBarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            periodSegmentedControlBarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            periodSegmentedControlBarView.heightAnchor.constraint(equalToConstant: 38),

            periodSegmentedControl.centerYAnchor.constraint(equalTo: periodSegmentedControlBarView.centerYAnchor),
            periodSegmentedControl.leadingAnchor.constraint(equalTo: periodSegmentedControlBarView.leadingAnchor,constant: 3),
            periodSegmentedControl.trailingAnchor.constraint(equalTo: periodSegmentedControlBarView.trailingAnchor, constant: -3),
            periodSegmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
}

 
extension DateCalculatorViewController {
    private func setupValuesView() {
        view.addSubview(valuesView)
        valuesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valuesView.topAnchor.constraint(equalTo: periodSegmentedControlBarView.bottomAnchor, constant: 8),
            valuesView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            valuesView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            valuesView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

// MARK: - BOTTOM BLOCK SETUP

// MARK: - Bottom Toolbar Setup (Buttons: Back, Today, Forward)
extension DateCalculatorViewController {

    /// Creates and configures the bottom toolbar with date navigation buttons.
    private func setupBottomToolbar() {
        backButton = UIBarButtonItem()
        todayButton = UIBarButtonItem()
        forwardButton = UIBarButtonItem()
        
        backButton = AnimatedBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(goBack))
        todayButton = AnimatedBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(goToday))
        forwardButton = AnimatedBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: self, action: #selector(goForward))

        todayButton.isEnabled = false
        todayButton.setTitleTextAttributes([.foregroundColor: UIColor.secondaryLabel], for: .disabled)
        todayButton.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        let smallSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        smallSpace.width = 20
        
        bottomToolbar = UIToolbar()
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        bottomToolbar.items = [backButton, smallSpace, todayButton, smallSpace, forwardButton]
        view.addSubview(bottomToolbar)

        NSLayoutConstraint.activate([
            bottomToolbar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

 // MARK: - Date Picker Setup
extension DateCalculatorViewController {
    
    /// Adds and positions the date picker at the bottom of the screen.
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date          // только дата, без времени
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.calendar = Calendar.current
        datePicker.timeZone = .current
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.bottomAnchor.constraint(equalTo: bottomToolbar.topAnchor, constant: -16),
            datePicker.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        datePicker.date = startDate

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
}

 // MARK: - Dates Buttons Toolbark Setup (Buttons: StartButton, SwapButton, EndButton)
extension DateCalculatorViewController {
    
    /// Adds a toolbar above the date picker for selecting start/end dates and swapping them.
    private func setupDatesButtonsToolbar() {
        //let toolbar = UIToolbar()
        datesToolbar = UIToolbar()
        datesToolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datesToolbar)

        startButton = AnimatedBarButtonItem(title: startDate.readableFormat, style: .plain, target: self, action: #selector(selectStartDate))
        endButton = AnimatedBarButtonItem(title: endDate.readableFormat, style: .plain, target: self, action: #selector(selectEndDate))
        
        swapButton = AnimatedBarButtonItem(
            image: UIImage(systemName: "arrow.left.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(swapDates)
        )

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //spaser.width = 20
        flex.width = 10
        datesToolbar.items = [startButton, flex, swapButton, flex, endButton]
        
        highlightActiveButton()

        NSLayoutConstraint.activate([
            datesToolbar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            datesToolbar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            datesToolbar.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -8)
        ])
    }
    
    private func setupDatesButtonsToolbarLabels() {
        datesToolbarFixed = UIToolbar()
        datesToolbarFixed.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datesToolbarFixed)

        NSLayoutConstraint.activate([
            datesToolbarFixed.bottomAnchor.constraint(equalTo: infoScrollView.topAnchor, constant: -8),
            datesToolbarFixed.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            datesToolbarFixed.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            datesToolbarFixed.heightAnchor.constraint(equalToConstant: 44)
        ])

        // 🔹 Создаём контейнеры
        let startContainer = UIView()
        let endContainer = UIView()
        [startContainer, endContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true  // 👈 ВАЖНО!
        }

        NSLayoutConstraint.activate([
            startContainer.widthAnchor.constraint(equalToConstant: 130),
            endContainer.widthAnchor.constraint(equalToConstant: 130)
        ])

        // 🔹 Добавляем UILabel внутрь контейнеров
        let startLabel = AnimatedLabel()
        startLabel.text = startDate.readableFormat
        startLabel.font = .systemFont(ofSize: 17, weight: .medium)
        startLabel.textAlignment = .center
        startLabel.textColor = .label
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        let endLabel = AnimatedLabel()
        endLabel.text = endDate.readableFormat
        endLabel.font = .systemFont(ofSize: 17, weight: .medium)
        endLabel.textAlignment = .center
        endLabel.textColor = .label
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        startContainer.addSubview(startLabel)
        endContainer.addSubview(endLabel)

        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: startContainer.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: startContainer.centerYAnchor),
            endLabel.centerXAnchor.constraint(equalTo: endContainer.centerXAnchor),
            endLabel.centerYAnchor.constraint(equalTo: endContainer.centerYAnchor)
        ])

        // 🔹 Добавляем жесты прямо на контейнеры, не на label
        let startTap = UITapGestureRecognizer(target: self, action: #selector(selectStartDate))
        let endTap = UITapGestureRecognizer(target: self, action: #selector(selectEndDate))
        startContainer.addGestureRecognizer(startTap)
        endContainer.addGestureRecognizer(endTap)

        // 🔹 Превращаем контейнеры в UIBarButtonItem
        startItem = UIBarButtonItem(customView: startContainer)
        endItem = UIBarButtonItem(customView: endContainer)
        //startItem.customView?.addGestureRecognizer(startTap)
        //endItem.customView?.addGestureRecognizer(endTap)

        // 🔹 Кнопка "Swap"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        swapButton = AnimatedBarButtonItem(
            image: UIImage(systemName: "arrow.left.arrow.right", withConfiguration: symbolConfig),
            style: .plain,
            target: self,
            action: #selector(swapDates)
        )

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        datesToolbarFixed.items = [flex, startItem, flex, swapButton, flex, endItem, flex]

        highlightActiveButton()
    }
}

extension DateCalculatorViewController {
    
    func setupDateButtonsBarLables() {
        let stackView = UIStackView()
        startDateLabel = UILabel()
        endDateLabel = UILabel()
        let emptyLabel = UILabel()
        
        startDateLabel.text = "Start Date"
        startDateLabel.textAlignment = .center
        startDateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        startDateLabel.textColor = .secondaryLabel
        
        endDateLabel.textAlignment = .center
        endDateLabel.text = "End Date"
        endDateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        endDateLabel.textColor = .secondaryLabel
        
        stackView.addArrangedSubview(startDateLabel)
        stackView.addArrangedSubview(emptyLabel)
        stackView.addArrangedSubview(endDateLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: datesToolbar.topAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}


//MARK: - MIDDLE BLOCK SETUP

 //MARK: - Scroll View Setup
extension DateCalculatorViewController {
    
    private func setupScrollView() {
        
        // ScrollView
        infoScrollView = UIScrollView()
        infoScrollView.translatesAutoresizingMaskIntoConstraints = false
        infoScrollView.showsHorizontalScrollIndicator = false
        infoScrollView.alwaysBounceHorizontal = true
        infoScrollView.backgroundColor = .clear
        infoScrollView.decelerationRate = .fast
        //infoScrollView.delegate = self
        view.addSubview(infoScrollView)
        
        setupInfoCards(scrollView: infoScrollView)

        // Констрейнты scrollView и контента
        NSLayoutConstraint.activate([
            infoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoScrollView.bottomAnchor.constraint(equalTo: datesToolbar.topAnchor, constant: -40),
            infoScrollView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}

// MARK: - ACTIONS

extension DateCalculatorViewController {
    private func setupInfoCards(scrollView: UIScrollView) {
        scrollView.addSubview(infoCards.containerView)

        // 1️⃣ Создаём карточки
        let westernZodiacCard = InfoCards.InfoCard(cardType: .western)
        let westernElementCard = InfoCards.InfoCard(cardType: .western)
        let chineseZodiacCard = InfoCards.InfoCard(cardType: .chinese)
        let chineseElementCard = InfoCards.InfoCard(cardType: .chinese)
        let chineseEnergyCard = InfoCards.InfoCard(cardType: .chinese)
        let yearCard = InfoCards.InfoCard(cardType: .year)
        let statsCard = InfoCards.StatisticsCard(cardType: .statistics)

        // 2️⃣ Добавляем их в контейнер
        infoCards.addCard(statsCard, id: .statistics)
        infoCards.addCard(westernZodiacCard, id: .westernZodiac)
        infoCards.addCard(westernElementCard, id: .westernElement)
        infoCards.addCard(yearCard, id: .year)
        infoCards.addCard(chineseZodiacCard, id: .chineseZodiac)
        infoCards.addCard(chineseEnergyCard, id: .chineseEnergy)
        infoCards.addCard(chineseElementCard, id: .chineseElement)
        
        infoCards.containerView.distribution = .fillEqually  //.fillProportionally перестали работать смена цвета выбранной кнопки
        infoCards.containerView.alignment = .center

        // 3️⃣ Размещаем контейнер
//        NSLayoutConstraint.activate([
//            infoCards.containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            infoCards.containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            infoCards.containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            infoCards.containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            infoCards.containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
//        ])
        NSLayoutConstraint.activate([
            infoCards.containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            infoCards.containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            infoCards.containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            infoCards.containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            infoCards.containerView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        infoCards.animateAppearance()
    }
}

extension DateCalculatorViewController {
    func updateHoroscopeCards(date: Date, western: WesternHoroscope, chinese: ChineseHoroscope) {
        //guard infoCards.cards.count >= 6 else { return }
        
        //let selectedDate = currentDateType == .from ? startDate : endDate
        let leapYear = LeapYear(isLeap: date.isLeapYear)
        let westernZodiac = western.zodiac
        let westernElement = western.element
        let chineseZodiac = chinese.zodiac
        let chineseEnergy = chinese.energy
        let chineseElement = chinese.element
        typealias infoCard = InfoCards.InfoCard
        typealias statCard = InfoCards.StatisticsCard
        let title1 = "Month"
        let title2 = "Week"
        let title3 = "Day"
        
        infoCards.updateCard(id: .westernZodiac, with: infoCard.ModelData(title: westernZodiac.title, icon: westernZodiac.icon, name: westernZodiac.name))
        infoCards.updateCard(id: .westernElement, with: infoCard.ModelData(title: westernElement.title, icon: westernElement.icon, name: westernElement.name))
        infoCards.updateCard(id: .chineseZodiac, with: infoCard.ModelData(title: chineseZodiac.title, icon: chineseZodiac.icon, name: chineseZodiac.name))
        infoCards.updateCard(id: .chineseEnergy, with: infoCard.ModelData(title: chineseEnergy.title, icon: chineseEnergy.icon, name: chineseEnergy.name))
        infoCards.updateCard(id: .chineseElement, with: infoCard.ModelData(title: chineseElement.title, icon: chineseElement.icon, name: chineseElement.name))
        infoCards.updateCard(id: .year, with: infoCard.ModelData(title: leapYear.title, icon: leapYear.symbol, name: leapYear.type.name, color: leapYear.color))
        infoCards.updateCard(id: .statistics, with: statCard.ModelData(dataTitle: date.weekDayName,
                                                                       name1: title1, data1: date.mothOfYear, total1: date.monthsInYear,
                                                                       name2: title2, data2: date.weekOfYear, total2: date.weeksInYear,
                                                                       name3: title3, data3: date.dayOfYear, total3: date.daysInYear ))
        

    }
}

 // MARK: - Navigation Bar Actions
extension DateCalculatorViewController {

    @objc private func openSettings() {
        let settingsVC = SettingsTableViewController(settingsModel: viewModel.settingsModel)
        navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    
    @objc private func toggleCalculateMode() {
        isCalculateModeActive.toggle()
        
        let activeConfig = UIImage.SymbolConfiguration(paletteColors: [.systemRed, .label])
        let inactiveConfig = UIImage.SymbolConfiguration(paletteColors: [.systemGray, .lightGray])
        
        let newImage = UIImage(
            systemName: "rectangle.and.pencil.and.ellipsis",
            withConfiguration: isCalculateModeActive ? activeConfig : inactiveConfig
        )
        
        navigationItem.rightBarButtonItems?.last?.image = newImage
    }

    private func applyLayout(_ layout: LayoutType) {
        print("→ Switched to layout: \(layout.rawValue)")
        UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
            currentLayout = layout
            //valuesView.updateDates(from: startDate, to: endDate)
        }

    }
}

extension DateCalculatorViewController {
    func update(with: WesternHoroscope) {
        
    }
}

// MARK: - Segmented Control Actions
extension DateCalculatorViewController {

    @objc private func periodChanged(_ sender: UISegmentedControl) {
        print("→ Selected period:", sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "?")
        //print(currentViewMode)
        let selectedIndex = sender.selectedSegmentIndex
        UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { self.valuesView.layoutIfNeeded() }
            
        //after settings windows closed segmented control should be at the same segment as before if not set index as 0, see func updateSegments()
        lastSegmentTitle = viewModel.visibleSegments[selectedIndex]
        
        //valuesView.segmentIndex = selectedIndex
        viewModel.currentSegmentIndex = selectedIndex
        viewModel.notifyValuesDelegate()
        //updateValuesView()
    }
}

 // MARK: - Date Buttons Toolbar Actions
extension DateCalculatorViewController {
    
    @objc private func selectStartDate() {
        //impactFeedback.impactOccurred()
        currentDateType = .from
        highlightActiveButton()
        viewModel.handleDateChange(startDate, for: currentDateType)
        datePicker.setDate(startDate, animated: true)
        //updateValuesView()
        
    }
    
    @objc private func selectEndDate() {
        //impactFeedback.impactOccurred()
        currentDateType = .to
        highlightActiveButton()
        viewModel.handleDateChange(endDate, for: currentDateType)
        datePicker.setDate(endDate, animated: true)
        //updateValuesView()
    }
    
    @objc private func swapDates() {
        impactFeedback.impactOccurred()
        UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
        //UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
        viewModel.swapDates(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
        //viewModel.notifyValuesDelegate()
        //updateValuesView()
        //didChangeDate(isSelectingStartDate ? startDate : endDate, for: isSelectingStartDate ? .from : .to)
        //viewModel.handleDateChange(isSelectingStartDate ? startDate : endDate, for: isSelectingStartDate ? .from : .to)
        
//        (startDate, endDate) = (endDate, startDate)
//        startButton.title = formattedDate(startDate)
//        endButton.title = formattedDate(endDate)
        
        //datePicker.setDate(isSelectingStartDate ? startDate : endDate, animated: true)
    }
}

 // MARK: - Date Picker Actions
extension DateCalculatorViewController {

    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel.handleDateChange(sender.date, for: currentDateType)
        
        //UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
            
            
            //UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
            //updateValuesView()

            //viewModel.notifyValuesDelegate()
        
    }
    
//    func updateValuesView() {
//        valuesView.updateDates(from: startDate, to: endDate)
//    }

    private func highlightActiveButton() {
        print(currentDateType)
//        startButton.tintColor = currentDateType == .from ? C.merchantMarineBlue : .secondaryLabel
//        endButton.tintColor = currentDateType == .to ? C.merchantMarineBlue : .secondaryLabel
        
        let activeColor = C.merchantMarineBlue
        let inactiveColor = UIColor.secondaryLabel
        let activeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let inactiveFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        // активная
        if currentDateType == .from {
            startButton.setTitleTextAttributes([.foregroundColor: activeColor, .font: activeFont], for: .normal)
            endButton.setTitleTextAttributes([.foregroundColor: inactiveColor, .font: inactiveFont], for: .normal)
        } else {
            startButton.setTitleTextAttributes([.foregroundColor: inactiveColor, .font: inactiveFont], for: .normal)
            endButton.setTitleTextAttributes([.foregroundColor: activeColor, .font: activeFont], for: .normal)
        }
        
        guard
            let startLabel = startItem?.customView?.subviews.first as? UILabel,
            let endLabel = endItem?.customView?.subviews.first as? UILabel
        else { return }
        
        if currentDateType == .from {
            startLabel.textColor = activeColor
            startLabel.font = activeFont
            endLabel.textColor = inactiveColor
            endLabel.font = inactiveFont
        } else {
            startLabel.textColor = inactiveColor
            startLabel.font = inactiveFont
            endLabel.textColor = activeColor
            endLabel.font = activeFont
        }
        
        //UIbuttons
        if let startBtn = sItem?.customView as? UIButton,
           let endBtn = eItem?.customView as? UIButton {
            UIView.performWithoutAnimation {
                if currentDateType == .from {
                    startBtn.setTitleColor(activeColor, for: .normal)
                    startBtn.titleLabel?.font = activeFont
                    endBtn.setTitleColor(inactiveColor, for: .normal)
                    endBtn.titleLabel?.font = inactiveFont
                } else {
                    startBtn.setTitleColor(inactiveColor, for: .normal)
                    startBtn.titleLabel?.font = inactiveFont
                    endBtn.setTitleColor(activeColor, for: .normal)
                    endBtn.titleLabel?.font = activeFont
                }
            }
        }
        
        
        
    }
    
    
//    private func highlightActiveButton() {
//        let activeColor = UIColor.systemBlue
//        let inactiveColor = UIColor.systemGray
//        let activeFont = UIFont.systemFont(ofSize: 17, weight: .medium)
//        let inactiveFont = UIFont.systemFont(ofSize: 17, weight: .regular)
//        
//        // Для активной кнопки
//        startButton.setTitleTextAttributes([
//            .foregroundColor: isSelectingStartDate ? activeColor : inactiveColor,
//            .font: isSelectingStartDate ? activeFont : inactiveFont
//        ], for: .normal)
//        
//        // Для неактивной
//        endButton.setTitleTextAttributes([
//            .foregroundColor: isSelectingStartDate ? inactiveColor : activeColor,
//            .font: isSelectingStartDate ? inactiveFont : activeFont
//        ], for: .normal)
//    }
}

// MARK: - Bottom Toolbar Actions
extension DateCalculatorViewController {

    @objc private func goBack() {
        impactFeedback.impactOccurred()
        print("← Previous date")
        //UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
        //UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
        viewModel.goBack(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
        //updateValuesView()
        //viewModel.notifyValuesDelegate()
    }
    
    @objc private func goToday() {
        impactFeedback.impactOccurred()
        print(" Today")
        //UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
        //UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
        viewModel.goToToday(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
        //updateValuesView()
        //viewModel.notifyValuesDelegate()
        
    }
    @objc private func goForward() {
        impactFeedback.impactOccurred()
        print("→ Next date")
        //UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
        //UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
        viewModel.goForward(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
        //updateValuesView()
        //viewModel.notifyValuesDelegate()
    }
}
 
extension DateCalculatorViewController: DatePickerUpdatable {
    func didChangeDate(_ date: Date, for type: DateCalculatorViewModel.DateType) {
        let formatted = date.readableFormat
        
        //UIBarButtonItems
        switch type {
        case .from:
                startButton.title = formatted
        case .to:
            endButton.title = formatted
        }
        
        //UILables
        if let startLabel = startItem?.customView?.subviews.first as? UILabel,
        let endLabel = endItem?.customView?.subviews.first as? UILabel {
            startLabel.text = startButton.title
            endLabel.text = endButton.title
        }
        
        //UIbuttons
        if let startBtn = sItem?.customView as? UIButton,
           let endBtn = eItem?.customView as? UIButton {

            // 🔹 Отключаем анимации и пересчёт layout, чтобы не мигало
            UIView.performWithoutAnimation {
                //CATransaction.begin()
                //CATransaction.setDisableActions(true) // <- ключевая строчка
                switch type {
                case .from:
                    startBtn.setTitle(formatted, for: .normal)
                    startBtn.sizeToFit()
                case .to:
                    endBtn.setTitle(formatted, for: .normal)
                    endBtn.sizeToFit()
                }
                startBtn.layoutIfNeeded()
                endBtn.layoutIfNeeded()
                //CATransaction.commit()
            }
        }
        
        //animateValueLabelsChange()
    }
    
    func updateHoroscopes(for date: Date, western: WesternHoroscope, chinese: ChineseHoroscope) {
        updateHoroscopeCards(date: date, western: western, chinese: chinese)
    }
    
    func updateNavigationButtons(isBackButtonEnabled: Bool, isForwardButtonEnabled: Bool, isTodayButtonEnabled: Bool, isSwapButtonEnabled: Bool) {
        todayButton.isEnabled = isTodayButtonEnabled
        backButton.isEnabled = isBackButtonEnabled
        forwardButton.isEnabled = isForwardButtonEnabled
        swapButton.isEnabled = isSwapButtonEnabled
    }
}

extension DateCalculatorViewController: SegmentsUpdatable {
//    func updateValuesView(_ labels: [String]) {
//        valuesView.updateLayout(with: labels)
//    }
    
    func updateSegments(_ segments: [String]) {
        
        periodSegmentedControl.removeAllSegments()
        for (index, title) in segments.enumerated() {
            periodSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        //keep last current segment index to assign it to segmented control after settings closed
        if let index = viewModel.visibleSegments.firstIndex(where: { $0 == lastSegmentTitle }) {
            periodSegmentedControl.selectedSegmentIndex = index
            viewModel.currentSegmentIndex = index
        } else {
            periodSegmentedControl.selectedSegmentIndex = 0
            viewModel.currentSegmentIndex = 0
            //lastSegmentTitle = viewModel.visibleSegments[0]  //если Месяца не
        }
        
        viewModel.notifyValuesDelegate()
        
        
        //valuesView.updateLayout(for: segments)
        //valuesView.segments = segments
    }
}

extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}


//extension DateCalculatorViewController {
//    func animateValueLabelsChange() {
//        UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { }
//        UIView.transition(with: datesToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { self.datesToolbar.layoutIfNeeded()}
//        //UIView.transition(with: bottomToolbar, duration: 0.25, options: [.transitionCrossDissolve]) { }
//        //UIView.transition(with: infoScrollView, duration: 0.25, options: [.transitionCrossDissolve]) { }
//    }
//}

//// MARK: - Infinite Scroll for InfoCards
//extension DateCalculatorViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.width
//        let contentWidth = scrollView.contentSize.width
//        let offsetX = scrollView.contentOffset.x
//
//        let cards = infoCards.containerView.arrangedSubviews
//        guard cards.count > 2 else { return }
//
//        // 🔹 вправо
//        if offsetX > contentWidth - pageWidth * 0.8 {
//            guard let first = cards.first else { return }
//            infoCards.containerView.removeArrangedSubview(first)
//            first.removeFromSuperview()
//            infoCards.containerView.addArrangedSubview(first)
//            
//            scrollView.layoutIfNeeded()
//            infoCards.containerView.layoutIfNeeded()
//            
//            let shift = first.frame.width + infoCards.containerView.spacing
//            scrollView.setContentOffset(CGPoint(x: offsetX - shift, y: 0), animated: false)
//        }
//
//        // 🔹 влево
//        else if offsetX < pageWidth * 0.3 {
//            guard let last = cards.last else { return }
//            infoCards.containerView.removeArrangedSubview(last)
//            last.removeFromSuperview()
//            infoCards.containerView.insertArrangedSubview(last, at: 0)
//            
//            scrollView.layoutIfNeeded()
//            infoCards.containerView.layoutIfNeeded()
//            
//            let shift = last.frame.width + infoCards.containerView.spacing
//            scrollView.setContentOffset(CGPoint(x: offsetX + shift, y: 0), animated: false)
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.layoutIfNeeded()
//        infoCards.containerView.layoutIfNeeded()
//        infoScrollView?.contentSize = infoCards.containerView.frame.size
//    }
//}
