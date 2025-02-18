//
//  PortfolioDetailView.swift
//  stock-app
//
//  Created by Varun Mehta on 17/04/24.
//

import SwiftUI


struct PortfolioDetailView: View {
    
    @ObservedObject var viewModel = PortfolioSectionViewModel()
    //    let symbol: String // Symbol of the stock
    let ticker: String
    let companyName: String
    
    @State private var portfolioItem: PortfolioItem?
    @State private var isFetching: Bool = false
    @State private var isTradeSheetPresented = false
    @State private var showToast = false
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Portfolio")
                .font(.title)
                .padding(.bottom, 5)
//            if isFetching {
//                ProgressView()
//            } else {
                
                if let portfolioItem = portfolioItem {
                    // Display portfolio details
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Shares owned:")
                                    .bold()
                                    .font(.callout)
                                Text("\(portfolioItem.quantity)")
                                    .font(.callout)
                            }
                            HStack {
                                Text("Avg. Cost / Share:")
                                    .bold()
                                    .font(.callout)
                                Text("$\(String(format: "%.2f", portfolioItem.averageValuePerShare))")
                                    .font(.callout)
                            }
                            HStack {
                                Text("Total Cost:")
                                    .bold()
                                    .font(.callout)
                                Text("$\(String(format: "%.2f", portfolioItem.totalCost))")
                                    .font(.callout)
                            }
                            HStack {
                                Text("Change:")
                                    .bold()
                                    .font(.callout)
                                Text("$\(String(format: "%.2f", portfolioItem.change))")
                                    .foregroundColor(portfolioItem.change < 0 ? .red : (portfolioItem.change > 0 ? .green : .gray))
                                    .font(.callout)
                            }
                            HStack {
                                Text("Market Value:")
                                    .bold()
                                    .font(.callout)
                                Text("$\(String(format: "%.2f", portfolioItem.marketValue))")
                                    .foregroundColor(portfolioItem.change < 0 ? .red : (portfolioItem.change > 0 ? .green : .gray))
                                    .font(.callout)
                            }
                            Spacer()
                        }

                        
                        HStack{
                            
                            Button(action: {
                                                                                       isTradeSheetPresented = true // Open the trade sheet when the button is tapped
                            }) {
                                Text("Trade")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 140)
                                    .background(Color.green)
                                    .cornerRadius(30)// Customized green trade
                            }
                         
                        }
                        
                        
                    }
                } else {
                    HStack{
                        VStack{
                            Text("You have 0 shares of \(ticker)")
                            Text("Start Trading!")
                        }
                        
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {
                               
                                                                          isTradeSheetPresented = true // Open the trade sheet when the button is tapped
                            }) {
                                Text("Trade")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.green)
                                    .cornerRadius(30)// Customized green trade
                                
                            }
                            Spacer()
                        }
                        
                    }
                    
                    
//                }
            }
        }
        .onAppear {
            // Fetch portfolio item by symbol
            fetchPortfolioItem()
        }
        .sheet(isPresented: $isTradeSheetPresented) {
            TradeSheetView(isPresented: $isTradeSheetPresented, stockName: ticker,companyName:companyName,viewModel: viewModel,portfolioItem: portfolioItem) // Pass available money here
        }
        .onReceive(viewModel.$cashBalance) { _ in
            fetchPortfolioItem()
            // Refresh the view when cashBalance changes
            // You can perform additional actions here if needed
        }
    }
    
    func fetchPortfolioItem() {
        isFetching = true
        viewModel.fetchPortfolioItem(by: ticker) { portfolioItem in
            self.portfolioItem = portfolioItem
            self.isFetching = false
        }
        
    }
//    func fetchCurrentPriceAndBalance() {
//        isFetching = true
//        fetchCurrentPrice()
//    }
//
//    // Function to fetch current price
//    func fetchCurrentPrice() {
//        viewModel.fetchCurrentPrice(for: ticker) { currentPrice in
//            if let currentPrice = currentPrice {
//                self.currentPrice = currentPrice
//                self.fetchWalletBalance()
//            } else {
//                print("Error: Current price is nil")
//                self.isFetching = false
//            }
//        }
//    }
//
//    // Function to fetch wallet balance
//    func fetchWalletBalance() {
//        viewModel.fetchWalletBalance()
//    }




}

