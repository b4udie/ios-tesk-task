# 📱 TransactionsTestTask

**Bitcoin Transaction Management iOS Application**  
*Built with Swift, Combine, Core Data, and MVVM-C Architecture*

## 🎯 Project Overview

TransactionsTestTask is a sophisticated iOS application that allows users to manage Bitcoin transactions with real-time Bitcoin rate monitoring, offline support, and comprehensive analytics. The app demonstrates modern iOS development practices including reactive programming, dependency injection, and clean architecture.

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
- ✅ **Single Responsibility**: Each component has one clear purpose

## 📁 Project Structure

```
TransactionsTestTask/
├── App/                          # Application layer
│   ├── AppCoordinator.swift     # Root coordinator
│   ├── AppDelegate.swift        # App lifecycle
│   ├── SceneDelegate.swift      # Scene management
│   ├── Main/                    # Main scene
│   │   ├── MainCoordinator.swift
│   │   ├── MainViewController.swift
│   │   ├── MainViewModel.swift
│   │   └── Views/
│   │       ├── TransactionCell.swift
│   │       └── TransactionHeaderView.swift
│   └── AddTransaction/          # Add transaction scene
│       ├── AddTransactionCoordinator.swift
│       ├── AddTransactionViewController.swift
│       ├── AddTransactionViewModel.swift
│       └── Views/
│           └── CategoryCell.swift
├── Models/                       # Data models
│   └── Transactions/
│       ├── Transaction.swift
│       ├── TransactionType.swift
│       └── TransactionGroup.swift
├── Services/                     # Business logic layer
│   ├── ServicesAssembler.swift  # Dependency injection container
│   ├── AnalyticsService/        # Analytics and logging
│   ├── BitcoinRateService/      # Bitcoin rate management
│   ├── TransactionService/      # Transaction management
│   ├── NetworkLayer/            # Network infrastructure
│   └── Helpers/
│       └── PerformOnce.swift    # Singleton wrapper
├── Storage/                      # Data persistence
│   └── CoreDataStack.swift      # Core Data management
├── DesignSystem/                 # UI design system
│   └── DesignSystem.swift       # Colors, shadows, gradients
└── Resources/                    # Assets and configuration
    ├── Assets.xcassets/
    └── TransactionsTestTask.xcdatamodeld/
```

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
- **iOS 15.0+** - Latest iOS features support
- **Combine** - Reactive programming framework
- **Core Data** - Data persistence
- **UIKit** - User interface framework

### **Dependencies & Services**
- **Network Layer** - Custom HTTP client with plugin system
- **Analytics Service** - Event tracking and logging
- **Bitcoin API** - CoinDesk integration
- **Design System** - Centralized UI styling

### **Design Patterns**
- **MVVM-C** - Architecture pattern
- **Inputs-Outputs** - ViewModel communication pattern
- **Dependency Injection** - Service management
- **Repository Pattern** - Data access abstraction
- **Plugin Pattern** - Extensible network layer

## 🔧 Setup & Installation

### **Prerequisites**
- Xcode 15.0+
- iOS 15.0+ deployment target
- macOS 13.0+ (for development)

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

## 🔌 Services Architecture

### **ServicesAssembler**
Central dependency injection container that manages all service instances:

```swift
enum ServicesAssembler {
    // Core services
    static let analyticsService: PerformOnce<AnalyticsService>
    static let transactionService: PerformOnce<TransactionService>
    static let bitcoinRateService: PerformOnce<BitcoinRateService>
    
    // Infrastructure
    static let coreDataStack: PerformOnce<CoreDataStack>
    static let networkReachability: PerformOnce<NetworkReachability>
}
```

### **Service Dependencies**
```
TransactionService
├── TransactionStore (Core Data)
└── AnalyticsService

BitcoinRateService
├── BitcoinRateNetworkService
├── NetworkReachability
├── BitcoinRateStore (Core Data)
└── AnalyticsService
```

## 📊 Data Flow

### **Transaction Flow**
```
User Input → ViewController → ViewModel.input → Service → Core Data → ViewModel.output → UI Update
```

### **Bitcoin Rate Flow**
```
Network Request → BitcoinRateService → Core Data Cache → ViewModel.output → UI Update
```

### **Analytics Flow**
```
Event → AnalyticsService → Event Storage → Logging
```

## 🧪 Testing

### **Test Coverage**
- **Unit Tests**: Service layer testing
- **Mock Objects**: Comprehensive mock implementations
- **Test Scenarios**: Success, failure, and edge cases

