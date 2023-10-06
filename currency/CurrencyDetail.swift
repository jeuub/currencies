//
//  CurrencyDetail.swift
//  currency
//
//  Created by Eiyub Bodur on 10/06/23.
//

import SwiftUI
import Alamofire

struct CurrencyDetail: View {
    @State var currencyList = [String]()
    @State private var viewState: ViewStates = .loading
    
    var money: String
    
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
        VStack() {
            HStack() {
                AsyncImage(url: URL(string: "https://flagsapi.com/\(money.prefix(2))/flat/64.png")).frame(maxWidth: 65, maxHeight: 64)
                Text(money.prefix(3))
            }
            
            List {
                ForEach(currencyList, id: \.self) { currency in
                    Text(currency)
                }
            }
            .scrollContentBackground(.hidden)
            
        }
        .background(Color.background)
        .onAppear() {
            Task {
                await makeRequest(showAll: true)
            }
        }
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
    
    
    
    private func makeRequest(
        showAll: Bool = false,
        currencies: [String] = ["USD", "RUB", "EUR", "JPY", "GBP", "AUD", "CAD", "CHF", "CNH", "CZK"]
    ) async {
        do {
            let request = try await apiRequest(url: "https://api.apilayer.com/fixer/latest?base=\(money.prefix(3))&amount=\(1)")
            var tempList = [String]()
            
            for currency in request.rates {
                
                if showAll {
                    tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                } else if currencies.contains(currency.key)  {
                    tempList.append("\(currency.key) \(String(format: "%.2f",currency.value))")
                }
                tempList.sort()
            }
            viewState = .success(tempList)
            currencyList = tempList
        } catch {
            viewState = .error(error)
        }
    }
}

struct CurrencyDetail_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyDetail(money: "None")
    }
}