struct PortfolioDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        PortfolioDetailView(ticker: "AAPL" ,companyName: "Apple Inc"// Provide a value for currentPrice here
                           ) // Provide a value for cashBalance here)
    }
}

import Alamofire

struct TradeSheetView: View {
    @Binding var isPresented: Bool // Binding to control the presentation of the sheet
    let stockName: String // Name of the stock
    let companyName:String
    let viewModel: PortfolioSectionViewModel
    let portfolioItem: PortfolioItem?
//    @State private var availableMoney: Double = 0 // Available uninvested money
    @State private var currentPrice: Double = 0 // Current price of the stock
    @State private var showSuccessSheet = false
    @State private var quantity = 0// Text field for entering the number of shares
    @State private var error: String? // Error message
    @State private var quantityText :String=""
    @State private var successMessage : String?
    @State private var showToast = false
    @State private var currentBalance: Double = 0 // Current balance
//    @Binding var showToast: Bool
    // Function to fetch wallet balance
    func fetchWalletBalance() {
        AF.request("http://54.189.131.70/api/wallet")
            .responseDecodable(of: WalletBalanceResponse.self) { response in
                switch response.result {
                case .success(let balanceResponse):
                    DispatchQueue.main.async {
                        self.currentBalance = balanceResponse.walletBalance
                    }
                case .failure(let error):
                    print("Error fetching wallet balance: \(error)")
                }
            }
    }

    
    var body: some View {
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false // Close the sheet when close button is tapped
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.gray)
                            .font(.body)
                            .padding()
                    }
                }
                .padding(.trailing)
                VStack {
                    HStack {
                        Text("Trade \(companyName) \(quantity == 0 ? "share" : (quantity > 1 ? "shares" : "Share"))")
                            .font(.headline)
                            .padding()
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        
                    }
                    Spacer() // Pushes the HStack to the top
                }
                
                
          
                        
                
                            
                            HStack{
                                VStack{
                                    TextField("0", text: $quantityText)
                                        .padding()
                                        .frame(height: 50) // Increase the height of the TextField
                                    
                                        .foregroundColor(quantity == 0 ? .gray : .black) // Gray text if quantity is zero, otherwise black
                                        .keyboardType(.numberPad) // Numeric keyboard for entering shares
                                        .font(.system(size: 80))// Large font for the quantity
                                        .multilineTextAlignment(.leading)
                                        .onChange(of: quantityText) { newValue in
                                            let filtered = newValue.filter { "0123456789".contains($0) }
                                            if filtered != newValue {
                                                self.quantityText = filtered
                                            }
                                            self.quantity = Int(filtered) ?? 0
                                        }
                                }
                                VStack{
                                    Text("\(quantity == 0 ? "Share" : "Shares")")
                                        .font(.title)
                                        .padding(.bottom, 5)
                                }
                 
                                
                            }
                               
                                
                Spacer()
  
//                                Spacer() // Pushes the VStack to the right
 // Align VStack content to the right
                     
                                    HStack{
                                        Spacer()
                                        Text("x $\(String(format: "%.2f", currentPrice))/share = $\(String(format: "%.2f", calculateTotalPrice()))")
                                            .font(.subheadline)
                                           
                                        
                                            
                                    }
                                    .padding(.trailing,10)
                                    
                                
   
                VStack {
                    Spacer() // Pushes the VStack to the bottom
                    
                    VStack(spacing: 20) { // Your existing VStack with Buy and Sell buttons
                        Text("$\(String(format: "%.2f", currentBalance)) is available to buy \(stockName)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .padding(.bottom, 5)
                        
                        HStack(spacing: 20) {
//                            Spacer()
                            Button(action: {
                                // Handle buy action
                                handleTradeAction(isBuying: true,currentBalance: currentBalance)
                            })
                            {
                                Text("Buy")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.green)
                                    .cornerRadius(30)// Customized green trade
                                
                            }

                            Spacer()
                            Button(action:{
                                // Handle sell action
                                handleTradeAction(isBuying: false,currentBalance: currentBalance)
                            })
                            {
                                Text("Sell")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.green)
                                    .cornerRadius(30)// Customized green trade
                                
                            }
                            

                        }
                    }
                }
