//
//  DateCalculatorViewController.swift
//  DateCalculator
//
//  Created by Dmitry Sokolov on Oct 10, 2025.
//
//  Description:
//  Main screen of the Date Calculator app.
//  Provides an elegant interface for calculating
//  the difference between two dates, switching layouts,
//  and managing settings.
//

import UIKit

/// Main screen of the Date Calculator app.
/// Displays calculation modes, allows layout switching, and provides access to Settings.
final class DateCalculatorViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: DateCalculatorViewModel
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private var currentDateType: DateCalculatorViewModel.DateType = .from
    private var currentLayout: LayoutType = .row {
        didSet { valuesView.layoutType = currentLayout }
    }
    
    private var isSelectingStartDate = true
    
    private var valueLabels: [UILabel] = []
    private var infoCardsCount: Int = 6
    private var infoCards = InfoCards.Container()
    
    // MARK: - Navigation Items
    private var settingsButton: UIBarButtonItem!
    private var viewButton: UIBarButtonItem!
    
    // MARK: - UI Elements
    private let valuesView = ValuesView()
    private lazy var lastSegmentTitle: String = viewModel.visibleSegments[0]
    
    private var periodSegmentedControlBarView: UIView!
    private var periodSegmentedControl: UISegmentedControl!
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
    private var dateButtonsTitlesStackView: UIStackView!
    private var dateBarContainer: UIStackView!
    private var datePickerContainer: UIView!
    
    private var datesToolbarFixed: UIToolbar!
    private var startItem: UIBarButtonItem!
    private var endItem: UIBarButtonItem!
    private var swapItem: UIBarButtonItem!
    
    private var datePickerRealHeight: CGFloat!
    private var bottomToolbarRealHeight: CGFloat!
    
    
    // MARK: - Computed Properties
    private var dates: (from: Date, to: Date) { viewModel.getDates() }
    private var startDate: Date { viewModel.getDates().from }
    private var endDate: Date { viewModel.getDates().to }
    
    // MARK: - Initialization
    init(viewModel: DateCalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect view model delegates
        viewModel.datePickerDelegate = self
        viewModel.segmentsDelegate = self
        viewModel.valuesDelegate = valuesView
        
        view.backgroundColor = .systemBackground
        title = K.Titles.appName
        
        // UI setup
        setupNavigationBar()
        setupPeriodSegmentedControlBarView()
        setupValuesView()
        setupBottomToolbar()
        setupDatePicker()
        setupDateButtonsBarLabels()
        setupDatesButtonsToolbarFixed()
        setupDateButtonsBar()
        setupScrollView()
        
        // Initialize date and horoscope data
        viewModel.handleDateChange(startDate, for: currentDateType)
        let (western, chinese) = viewModel.getHoroscopes(for: Date())
        updateHoroscopeCards(date: startDate, western: western, chinese: chinese)
        viewModel.notifyValuesDelegate()
        
        // Layout margins
        view.preservesSuperviewLayoutMargins = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateSegments(viewModel.visibleSegments)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        datePickerRealHeight = datePickerContainer.bounds.height
        bottomToolbarRealHeight = bottomToolbar.bounds.height
        
        // Store actual rendered heights of the date picker and bottom toolbar.
        // These values are used elsewhere to calculate dynamic offsets.
        datePickerRealHeight = datePicker.bounds.height
        bottomToolbarRealHeight = bottomToolbar.bounds.height
        
        // Align the "Start Date" and "End Date" labels above their corresponding buttons.
        //
        // UIBarButtonItem.customView is inserted into the UIToolbar's view hierarchy
        // only after layout has begun, so during early layout passes these views
        // may not yet be available. We bail out here and try again on the next pass.
        guard
            let startView = startItem.customView,
            let endView = endItem.customView,
            let startSuper = startView.superview,
            let endSuper = endView.superview
        else {
            return
        }
        
        // Convert the center points of the button views into the coordinate space
        // of the labels' container (dateButtonsTitlesStackView).
        //
        // This ensures precise horizontal alignment even when the toolbar scales,
        // transforms, or adapts to different screen sizes.
        let startCenter = startSuper.convert(startView.center, to: dateButtonsTitlesStackView)
        let endCenter   = endSuper.convert(endView.center, to: dateButtonsTitlesStackView)
        
        // Update label positions so they sit exactly above the Start/End buttons.
        // We modify only the X coordinate to preserve vertical alignment.
        startDateLabel.center.x = startCenter.x
        endDateLabel.center.x   = endCenter.x
    }
}

