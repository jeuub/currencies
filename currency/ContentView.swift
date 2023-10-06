//
//  ContentView.swift
//  currency
//
//  Created by Eiyub Bodur on 10/06/23.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @State private var input = "100"
    @State private var base = "USD"
    @State private var viewState: ViewStates = .loading
    
    private let cache = NSCache<NSString, NSArray>()
    
    func makeRequest(
        showAll: Bool,
        currencies: [String] = ["USD", "GBP", "EUR"]) async {
            do {
                let currency = try await apiRequest(url: "https://api.apilayer.com/fixer/latest?base=\(base)&amount=\(input)"
                )
                var tempList = [String]()
                
                for currency in currency.rates {
                    if showAll {
                        tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                    } else if currencies.contains(currency.key)  {
                        tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                    }
                    tempList.sort()
                }
                
                viewState = .success(tempList)
                cache.setObject(tempList as NSArray, forKey: "currency")
            } catch {
                print(error)
                viewState = .error(error)
            }
        }
    
    var body: some View {
        switch viewState {
        case .success(let info):
            succsses(info)
        case .error(_):
            failure
        case .loading:
            loading
                .onAppear {
                    Task {
                        await makeRequest(showAll: true)
                    }
                }
        }
    }
    
    private func succsses(_ info: [String]) -> some View {
        VStack {
            HStack {
                Text("Currencies")
                    .font(.system(size: 32))
                    .bold()
            }
            
            NavigationView {
                VStack {
                    List {
                        ForEach(info, id: \.self) { currency in
                            NavigationLink {
                                CurrencyDetail(money: String(currency))
                            } label: {
                                Text(currency)
                            }
                            .navigationTitle("Available currencies")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.background)
                    
                    Divider()
                    
                    VStack {
                        VStack(spacing: 16) {
                            
                            TextField("Enter a currency" ,text: $base)
                        }
                        .textFieldStyle(CustomTextFieldStyle())
                        
                        Button("Convert!") {
                            Task {
                                await makeRequest(showAll: true)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.background)
    }
    
    var failure: some View {
        VStack(spacing: 100) {
            Text("Couldn't load currencies")
            
            Button {
                Task {
                    await makeRequest(showAll: true)
                }
            } label: {
                HStack {
                    Text("Reload")
                    
                    Image(systemName: "arrow.2.circlepath")
                }
            }

        }
    }
    
    var loading: some View {
        ProgressView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
