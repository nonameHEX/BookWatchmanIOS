//
//  ScanBookView.swift
//  BookWatchman
//
//  Created by Tomáš Kudera on 12.12.2024.
//

import SwiftUI

struct ScanBookView: View {
    @StateObject var scanBookVM: ScanBookViewModel
    
    var body: some View {
        Text("Hello, World! scan book")
    }
}

#Preview {
    ScanBookView(scanBookVM: ScanBookViewModel(apiManager: APIManager()))
}