// MARK: - Navigation Bar Setup
extension DateCalculatorViewController {
    
    /// Configures the navigation bar with Settings, Layout
    private func setupNavigationBar() {
        if settingsButton == nil {
            settingsButton = UIBarButtonItem(
                image: UIImage(systemName: "gearshape"),
                style: .plain,
                target: self,
                action: #selector(openSettings)
            )
            navigationItem.leftBarButtonItem = settingsButton
        }
        
        if viewButton == nil {
            viewButton = UIBarButtonItem(
                image: UIImage(systemName: currentLayout.iconName),
                menu: makeViewMenu()
            )
            viewButton.tintColor = C.mazarineBlue
        } else {
            viewButton.image = UIImage(systemName: currentLayout.iconName)
            viewButton.menu = makeViewMenu()
        }
        
        UIView.performWithoutAnimation {
            navigationItem.rightBarButtonItems = [viewButton]
            navigationItem.leftBarButtonItem = settingsButton
        }
    }
    
    /// Creates a layout selection menu (Row / Grid) with current selection highlighted.
    private func makeViewMenu() -> UIMenu {
        let activeColor = C.mazarineBlue
        let inactiveColor = UIColor.systemGray
        
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
        
        let rowAction = UIAction(title: "Row", image: rowImage, state: currentLayout == .row ? .on : .off) { [weak self] _ in
            guard let self = self else { return }
            self.currentLayout = .row
            self.viewButton.image = UIImage(systemName: LayoutType.row.iconName)
            self.viewButton.menu = self.makeViewMenu()
            self.applyLayout(.row)
        }
        
        let gridAction = UIAction(title: "Grid", image: gridImage, state: currentLayout == .grid ? .on : .off) { [weak self] _ in
            guard let self = self else { return }
            self.currentLayout = .grid
            self.viewButton.image = UIImage(systemName: LayoutType.grid.iconName)
            self.viewButton.menu = self.makeViewMenu()
            self.applyLayout(.grid)
        }
        
        func attributedTitle(_ text: String, isActive: Bool) -> NSAttributedString {
            NSAttributedString(string: text, attributes: [.foregroundColor: isActive ? activeColor : inactiveColor])
        }
        
        rowAction.setValue(attributedTitle("Row", isActive: currentLayout == .row), forKey: "attributedTitle")
        gridAction.setValue(attributedTitle("Grid", isActive: currentLayout == .grid), forKey: "attributedTitle")
        
        return UIMenu(title: "Select Layout", children: [rowAction, gridAction])
    }
}