//                if let error = error, showToast {
//                    
//                    VStack {
//                                        Spacer()
//                                        ToastView(message: error)
//                                            .transition(.move(edge: .bottom)) // Slide down animation
//                                            .onAppear {
//                                                // Hide the toast message after a delay
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                                    showToast = false
//                                                }
//                                            }
//                                    }
//                                    .frame(maxWidth: .infinity)
//                                    .alignmentGuide(.bottom) { _ in UIScreen.main.bounds.height * 0.1 }
//                       
//                            }

                
//                if let error = error {
//                    Text(error)
//                        .foregroundColor(.red)
//                        .padding()
//                }
            }.padding()
            .toast(isShowing: $showToast,text: Text(error ?? "An error occurred"))
            .sheet(isPresented: $showSuccessSheet) {
                SuccessSheetView(message: successMessage ?? "",isPresented: $showSuccessSheet)
                   
            }
           
            .onAppear {
                // Fetch current price and wallet balance when the sheet appears
               fetchWalletBalance()
                fetchCurrentPriceAndBalance()
            }
        }
    func fetchCurrentPriceAndBalance() {
       
        fetchCurrentPrice()
    }

    // Function to fetch current price
    func fetchCurrentPrice() {
        if let portfolioItem = portfolioItem {
            viewModel.fetchCurrentPrice(for: portfolioItem.symbol) { currentPrice in
                if let currentPrice = currentPrice {
                    self.currentPrice = currentPrice
//                    self.fetchWalletBalance()
                } else {
                    print("Error: Current price is nil")
                }
            }
        } else {
            viewModel.fetchCurrentPrice(for: stockName) { currentPrice in
                if let currentPrice = currentPrice {
                    self.currentPrice = currentPrice
//                    self.fetchWalletBalance()
                } else {
                    print("Error: Current price is nil")
                }
            }
        }

    }

    // Function to fetch wallet balance
//    func fetchWalletBalance() {
////        viewModel.fetchWalletBalance()
//    }
               
               // Method to calculate the total price of the trade
