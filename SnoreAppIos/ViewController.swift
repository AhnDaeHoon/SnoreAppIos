import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        startRecording()
    }

    @IBAction func stopButtonTapped(_ sender: Any) {
        stopRecording()
    }

    func startRecording() {
        // 오디오 세션 설정
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            // 오디오 파일 저장 경로 설정
            let recordingURL = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            // 오디오 녹음기 초기화
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            // 10초 후 자동 중지
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(stopRecording), userInfo: nil, repeats: false)

        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    @objc func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        timer?.invalidate()
    }

    // 녹음 파일을 저장할 경로
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