// MARK: - Segmented Control Setup
extension DateCalculatorViewController {
    /// Creates the segmented control bar with “Year / Month / Week / Day” options.
    private func setupPeriodSegmentedControlBarView() {
        periodSegmentedControlBarView = UIView()
        periodSegmentedControlBarView.translatesAutoresizingMaskIntoConstraints = false
        periodSegmentedControlBarView.backgroundColor = .systemBackground
        periodSegmentedControlBarView.layer.cornerRadius = 20 * scaleFactor
        view.addSubview(periodSegmentedControlBarView)
        
        periodSegmentedControlBarView.layer.shadowColor = UIColor.label.cgColor
        periodSegmentedControlBarView.layer.shadowOpacity = 0.05
        periodSegmentedControlBarView.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        periodSegmentedControlBarView.layer.shadowRadius = 4
        periodSegmentedControlBarView.layer.masksToBounds = false
        
        let items = ["Year", "Month", "Week", "Day"]
        let activeColor = C.mazarineBlue
        let inactiveColor = UIColor.secondaryLabel
        let activeFont = UIFont.systemFont(ofSize: 14 * scaleFactor, weight: .semibold)
        let inactiveFont = UIFont.systemFont(ofSize: 14 * scaleFactor, weight: .medium)
        
        periodSegmentedControl = UISegmentedControl(items: items)
        periodSegmentedControl.selectedSegmentIndex = 1
        periodSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        periodSegmentedControl.selectedSegmentTintColor = .systemGray6
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: inactiveColor, .font: inactiveFont], for: .normal)
        periodSegmentedControl.setTitleTextAttributes([.foregroundColor: activeColor, .font: activeFont], for: .selected)
        periodSegmentedControl.subviews.forEach { $0.backgroundColor = .systemBackground }
        periodSegmentedControl.addTarget(self, action: #selector(periodChanged(_:)), for: .valueChanged)
        
        periodSegmentedControlBarView.addSubview(periodSegmentedControl)
        
        NSLayoutConstraint.activate([
            periodSegmentedControlBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            periodSegmentedControlBarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            periodSegmentedControlBarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            periodSegmentedControlBarView.heightAnchor.constraint(equalToConstant: 38 * scaleFactor),
            
            periodSegmentedControl.centerYAnchor.constraint(equalTo: periodSegmentedControlBarView.centerYAnchor),
            periodSegmentedControl.leadingAnchor.constraint(equalTo: periodSegmentedControlBarView.leadingAnchor, constant: 3 * scaleFactor),
            periodSegmentedControl.trailingAnchor.constraint(equalTo: periodSegmentedControlBarView.trailingAnchor, constant: -3 * scaleFactor),
            periodSegmentedControl.heightAnchor.constraint(equalToConstant: 32 * scaleFactor)
        ])
    }
}

// MARK: - Values View Setup
extension DateCalculatorViewController {
    private func setupValuesView() {
        view.addSubview(valuesView)
        valuesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valuesView.topAnchor.constraint(equalTo: periodSegmentedControlBarView.bottomAnchor, constant: 8),
            valuesView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            valuesView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            valuesView.heightAnchor.constraint(equalToConstant: 120 * scaleFactor)
        ])
    }
}

// MARK: - Bottom Toolbar Setup
extension DateCalculatorViewController {
    /// Creates the bottom toolbar with navigation buttons (Back / Today / Forward).
    private func setupBottomToolbar() {
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
        
        bottomToolbar.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        let constant: CGFloat = isSmallScreen ? 16 : 10
        NSLayoutConstraint.activate([
            bottomToolbar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant)
        ])
    }
}

// MARK: - Date Picker Setup
extension DateCalculatorViewController {
    
    /// Adds and positions the date picker at the bottom of the screen.
    private func setupDatePicker() {
        datePickerContainer = UIView()
        datePickerContainer.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainer.backgroundColor = .clear
        datePickerContainer.layer.cornerRadius = 20 * scaleFactor
        
        view.addSubview(datePickerContainer)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date          // Only date, no time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.calendar = Calendar.current
        datePicker.timeZone = .current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePickerContainer.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)

        datePickerContainer.addSubview(datePicker)
        
        let spacing_: CGFloat = scaled(10)
        let offsetBar = transformedOffset(44)
        let offsetPicker = transformedOffset(170)
        let constant = isSmallScreen ? spacing_ + offsetPicker + offsetBar : (offsetPicker - offsetBar) + spacing_
        
        let height: CGFloat = max(156, 170 * scaleFactor)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerContainer.topAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerContainer.bottomAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerContainer.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerContainer.trailingAnchor),
            
            datePickerContainer.bottomAnchor.constraint(equalTo: bottomToolbar.topAnchor, constant: -constant),
            datePickerContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            datePickerContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            datePickerContainer.heightAnchor.constraint(equalToConstant: height)
        ])
        
        datePicker.date = startDate
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
}