//               private func calculateTotalPrice() -> Double {
//                   guard let quantityInt = Int(quantity) else {
//                       return 0
//                   }
//                   // Example calculation, replace with your logic
//                   return Double(quantityInt) * currentPrice // Assuming each share costs $10
//               }
    private func calculateTotalPrice() -> Double {
        // Ensure quantity is non-negative
        guard quantity >= 0 else {
            return 0
        }
        
        // Calculate total price
        return Double(quantity) * currentPrice
    }
               
               // Method to handle the buy/sell action
    private func handleTradeAction(isBuying: Bool,currentBalance: Double) {
//        guard let quantityInt = Int(quantity), quantityInt > 0 else {
//            error = isBuying ? "Cannot buy non-positive shares" : "Cannot sell non-positive shares"
//            return
//        }
        guard quantity > 0 else {
            error = isBuying ? "Cannot buy non-positive shares" : "Cannot sell non-positive shares"
            showToast = true
            return
        }
        
        let totalPrice = calculateTotalPrice()
        
        if isBuying {
            guard totalPrice <= currentBalance else {
                error = "Not enough money to buy"
                showToast = true
                return
            }
            
            // Safely unwrap the optional portfolioItem
            
                // Perform buy action
            viewModel.buyStock(stock:stockName, stockCompanyName:companyName,quantity: quantity, currentUpdatedPrice: currentPrice,currentBalance: currentBalance, onSuccess: { message in
                successMessage = quantity > 1 ? "\(quantity) shares of \(stockName) bought successfully" : "\(quantity) share of \(stockName) bought successfully"
            showSuccessSheet = true
                    
                    // Reset quantity and error state
                    quantity = 0
                    quantityText="0"
                    error = nil
                    
                    // Close the buy modal
                    isPresented = false
                    
                    // Display success message
                    
//                    showToast(message: successMessage)
                }, onError: { errorMessage in
                    // Handle error
                    error = errorMessage
                    showToast = true
                })
           
        } else {
            if let portfolioItem=portfolioItem{
                guard quantity <= portfolioItem.quantity else {
                                // Quantity to sell exceeds the quantity in the portfolio
                                error = "Not enough shares to sell"
                    showToast = true
                                return
                            }
            }
            else {
                error = "Not enough shares to sell"
                showToast = true
                            return
                            // Handle case where portfolioItem is nil
//                            Text("No portfolio item found")
                        }
            
            // Perform sell action
                   viewModel.sellStock(stock: stockName, stockCompanyName: companyName, quantity: quantity, currentUpdatedPrice: currentPrice, currentBalance: currentBalance, onSuccess: { message in
                       // Display success message
                       successMessage = quantity > 1 ? "\(quantity) shares of \(stockName) sold successfully" : "\(quantity) share of \(stockName) sold successfully"
                       showSuccessSheet = true
                       
                       // Reset quantity and error state
                       quantity = 0
                       quantityText="0"
                       error = nil
                       
                       // Close the sell modal
                       isPresented = false
                       
                       
//                       showToast(message: successMessage)
                   }, onError: { errorMessage in
                       // Handle error
                       error = errorMessage
                       showToast = true
                   })
                   }
               }
               
               // Method to display toast message
//               private func showToast(message: String) {
//                   // Display toast message here
//                   print(message)
//               }
           }
//struct SuccessSheetView: View {
//    let message: String
//    
//    
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        VStack {
//            Text("Congratulations!")
//            Text("\(message)")
//                .padding()
//            
//            Button("Done") {
//                isPresented = false
//            }
//            .padding()
//            .background(Color.white)
//            .foregroundColor(.green)
//            .cornerRadius(10)
//        }
//        .padding()
//        .background(Color.green)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//        
//    }
//}
//struct SuccessSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        SuccessSheetView(message: "Apple Inc",isPresented:.constant(true))
//                         // Provide a value for currentPrice here
////                           ) // Provide a value for cashBalance here)
//    }
//}



// Custom Toast View
//struct ToastView: View {
//    let message: String
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                Spacer() // Push the toast to the bottom
//                Text(message)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.black.opacity(0.7))
//                    .cornerRadius(10)
//            }
//        }
//        .padding(.horizontal)
//        .transition(.move(edge: .bottom)) // Slide down animation
//        .frame(maxWidth: .infinity)
//        .alignmentGuide(.bottom) { _ in UIScreen.main.bounds.height * 0.9 } // Adjust this value as needed
//    }
//}

struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: .bottom) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    
                    self.text
                }
                .frame(width: geometry.size.width / 1.2,
                       height: geometry.size.height/18
                )
                .padding()
                .background(Color.black.opacity(0.7))
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      withAnimation {
                        self.isShowing = false
                       
                          
                      }
                    }
                }
                .onTapGesture { // Add tap gesture to dismiss toast on tap anywhere
                                   withAnimation {
                                       self.isShowing = false
                                      
                                   }
                               }
                .opacity(self.isShowing ? 1 : 0)
                .padding(.bottom, 50)
//                .alignmentGuide(.bottom) { _ in UIScreen.main.bounds.height * 0.9 }

            }

        }

    }

}

extension View {

    func toast(isShowing: Binding<Bool>,text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

}



//struct TradeSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        TradeSheetView(isPresented: .constant(true), stockName: "AAPL", availableMoney: 1000.0)
//    }
//}

