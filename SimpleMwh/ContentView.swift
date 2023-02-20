//
//  ContentView.swift
//  SimpleMwh
//
//  Created by Iván Clemente Moreno on 2/2/23.
//

import SwiftUI



struct ContentView: View {
    @State var data: [String: HourlyData] = [:]
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
    
    
    var body: some View {
        Text(dateFormatter.string(from: Date()))
            .font(.largeTitle)
            .fontWeight(.bold)
        List(data.keys.sorted(), id: \.self) { key in
            if let hourlyData = data[key] {
                    HStack {
                        Text(hourlyData.hour).bold()
                        Text(String(hourlyData.price))
                        Text(hourlyData.units)
                    }
                
            }
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.preciodelaluz.org/v1/prices/all?zone=PCB") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode([String: HourlyData].self, from: data)
                    DispatchQueue.main.async {
                        self.data = decodedData
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}

struct HourlyData: Codable {
    let date: String
    let hour: String
    let isCheap: Bool
    let isUnderAverage: Bool
    let market: String
    let price: Double
    let units: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case hour
        case isCheap = "is-cheap"
        case isUnderAverage = "is-under-avg"
        case market
        case price
        case units
    }
}