// MARK: - Dates Buttons Toolbar Setup (Buttons: StartButton, SwapButton, EndButton)
extension DateCalculatorViewController {
    
    /// Creates a fixed toolbar with Start / Swap / End date buttons.
    private func setupDatesButtonsToolbarFixed() {
        datesToolbarFixed = UIToolbar()
        datesToolbarFixed.translatesAutoresizingMaskIntoConstraints = false
        
        // Containers for start/end labels
        let startContainer = UIView()
        let endContainer = UIView()
        [startContainer, endContainer].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true  // Enable taps
        }
        
        NSLayoutConstraint.activate([
            startContainer.widthAnchor.constraint(equalToConstant: 130 ),
            endContainer.widthAnchor.constraint(equalToConstant: 130 )
        ])
        
        // Labels inside containers
        let startLabel = AnimatedLabel()
        startLabel.text = startDate.readableFormat
        startLabel.font = .systemFont(ofSize: 17, weight: .regular)
        startLabel.textAlignment = .center
        startLabel.textColor = UIColor.label.withAlphaComponent(0.95)
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        startLabel.widthAnchor.constraint(equalToConstant: 130 ).isActive = true
        
        let endLabel = AnimatedLabel()
        endLabel.text = endDate.readableFormat
        endLabel.font = .systemFont(ofSize: 17, weight: .regular)
        endLabel.textAlignment = .center
        endLabel.textColor = UIColor.label.withAlphaComponent(0.95)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.widthAnchor.constraint(equalToConstant: 130 ).isActive = true
        
        startContainer.addSubview(startLabel)
        endContainer.addSubview(endLabel)
        
        NSLayoutConstraint.activate([
            startLabel.centerXAnchor.constraint(equalTo: startContainer.centerXAnchor),
            startLabel.centerYAnchor.constraint(equalTo: startContainer.centerYAnchor),
            endLabel.centerXAnchor.constraint(equalTo: endContainer.centerXAnchor),
            endLabel.centerYAnchor.constraint(equalTo: endContainer.centerYAnchor)
        ])
        
        // Add tap gestures for Start/End selection
        let startTap = UITapGestureRecognizer(target: self, action: #selector(selectStartDate))
        let endTap = UITapGestureRecognizer(target: self, action: #selector(selectEndDate))
        startContainer.addGestureRecognizer(startTap)
        endContainer.addGestureRecognizer(endTap)
        
        // Convert containers to UIBarButtonItems
        startItem = UIBarButtonItem(customView: startContainer)
        endItem = UIBarButtonItem(customView: endContainer)
        
        // Create the Swap button
        swapButton = AnimatedBarButtonItem(
            image: UIImage(systemName: "arrow.left.arrow.right", withConfiguration: ButtonsConfig.disabledConfig),
            style: .plain,
            target: self,
            action: #selector(swapDates)
        )

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        datesToolbarFixed.items = [flex, startItem, flex, swapButton, flex, endItem, flex]

        datesToolbarFixed.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        
        highlightActiveButton()
        
    }
    
    /// Adds "Start Date" and "End Date" labels below the date selection toolbar.
    func setupDateButtonsBarLabels() {
        startDateLabel = AnimatedLabel()
        endDateLabel = AnimatedLabel()
        
        let size: CGFloat = max(11, 12 * scaleFactor)
        startDateLabel.text = "Start Date"
        startDateLabel.textAlignment = .center
        startDateLabel.font = .systemFont(ofSize: size, weight: .medium)
        startDateLabel.textColor = .tertiaryLabel.withAlphaComponent(0.85)
        
        endDateLabel.text = "End Date"
        endDateLabel.textAlignment = .center
        endDateLabel.font = .systemFont(ofSize: size, weight: .medium)
        endDateLabel.textColor = .tertiaryLabel.withAlphaComponent(0.85)
        
        dateButtonsTitlesStackView = UIStackView(arrangedSubviews: [startDateLabel, endDateLabel])
        dateButtonsTitlesStackView.axis = .horizontal
        dateButtonsTitlesStackView.distribution = .fillEqually
        dateButtonsTitlesStackView.alignment = .center
        dateButtonsTitlesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startDateLabel.widthAnchor.constraint(equalToConstant: 130),
            endDateLabel.widthAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    //Add buttons and titleLabels into one vertical stackView
    func setupDateButtonsBar() {
        let spacing: CGFloat = isSmallScreen ? 2 : 8 * scaleFactor
        dateBarContainer = UIStackView()
        dateBarContainer.axis = .vertical
        dateBarContainer.alignment = .fill
        dateBarContainer.distribution = .fill
        dateBarContainer.spacing = spacing
        dateBarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        dateBarContainer.addArrangedSubview(dateButtonsTitlesStackView)
        dateBarContainer.addArrangedSubview(datesToolbarFixed)

        view.addSubview(dateBarContainer)
        
        let spacing_: CGFloat = scaled(10)
        let offsetBar = transformedOffset(44)
        let offsetPicker = transformedOffset(170)
        let constant = isSmallScreen ? spacing_ + offsetPicker + offsetBar : (offsetPicker - offsetBar) + spacing_
        
        NSLayoutConstraint.activate([
            dateBarContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            dateBarContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dateBarContainer.bottomAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: -constant)
        ])
    }
}

//MARK: - Scroll View Setup
extension DateCalculatorViewController {
    
