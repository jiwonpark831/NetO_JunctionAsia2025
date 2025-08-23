import UIKit
import FirebaseAuth
import FSCalendar
import FirebaseFirestore
import SwiftUI


struct ScheduleView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        return CalendarViewController()
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {}
}

struct Plan: Codable, Hashable {
    let planName: String
    let startDate: Date
    let endDate: Date
}

// MARK: - Custom Calendar Cell
fileprivate enum PositionInPlan {
    case start, middle, end, single, none
}

fileprivate class PlanCalendarCell: FSCalendarCell {
    
    private weak var selectionView: UIView!
    private var positionInPlan: PositionInPlan = .none

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor(named: "jaorange")?.withAlphaComponent(0.4)
        self.contentView.insertSubview(selectionView, at: 0)
        self.selectionView = selectionView
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionView.frame = self.contentView.bounds.insetBy(dx: 0, dy: 4)
        self.configureUI(for: self.positionInPlan)
    }
    
    func configure(with position: PositionInPlan) {
        self.positionInPlan = position
        self.setNeedsLayout()
    }
    
    private func configureUI(for position: PositionInPlan) {
        selectionView.isHidden = position == .none
        
        if position != .none {
            let cornerRadius = self.selectionView.frame.height / 2
            var maskedCorners: CACornerMask = []
            
            switch position {
            case .start:
                maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .end:
                maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .single:
                maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .middle:
                maskedCorners = []
            case .none:
                break
            }
            
            selectionView.layer.cornerRadius = cornerRadius
            selectionView.layer.maskedCorners = maskedCorners
        }
    }
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    private var calendar: FSCalendar!
    private var plansTableView: UITableView!
    private var reminderCardView: UIView!
    private var reminderCardLabel: UILabel!
    private var reminderCardHeightConstraint: NSLayoutConstraint!
    
    private var plans: [Plan] = []
    private var selectedDatePlans: [Plan] = []
    
    private let db = Firestore.firestore()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private lazy var reminderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        return formatter
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCalendar()
        setupReminderCard()
        setupTableView()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in.")
            return
        }
        fetchPlans(for: userId)
    }
    
    
    private func setupCalendar() {
        calendar = FSCalendar(frame: .zero)
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.register(PlanCalendarCell.self, forCellReuseIdentifier: "dateCell")
        
        calendar.appearance.headerTitleFont = .systemFont(ofSize: 20, weight: .bold)
        calendar.appearance.headerTitleColor = .darkGray
        calendar.appearance.weekdayTextColor = .darkGray
        calendar.appearance.todayColor = UIColor(named: "jayellow")
        calendar.appearance.selectionColor = UIColor(named: "jaorange")
        calendar.appearance.titleSelectionColor = .white
        
        view.addSubview(calendar)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    private func setupReminderCard() {
        reminderCardView = UIView()
        reminderCardView.backgroundColor = .jawhite
        reminderCardView.layer.cornerRadius = 10
        reminderCardView.isHidden = true
        
        reminderCardLabel = UILabel()
        reminderCardLabel.font = .systemFont(ofSize: 15, weight: .medium)
        reminderCardLabel.textColor = .darkGray
        reminderCardLabel.numberOfLines = 0
        reminderCardLabel.textAlignment = .left
        
        reminderCardView.addSubview(reminderCardLabel)
        view.addSubview(reminderCardView)
        
        reminderCardView.translatesAutoresizingMaskIntoConstraints = false
        reminderCardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        reminderCardHeightConstraint = reminderCardView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            reminderCardView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 16),
            reminderCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reminderCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reminderCardHeightConstraint,
            
            reminderCardLabel.leadingAnchor.constraint(equalTo: reminderCardView.leadingAnchor, constant: 16),
            reminderCardLabel.trailingAnchor.constraint(equalTo: reminderCardView.trailingAnchor, constant: -16),
            reminderCardLabel.centerYAnchor.constraint(equalTo: reminderCardView.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        plansTableView = UITableView()
        plansTableView.dataSource = self
        plansTableView.delegate = self
        plansTableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "planCell")
        
        view.addSubview(plansTableView)
        
        plansTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plansTableView.topAnchor.constraint(equalTo: reminderCardView.bottomAnchor, constant: 8),
            plansTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plansTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plansTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func fetchPlans(for userId: String) {
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let planDataArray = document.data()?["plan"] as? [[String: Any]] else {
                print("User document does not exist or plan field is missing.")
                return
            }
            
            self.plans = planDataArray.compactMap { planData in
                guard let planName = planData["planName"] as? String,
                      let startDateTimestamp = planData["startDate"] as? Timestamp,
                      let endDateTimestamp = planData["endDate"] as? Timestamp else {
                    return nil
                }
                return Plan(planName: planName, startDate: startDateTimestamp.dateValue(), endDate: endDateTimestamp.dateValue())
            }
            
            DispatchQueue.main.async {
                self.calendar.reloadData()
                self.updateReminderCard()
            }
        }
    }
    
    
    private func updatePlans(for date: Date) {
        let selectedDay = Calendar.current.startOfDay(for: date)
        
        let filteredPlans = plans.filter { plan in
            let planStartDate = Calendar.current.startOfDay(for: plan.startDate)
            let planEndDate = Calendar.current.startOfDay(for: plan.endDate)
            return selectedDay >= planStartDate && selectedDay <= planEndDate
        }
        
        self.selectedDatePlans = Array(Set(filteredPlans)).sorted { $0.startDate < $1.startDate }
        self.plansTableView.reloadData()
    }
    
    private func updateReminderCard() {
        let today = Calendar.current.startOfDay(for: Date())
        guard let threeDaysLater = Calendar.current.date(byAdding: .day, value: 3, to: today) else { return }

        let upcomingPlan = plans
            .filter { $0.startDate >= today && $0.startDate < threeDaysLater }
            .sorted { $0.startDate < $1.startDate }
            .first

        if let plan = upcomingPlan {
            let startDateString = reminderDateFormatter.string(from: plan.startDate)
            reminderCardLabel.text = "REMINDER\n\(plan.planName)\nstart at \(startDateString)"
            
            self.reminderCardHeightConstraint.constant = 70
            self.reminderCardView.isHidden = false
        } else {
            self.reminderCardHeightConstraint.constant = 0
            self.reminderCardView.isHidden = true
        }
        
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let customCell = cell as? PlanCalendarCell else { return }
        
        let currentDate = Calendar.current.startOfDay(for: date)
        var finalPosition: PositionInPlan = .none

        let plansForDate = plans.filter {
            let planStartDate = Calendar.current.startOfDay(for: $0.startDate)
            let planEndDate = Calendar.current.startOfDay(for: $0.endDate)
            return currentDate >= planStartDate && currentDate <= planEndDate
        }

        if !plansForDate.isEmpty {
            let isStart = plansForDate.contains { Calendar.current.isDate(currentDate, inSameDayAs: $0.startDate) }
            let isEnd = plansForDate.contains { Calendar.current.isDate(currentDate, inSameDayAs: $0.endDate) }
            
            if isStart && isEnd { finalPosition = .single }
            else if isStart { finalPosition = .start }
            else if isEnd { finalPosition = .end }
            else { finalPosition = .middle }
        }
        
        customCell.configure(with: finalPosition)
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "dateCell", for: date, at: position)
        return cell
    }

    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: monthPosition)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        updatePlans(for: date)
        calendar.visibleCells().forEach { cell in
            guard let date = calendar.date(for: cell) else { return }
            self.configure(cell: cell, for: date, at: calendar.monthPosition(for: cell))
        }
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDatePlans.removeAll()
        self.plansTableView.reloadData()
        calendar.visibleCells().forEach { cell in
            guard let date = calendar.date(for: cell) else { return }
            self.configure(cell: cell, for: date, at: calendar.monthPosition(for: cell))
        }
    }
}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDatePlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planCell", for: indexPath)
        let plan = selectedDatePlans[indexPath.row]
        
        let startDateString = dateFormatter.string(from: plan.startDate)
        let endDateString = dateFormatter.string(from: plan.endDate)
        
        cell.textLabel?.text = plan.planName
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        cell.detailTextLabel?.text = "\(startDateString) ~ \(endDateString)"
        cell.detailTextLabel?.textColor = .gray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let selectedDate = calendar.selectedDate else {
            return "Choose date to check schedule."
        }
        
        if selectedDatePlans.isEmpty {
            return "No schedule"
        } else {
            return " "
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
