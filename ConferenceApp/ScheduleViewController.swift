import UIKit

class ScheduleViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private var event: EventJson?
    private var schedule: ScheduleJson?
    private var persistanceService: PersistanceService?
    private var scheduleService: ScheduleService?
    private var eventObject: Event? = nil
    private var dateKeys: [String] = []
    private var coreData: Bool = false
    
    convenience init(persistanceService: PersistanceService?, event: EventJson, scheduleService: ScheduleService) {
        self.init()
        self.coreData = false
        self.event = event
        self.persistanceService = persistanceService
        self.scheduleService = scheduleService
        
        //        self.dateKeys = createDateArray()
        
    }
    
        convenience init(persistanceService: PersistanceService?, event: Event) {
            self.init()
            self.coreData = true
            self.eventObject = event
            self.event = EventJson(event: event)
            self.persistanceService = persistanceService
            self.schedule = ScheduleJson(for: event)
            self.dateKeys = createDateArray()
    
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarViewSetUp()
        view.backgroundColor = .white
        
        self.delegate = self
        self.dataSource = self
        
        if coreData {
            pageViewControllerSetUp()

        } else {
            scheduleService?.getSchedule(for: event!.id, handler: loadSchedule)
        }
    }
    
    private func createDailySchedule(lectures: [LectureJson], date: String) -> DailyScheduleViewController {
        return DailyScheduleViewController(lectures: lectures, date: date)
    }
    
    func loadSchedule(schedule: ScheduleJson) {
        DispatchQueue.main.async {
            self.schedule = schedule
            self.dateKeys = self.createDateArray()
            self.pageViewControllerSetUp()
        }
    }
    private func pageViewControllerSetUp() {
        
        let schedule = self.schedule!
        let viewController = createDailySchedule(
            lectures: schedule.lecturesSchedule[dateKeys.first!]!,
            date: dateKeys.first!)
        
        setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func navigationBarViewSetUp() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.backgroundColor = UIColor.white
        self.navigationItem.title = "Schedule"
        if coreData {
            let removeButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                               target: self, 
                                               action: #selector(deleteEvent))
            self.navigationItem.rightBarButtonItem = removeButton
        } else {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveEvent))
            self.navigationItem.rightBarButtonItem = addButton
        }
        
    }
    
    
    @objc private func saveEvent() {
        if let persistanceService = self.persistanceService {
            persistanceService.createEvent(
                withEventId: event!.id,
                eventName: event!.name,
                eventDuration: Int16(event!.duration),
                schedule: schedule!)
            { event in
                print("event ID:", event.id)
            }
        }
        
    }
    @objc public func deleteEvent() {
        if let persistanceService = self.persistanceService {
//            persistanceService.delete(event: event)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func createDateArray() -> [String] {
        let schedule = self.schedule
        return Array(schedule!.lecturesSchedule.keys).sorted(by: <)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let controller = viewController as! DailyScheduleViewController
        let dailyScheduleViewControllerIndex = self.dateKeys.index(of: controller.date)
        let previousViewControllerIndex = dailyScheduleViewControllerIndex! - 1
        
        guard previousViewControllerIndex>=0 else {
            return nil
        }
        guard dateKeys.count >= previousViewControllerIndex else {
            return nil
        }
        
        let schedule = self.schedule!
        return createDailySchedule(
            lectures: schedule.lecturesSchedule[dateKeys[previousViewControllerIndex]]!,
            date: dateKeys[previousViewControllerIndex])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let controller = viewController as! DailyScheduleViewController
        let dailyScheduleViewControllerIndex = self.dateKeys.index(of: controller.date)
        let nextViewControllerIndex = dailyScheduleViewControllerIndex! + 1
        
        guard nextViewControllerIndex < dateKeys.count else {
            return nil
        }
        guard dateKeys.count >= nextViewControllerIndex else {
            return nil
        }
        
        let schedule = self.schedule!
        return createDailySchedule(
            lectures: schedule.lecturesSchedule[dateKeys[nextViewControllerIndex]]!,
            date: dateKeys[nextViewControllerIndex])
    }
    
}