    /// Configures scroll view to display Info Cards horizontally.
    private func setupScrollView() {
            infoScrollView = UIScrollView()
            infoScrollView.translatesAutoresizingMaskIntoConstraints = false
            infoScrollView.showsHorizontalScrollIndicator = false
            infoScrollView.alwaysBounceHorizontal = true
            infoScrollView.backgroundColor = .clear
            infoScrollView.decelerationRate = .fast
            view.addSubview(infoScrollView)
            
            setupInfoCards(scrollView: infoScrollView)

            let h: CGFloat = 100 * scaleFactor
            NSLayoutConstraint.activate([
                infoScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                infoScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                //infoScrollView.bottomAnchor.constraint(equalTo: datePickerContainer.topAnchor, constant: -constant),
                infoScrollView.bottomAnchor.constraint(equalTo: dateBarContainer.topAnchor, constant: -10 * scaleFactor),
                infoScrollView.heightAnchor.constraint(equalToConstant: h)
            ])
        }
}

// MARK: - Info Cards Setup
extension DateCalculatorViewController {
    
    /// Adds horoscope and statistics info cards inside the scroll view.
    private func setupInfoCards(scrollView: UIScrollView) {
        scrollView.addSubview(infoCards.containerView)
        
        // Create cards
        let westernZodiacCard = InfoCards.InfoCard(cardType: .western)
        let westernElementCard = InfoCards.InfoCard(cardType: .western)
        let chineseZodiacCard = InfoCards.InfoCard(cardType: .chinese)
        let chineseElementCard = InfoCards.InfoCard(cardType: .chinese)
        let chineseEnergyCard = InfoCards.InfoCard(cardType: .chinese)
        let yearCard = InfoCards.InfoCard(cardType: .year)
        let statsCard = InfoCards.StatisticsCard(cardType: .statistics)
        
        // Add cards to container
        infoCards.addCard(statsCard, id: .statistics)
        infoCards.addCard(westernZodiacCard, id: .westernZodiac)
        infoCards.addCard(westernElementCard, id: .westernElement)
        infoCards.addCard(yearCard, id: .year)
        infoCards.addCard(chineseZodiacCard, id: .chineseZodiac)
        infoCards.addCard(chineseEnergyCard, id: .chineseEnergy)
        infoCards.addCard(chineseElementCard, id: .chineseElement)
        
        infoCards.containerView.distribution = .fillEqually
        infoCards.containerView.alignment = .center
        
        NSLayoutConstraint.activate([
            infoCards.containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16 * scaleFactor),
            infoCards.containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16 * scaleFactor),
            infoCards.containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            infoCards.containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            infoCards.containerView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        infoCards.animateAppearance()
    }
}

extension DateCalculatorViewController {
    