### **Test Structure**
```
TransactionsTestTaskTests/
├── Mocks/                       # Mock implementations
│   ├── MockAnalyticsService.swift
│   ├── MockTransactionStore.swift
│   ├── MockBitcoinRateStore.swift
│   ├── MockNetworkReachability.swift
│   └── MockBitcoinRateNetworkService.swift
└── Services/                    # Service tests
    ├── AnalyticsServiceTests.swift
    ├── BitcoinRateServiceTests.swift
    └── TransactionServiceTests.swift
```

### **Running Tests**
1. In Xcode: `Cmd + U`
2. Or via command line:
   ```bash
   xcodebuild test -project TransactionsTestTask.xcodeproj -scheme TransactionsTestTask
   ```

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
- **AnalyticsPlugin**: General analytics tracking

### **Error Handling**
- **NetworkError**: Comprehensive error types
- **Retry Logic**: Automatic retry on failures
- **Offline Fallback**: Cached data when offline

## 💾 Data Persistence

### **Core Data Entities**
- **CDTransaction**: Transaction records
- **CDBalance**: Current balance state
- **CDBitcoinRate**: Latest Bitcoin rate

### **Data Operations**
- **CRUD Operations**: Create, read, update, delete
- **Batch Operations**: Efficient bulk operations
- **Background Contexts**: Non-blocking data operations
- **Migration Support**: Schema evolution

## 📱 User Interface

### **Main Screen**
- **Balance Display**: Current Bitcoin balance
- **Bitcoin Rate**: Real-time USD rate
- **Transaction List**: Paginated transaction history
- **Add Buttons**: Quick access to add transactions

### **Add Transaction Screen**
- **Amount Input**: Bitcoin amount entry
- **Category Selection**: Expense categorization
- **Type Selection**: Income vs. Expense
- **Date Picker**: Transaction date selection

### **UI Components**
- **Custom Cells**: TransactionCell, CategoryCell
- **Custom Headers**: TransactionHeaderView
- **Gradient Backgrounds**: Beautiful visual effects
- **Glass Morphism**: Modern iOS design language

## 🔒 Security & Privacy

### **Data Protection**
- **Core Data Encryption**: Secure data storage
- **Network Security**: HTTPS-only API calls
- **Input Validation**: Client-side validation
- **Error Handling**: Secure error messages

### **Privacy Features**
- **Local Storage**: No external data transmission
- **Analytics**: Anonymous event tracking
- **User Control**: Full data ownership

## 🚀 Performance Optimizations

### **Memory Management**
- **Weak References**: Proper memory management
- **Cancellables**: Combine subscription cleanup
- **Background Operations**: Non-blocking UI

### **Data Efficiency**
- **Pagination**: Load data in chunks
- **Caching**: Offline data availability
- **Lazy Loading**: Load data on demand

### **UI Performance**
- **Cell Reuse**: Efficient table view performance
- **Async Operations**: Non-blocking UI updates
- **Image Optimization**: Efficient asset usage

## 🔧 Configuration & Customization

### **Environment Variables**
- **API Endpoints**: Configurable Bitcoin API
- **Update Intervals**: Adjustable refresh rates
- **Page Sizes**: Configurable pagination

### **Feature Flags**
- **Analytics**: Enable/disable tracking
- **Offline Mode**: Force offline operation
- **Debug Mode**: Enhanced logging

## 📈 Future Enhancements

### **Planned Features**
- **Push Notifications**: Price alerts
- **Widgets**: Home screen integration
- **iCloud Sync**: Cross-device synchronization
- **Export Functionality**: Data portability
- **Advanced Analytics**: Detailed insights

### **Technical Improvements**
- **SwiftUI Migration**: Modern UI framework
- **Async/Await**: Latest concurrency model
- **Performance Monitoring**: App performance metrics
- **Accessibility**: Enhanced accessibility support

## 🤝 Contributing

### **Development Guidelines**
1. **Code Style**: Follow Swift style guide
2. **Architecture**: Maintain MVVM-C pattern
3. **Testing**: Ensure test coverage
4. **Documentation**: Update documentation

### **Pull Request Process**
1. Fork the repository
2. Create feature branch
3. Implement changes
4. Add tests
5. Submit pull request

## 📄 License

This project is proprietary and confidential. All rights reserved.

## 👥 Team

- **Val Bratkevich** - Lead iOS Developer
- **Anton Vodolazkyi** - iOS Developer
- **Abodnar** - iOS Developer

## 📞 Support

For technical support or questions:
- **Email**: [contact@company.com]
- **Issues**: GitHub Issues
- **Documentation**: Inline code documentation

---

**Built with ❤️ using modern iOS development practices**
