//
//  WeatherViewController.swift
//  RXSwiftDemo
//
//  Created by temptempest on 26.12.2022.
//

import UIKit
import SnapKit
import RxSwift

final class WeatherViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private lazy var cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.systemGray6
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.placeholder = "Enter city name ..."
        textField.layer.cornerRadius = 8
        textField.layer.cornerCurve = .continuous
        textField.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = UIColor.theme.naturalBlack
        return textField
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        label.textColor = UIColor.theme.naturalBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor.theme.naturalBlack
        label.textAlignment = .left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupUI() {
        title = "Good Weather"
        view.backgroundColor = .white
        cityNameTextField.returnKeyType = .search 
        view.addSubview(cityNameTextField)
        view.addSubview(temperatureLabel)
        view.addSubview(humidityLabel)
    }
    
    private func setupConstraints() {
        cityNameTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(80)
        }
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityNameTextField.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-36)
            $0.height.equalTo(100)
        }
        humidityLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().offset(-36)
            $0.height.equalTo(60)
        }
    }
}

extension WeatherViewController {
    private func displayWeather(_ weather: Weather?) {
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) °C"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "🙈"
            self.humidityLabel.text = "No Data"
        }
    }
    
    private func fetchWeather(by cityName: String) {
        guard let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let url = Constants.Weather.weatherEndpoint(cityName: cityEncoded ).url
        let response = Resource<WeatherResult>(url: url)
        let search = URLRequest.load(resource: response)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        search.map { "\($0.main.temp) °C" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        search.map { "\($0.main.humidity) 💦" }
            .drive(self.humidityLabel .rx.text)
            .disposed(by: disposeBag)
    }
}