    /// Updates all Info Cards with new horoscope and date statistics.
    func updateHoroscopeCards(date: Date, western: WesternHoroscope, chinese: ChineseHoroscope) {
        
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
        let monthInYear = "\(12)"
        
        infoCards.updateCard(id: .westernZodiac, with: infoCard.ModelData(title: westernZodiac.title, icon: westernZodiac.icon, name: westernZodiac.name))
        infoCards.updateCard(id: .westernElement, with: infoCard.ModelData(title: westernElement.title, icon: westernElement.icon, name: westernElement.name))
        infoCards.updateCard(id: .chineseZodiac, with: infoCard.ModelData(title: chineseZodiac.title, icon: chineseZodiac.icon, name: chineseZodiac.name))
        infoCards.updateCard(id: .chineseEnergy, with: infoCard.ModelData(title: chineseEnergy.title, icon: chineseEnergy.icon, name: chineseEnergy.name))
        infoCards.updateCard(id: .chineseElement, with: infoCard.ModelData(title: chineseElement.title, icon: chineseElement.icon, name: chineseElement.name))
        infoCards.updateCard(id: .year, with: infoCard.ModelData(title: leapYear.title, icon: leapYear.symbol, name: leapYear.type.name, color: leapYear.color))
        infoCards.updateCard(id: .statistics, with: statCard.ModelData(dataTitle: date.weekDayName,
                                                                       name1: title1, data1: date.monthOfYear, total1: monthInYear,
                                                                       name2: title2, data2: date.weekOfYear, total2: date.weeksInYear,
                                                                       name3: title3, data3: date.dayOfYear, total3: date.daysInYear ))
    }
}

// MARK: - Navigation Bar Actions
extension DateCalculatorViewController {
    
    /// Opens the Settings screen when the gear button is tapped.
    @objc private func openSettings() {
        let settingsVC = SettingsTableViewController(settingsModel: viewModel.settingsModel)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    /// Animates and applies the chosen layout (Row or Grid).
    private func applyLayout(_ layout: LayoutType) {
        print("→ Switched to layout: \(layout.rawValue)")
        UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) { [self] in
            currentLayout = layout
        }
    }
}

extension DateCalculatorViewController {
    func update(with: WesternHoroscope) {
        // Reserved for future updates
    }
}

// MARK: - Segmented Control Actions
extension DateCalculatorViewController {
    
    /// Triggered when user changes the period (Year / Month / Week / Day) in segmented control.
    @objc private func periodChanged(_ sender: UISegmentedControl) {
        print("→ Selected period:", sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "?")
        
        let selectedIndex = sender.selectedSegmentIndex
        UIView.transition(with: valuesView, duration: 0.25, options: [.transitionCrossDissolve]) {
            self.valuesView.layoutIfNeeded()
        }
        
        // After returning from Settings, ensure the same segment remains selected
        lastSegmentTitle = viewModel.visibleSegments[selectedIndex]
        
        viewModel.currentSegmentIndex = selectedIndex
        viewModel.notifyValuesDelegate()
    }
}

// MARK: - Date Buttons Toolbar Actions
extension DateCalculatorViewController {
    
    /// User selected the Start Date button.
    @objc private func selectStartDate() {
        currentDateType = .from
        highlightActiveButton()
        viewModel.handleDateChange(startDate, for: currentDateType)
        datePicker.setDate(startDate, animated: true)
    }
    
    /// User selected the End Date button.
    @objc private func selectEndDate() {
        currentDateType = .to
        highlightActiveButton()
        viewModel.handleDateChange(endDate, for: currentDateType)
        datePicker.setDate(endDate, animated: true)
    }
    
