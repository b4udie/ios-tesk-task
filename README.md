# 📱 TransactionsTestTask

**Bitcoin Transaction Management iOS Application**  
*Built with Swift, Combine, Core Data, and MVVM-C Architecture*

## 🎯 Project Overview

TransactionsTestTask is an iOS application that allows users to manage Bitcoin transactions with real-time Bitcoin rate monitoring and offline support. The app demonstrates modern iOS development practices including reactive programming, dependency injection, and clean architecture.

## 🏗️ Architecture

### **MVVM-C (Model-View-ViewModel-Coordinator)**
- **Models**: Core business entities and data transfer objects
- **Views**: UI components and view controllers
- **ViewModels**: Business logic and state management with Inputs-Outputs pattern
- **Coordinators**: Navigation flow management

### **Key Architectural Principles**
- ✅ **Separation of Concerns**: Clear boundaries between layers
- ✅ **Dependency Injection**: Centralized service management
- ✅ **Reactive Programming**: Combine framework for data flow
- ✅ **Protocol-Oriented Design**: Interface-based programming

## 🚀 Key Features

### **1. Transaction Management**
- ✅ Add income and expense transactions
- ✅ Categorize expenses (Food, Transport, Entertainment, etc.)
- ✅ Pagination support (20 items per page)
- ✅ Real-time balance calculation
- ✅ Transaction grouping by date

### **2. Bitcoin Rate Monitoring**
- ✅ Real-time Bitcoin price updates (every 2 minutes)
- ✅ Offline caching with Core Data
- ✅ Network reachability monitoring
- ✅ Automatic fetch on network restoration

### **3. Analytics & Logging**
- ✅ Comprehensive event tracking
- ✅ Error logging and monitoring
- ✅ Transaction analytics
- ✅ Network request analytics
- ✅ App lifecycle tracking

### **4. Offline Support**
- ✅ Core Data persistence
- ✅ Cached Bitcoin rates
- ✅ Transaction history
- ✅ Balance persistence

## 🛠️ Technical Stack

### **Core Technologies**
- **Swift 5.9+** - Modern Swift programming
- **Combine** - Reactive programming framework
- **Core Data** - Data persistence
- **UIKit** - User interface framework

### **Dependencies & Services**
- **Network Layer** - Custom HTTP client with plugin system
- **Analytics Service** - Event tracking and logging
- **Design System** - Centralized UI styling

### **Design Patterns**
- **MVVM-C** - Architecture pattern
- **Inputs-Outputs** - ViewModel communication pattern
- **Dependency Injection** - Service management
- **Repository Pattern** - Data access abstraction
- **Plugin Pattern** - Extensible network layer

## 🔧 Setup & Installation

### **Prerequisites**
- iOS 17.5+ deployment target

### **Installation Steps**
1. Clone the repository
   ```bash
   git clone <repository-url>
   cd TransactionsTestTask
   ```

2. Open the project in Xcode
   ```bash
   open TransactionsTestTask.xcodeproj
   ```

3. Build and run the project
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### **Configuration**
- No additional configuration required
- All services are self-contained
- Bitcoin API uses public endpoints

## 🎨 Design System

### **Color Palette**
```swift
// Primary Colors
.primaryBlue      // #3366FF
.primaryPurple    // #6633CC
.primaryPink      // #CC3366

// Secondary Colors
.secondaryGreen   // #33CC66
.successGreen     // System Green
.errorRed         // System Red

// Background Colors
.backgroundDark   // #1A1A33
.backgroundMedium // #331A33
.backgroundLight  // #1A3340
```

### **Typography & Spacing**
- **Corner Radius**: 12px (small), 16px (medium), 20px (large)
- **Spacing**: 4px (small), 8px (medium), 16px (large), 24px (extra large)
- **Shadows**: Multiple shadow presets for different UI elements

### **Gradients**
- **Main Background**: Dark to light blue gradient
- **Header**: Blue to purple to pink gradient
- **Buttons**: Green gradient
- **Cards**: Glass effect with transparency

## 🔄 MVVM Inputs-Outputs Pattern

### **ViewModel Structure**
```swift
final class MainViewModel {
    struct Inputs {
        let addTransactionTap: () -> Void
        let addIncomeTap: () -> Void
        let incomeEntered: (String) -> Void
        let loadMore: () -> Void
    }
    
    struct Outputs {
        let balance: AnyPublisher<Double, Never>
        let bitcoinRate: AnyPublisher<Double, Never>
        let transactionGroups: AnyPublisher<[TransactionGroupViewModel], Never>
        let showAddTransaction: AnyPublisher<Void, Never>
        let showAddIncomeAlert: AnyPublisher<Void, Never>
        let showError: AnyPublisher<String, Never>
    }
    
    let output: Outputs
    lazy var inputs: Inputs = { ... }()
}
```

### **Usage in ViewController**
```swift
// Inputs (actions)
@objc func addTransactionTapped() {
    viewModel.inputs.addTransactionTap()
}

// Outputs (data binding)
viewModel.output.balance
    .sink { [weak self] balance in
        self?.balanceLabel.text = String(format: "%.4f BTC", balance)
    }
    .store(in: &cancellables)
```

## 🌐 Network Layer

### **Architecture**
- **NetworkClient**: Base HTTP client interface
- **NetworkService**: High-level service abstraction
- **NetworkPlugin**: Extensible plugin system
- **URLSessionNetworkClient**: Concrete implementation

### **Plugins**
- **LoggingPlugin**: Request/response logging
- **BitcoinRateAnalyticsPlugin**: Bitcoin rate analytics

## 💾 Data Persistence

### **Core Data Entities**
- **CDTransaction**: Transaction records
- **CDBalance**: Current balance state
- **CDBitcoinRate**: Latest Bitcoin rate

### **Data Operations**
- **CRUD Operations**: Create, read, update, delete
- **Batch Operations**: Efficient bulk operations
- **Background Contexts**: Non-blocking data operations

## 🚀 Performance Optimizations

### **Memory Management**
- **Weak References**: Proper memory management
- **Cancellables**: Combine subscription cleanup
- **Background Operations**: Non-blocking UI

### **Data Efficiency**
- **Pagination**: Load data in chunks
- **Caching**: Offline data availability
- **Lazy Loading**: Load data on demand

## 📈 Future Enhancements

### **Technical Improvements**
- **SwiftUI Migration**: Modern UI framework
- **Async/Await**: Latest concurrency model
- **Performance Monitoring**: App performance metrics
