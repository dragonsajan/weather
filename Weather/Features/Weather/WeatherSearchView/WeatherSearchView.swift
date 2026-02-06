//
//  WeatherSearchView.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/6/26.
//

import SwiftUI

import SwiftUI

struct WeatherSearchView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WeatherSearchViewModel(repository: WeatherRepository(apiService: ApiService()))

    /// Return selected city back to caller
    let onSelect: (CityData) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                content
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Main Content View and SearchView
private extension WeatherSearchView {

    var searchField: some View {
        TextField("Search city", text: $viewModel.query)
            .textInputAutocapitalization(.words)
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
    
    var content: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.showEmptyState {
                emptyView
            } else {
                resultsList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    
    var loadingView: some View {
        ProgressView("Searching…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var emptyView: some View {
        Text("No cities found")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


private extension WeatherSearchView {

    var resultsList: some View {
        List(viewModel.results) { city in
            Button {
                onSelect(city)
                dismiss()
            } label: {
                CityRowView(city: city)
            }
        }
        .listStyle(.plain)
    }
}
