# CoreDataX

A comprehensive learning project demonstrating Core Data integration in iOS development using both **SwiftUI** and **UIKit** approaches.

## Overview

CoreDataX is an educational iOS application that showcases best practices for persisting and managing data using Apple's Core Data framework. The project demonstrates how to implement the same functionality across two different UI paradigms, making it an excellent resource for learning modern iOS development.

## Features

- **SwiftUI Implementation** - Modern declarative UI approach with Core Data integration
- **UIKit Implementation** - Traditional imperative UI approach with Core Data integration
- **Core Data Management** - Complete CRUD operations for movie data
- **Data Persistence** - Persistent storage using Core Data with NSFetchRequest
- **Image Storage** - Custom transformer for storing images in Core Data
- **Tabbed Interface** - Seamless switching between SwiftUI and UIKit implementations

## Project Structure

```
CoreDataX/
├── Application/          # App entry point and configuration
├── Database/
│   ├── CDX.xcdatamodeld/ # Core Data model definitions
│   ├── Model/            # Core Data model classes (Movie+CoreDataClass, Movie+CoreDataProperties)
│   ├── Provider/         # Store provider for Core Data setup (CDXStoreProvider)
│   └── Transformer/      # Custom value transformers (ImageTransformer)
├── Feature/
│   ├── ContentView.swift # Root view with TabView
│   ├── SwiftUI/
│   │   └── Movie/        # SwiftUI movie list and model
│   └── UIKit/
│       └── Movie/        # UIKit movie list and controllers
└── Assets/               # App assets and colors
```

## Getting Started

### Requirements

- iOS 17.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd AppleFrameworks
```

2. Open the workspace in Xcode:
```bash
open AppleFrameworks.xcworkspace
```

3. Build and run the project on your desired simulator or device.

## Architecture

### Core Data Setup
The project uses a centralized `CDXStoreProvider` that manages the Core Data stack, including:
- Persistent store coordinator
- Managed object model
- Managed object context

### SwiftUI Layer
Located in `Feature/SwiftUI/Movie/`:
- `MovieListVw.swift` - Main SwiftUI view for displaying movies
- `MovieModel.swift` - View model for SwiftUI state management

### UIKit Layer
Located in `Feature/UIKit/Movie/`:
- `MovieListVC.swift` - UITableViewController for displaying movies
- `MovieProvider.swift` - Data provider for UIKit controllers
- `MovieGenerator.swift` - Utility for generating sample movie data

### Data Models
- `Movie+CoreDataClass.swift` - Core Data entity class
- `Movie+CoreDataProperties.swift` - Entity properties and fetch requests
- `ImageTransformer.swift` - Custom NSValueTransformer for image storage

## Key Concepts Demonstrated

### Core Data
- Entity definition and relationships
- Fetch requests and predicates
- Persistent data storage
- Custom value transformers

### SwiftUI
- `@FetchRequest` property wrapper
- View model integration
- State management
- Declarative UI patterns

### UIKit
- UITableViewController and UITableViewDataSource
- NSFetchedResultsController
- View controllers and data providers
- Imperative UI patterns

## Usage

### Adding Movies
The app provides functionality to add and manage movies through the UI. Both implementations support the same operations on the underlying Core Data model.

### Switching Between Implementations
Use the tab bar at the bottom of the screen to switch between:
- **SwiftUI** - Modern approach using SwiftUI
- **UIKit** - Traditional approach using UIKit

## Contributing

This is a learning project. Feel free to fork, modify, and experiment with different approaches to Core Data integration.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Created by SJ Basak as an educational resource for learning iOS development with Core Data.

## Acknowledgments

- Built with Swift and Xcode
- Uses Apple's Core Data framework
- Demonstrates SwiftUI and UIKit integration patterns
