import UIKit

class ViewController: UIViewController {
    
    private let audioControllerBridgeBridge = AudioControllerBridgeBridge()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()
    
    private lazy var recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(recordButtonWasTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(playButtonWasTapped(_:)), for: .touchUpInside)
        return button
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
        
        self.stackView.addArrangedSubview(self.recordButton)
        self.stackView.addArrangedSubview(self.playButton)
        self.stackView.addArrangedSubview(self.measureModeSwitch)
    }
    
    @objc private func recordButtonWasTapped(_ sender: UIButton) {
        print("Record button was tapped")
    }
    
    @objc private func playButtonWasTapped(_ sender: UIButton) {
        print("Play button was tapped")
    }
    
    @objc private func measureModeSwitchWasToggled(_ sender: UISwitch) {
        print("Measure mode isOn: \(sender.isOn)")
        
        self.audioControllerBridgeBridge.initialise(withMeasurementMode: sender.isOn)
    }
}