    /// Swaps the From and To dates.
    @objc private func swapDates() {
        impactFeedback.impactOccurred()
        viewModel.swapDates(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
    }
}

// MARK: - Date Picker Actions
extension DateCalculatorViewController {
    
    /// Triggered when the user changes the date in UIDatePicker.
    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel.handleDateChange(sender.date, for: currentDateType)
    }
    
    /// Highlights the active date button (Start or End).
    private func highlightActiveButton() {
        print(currentDateType)
        
        let activeColor = C.merchantMarineBlue
        let inactiveColor = UIColor.secondaryLabel
        let activeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let inactiveFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        
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
    }
}

// MARK: - Bottom Toolbar Actions
extension DateCalculatorViewController {
    
    /// Triggered when Back button is tapped.
    /// Calls: DCViewModel.goBack() → DCModel.goBack()
    @objc private func goBack() {
        impactFeedback.impactOccurred()
        viewModel.goBack(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
    }
    
    /// Triggered when Today button is tapped.
    @objc private func goToday() {
        impactFeedback.impactOccurred()
        viewModel.goToToday(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
    }
    
    /// Triggered when Forward button is tapped.
    @objc private func goForward() {
        impactFeedback.impactOccurred()
        viewModel.goForward(for: currentDateType)
        datePicker.setDate(currentDateType == .from ? startDate : endDate, animated: true)
    }
}

// MARK: - Delegates
extension DateCalculatorViewController: DatePickerUpdatable {
    
    /// Called when the selected date changes in the model.
    func didChangeDate(_ date: Date, for type: DateCalculatorViewModel.DateType) {
        let formatted = date.readableFormat
        if let startLabel = startItem?.customView?.subviews.first as? UILabel,
           let endLabel = endItem?.customView?.subviews.first as? UILabel {
            switch type {
            case .from:
                startLabel.text = formatted
            case .to:
                endLabel.text = formatted
            }
        }
    }
    
    /// Updates horoscope cards based on selected date.
    func updateHoroscopes(for date: Date, western: WesternHoroscope, chinese: ChineseHoroscope) {
        updateHoroscopeCards(date: date, western: western, chinese: chinese)
    }
    
    /// Updates navigation button availability (Back, Forward, Today, Swap).
    func updateNavigationButtons(isBackButtonEnabled: Bool,
                                 isForwardButtonEnabled: Bool,
                                 isTodayButtonEnabled: Bool,
                                 isSwapButtonEnabled: Bool) {
        todayButton.isEnabled = isTodayButtonEnabled
        backButton.isEnabled = isBackButtonEnabled
        forwardButton.isEnabled = isForwardButtonEnabled
        swapButton.isEnabled = isSwapButtonEnabled
    }
}

extension DateCalculatorViewController: SegmentsUpdatable {
    
    /// Updates the segmented control with current segments from Settings.
    func updateSegments(_ segments: [String]) {
        periodSegmentedControl.removeAllSegments()
        for (index, title) in segments.enumerated() {
            periodSegmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        
        // Keep previously selected segment active after returning from Settings
        if let index = viewModel.visibleSegments.firstIndex(where: { $0 == lastSegmentTitle }) {
            periodSegmentedControl.selectedSegmentIndex = index
            viewModel.currentSegmentIndex = index
        } else {
            periodSegmentedControl.selectedSegmentIndex = 0
            viewModel.currentSegmentIndex = 0
        }
        
        viewModel.notifyValuesDelegate()
    }
}

// MARK: - UIImage Utility
extension UIImage {
    /// Creates a solid color image with a given size.
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


extension DateCalculatorViewController {

    /// Returns a value scaled according to screen class (SE, Mini, Normal…).
    func scaled(_ value: CGFloat) -> CGFloat {
        value * scaleFactor
    }
    
    /// Converts a base UI offset into a scaled offset, compensating for
    /// transformed (scaled) height differences.
    func transformedOffset(_ original: CGFloat) -> CGFloat {
        (scaled(original) - original) / 2
    }
}
