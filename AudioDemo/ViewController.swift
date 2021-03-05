import UIKit

class ViewController: UIViewController {
    
    private let audioControllerBridgeBridge = AudioControllerBridgeBridge()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "Measurement Mode: "
        return label
    }()
    
    private lazy var measureModeSwitch: UISwitch = {
        let modeSwitch = UISwitch()
        modeSwitch.translatesAutoresizingMaskIntoConstraints = false
        modeSwitch.addTarget(self, action: #selector(measureModeSwitchWasToggled(_:)), for: .valueChanged)
        return modeSwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.addSubviews()
        
        self.audioControllerBridgeBridge.initialise(withMeasurementMode: self.measureModeSwitch.isOn)
    }
    
    private func addSubviews() {
        self.view.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        
        self.stackView.addArrangedSubview(self.label)
        self.stackView.addArrangedSubview(self.measureModeSwitch)
    }
    
    @objc private func measureModeSwitchWasToggled(_ sender: UISwitch) {
        print("Measure mode isOn: \(sender.isOn)")
        
        self.audioControllerBridgeBridge.initialise(withMeasurementMode: sender.isOn)
    }
}
