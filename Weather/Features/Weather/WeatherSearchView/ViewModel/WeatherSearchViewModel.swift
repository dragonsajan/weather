//
//  WeatherSearchViewModel.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI
import Combine

@MainActor
final class WeatherSearchViewModel: ObservableObject {

 
    @Published var query: String = ""

    // MARK: - Output
    @Published private(set) var results: [CityData] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var showEmptyState: Bool = false
    @Published var errorMessage: String?

  
    private let repository: WeatherRepositoryProtocol


    private var cancellables = Set<AnyCancellable>()

   
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
        bindSearch()
    }

    private func bindSearch() {
        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self else { return }

                Task {
                    await self.searchCities(for: text)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Search Logic
    private func searchCities(for keyword: String) async {

        guard keyword.count >= 2 else {
            results = []
            showEmptyState = false
            errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil
        showEmptyState = false

        let result = await repository.fetchCityList(keyword: keyword)

        isLoading = false

        switch result {

        case .success(let cities):
            results = cities
            showEmptyState = cities.isEmpty

        case .failure(let error):
            results = []
            showEmptyState = false
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Reset
    func clear() {
        query = ""
        results = []
        showEmptyState = false
        errorMessage = nil
    }
}
