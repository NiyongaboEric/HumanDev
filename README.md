# Seymo Pay Mobile App

## Getting Started

**Installing Packages**: After cloning repository, run ***flutter pub get*** in the terminal to install all dependencies.
```bash
flutter pub get
```

## Folder Structure

- #### Data Layer:
    - **Purpose**: The data layer is responsible for handling data access and retrieval. It interacts with external data sources, such as APIs or local storage, to fetch and store data for the application.
    - **Components**:
        - **models**: This folder contains data models, which are simple Dart classes representing the structure of the data. These models are used to deserialize incoming data from APIs and serialize data before sending it to the backend.
        - **repositories**: The data repositories encapsulate the logic to access data from various sources. They provide an abstraction layer between the data sources and the domain layer. Each repository implements interfaces defined in the domain layer.
        - **data_sources**: This folder contains classes that interact with external data sources, such as APIs or databases. For example, you might have an ApiDataSource that makes HTTP requests to fetch data from a REST API.

- #### Domain Layer:
    - **Purpose**: The domain layer contains the core business logic of the application. It represents the application's business domain and the use cases that define how the application should behave.
    - **Components**:
        - **entities**: Entities are simple Dart classes that represent core business objects or models. They are purely data structures and should not contain any business logic.
        - **repositories**: The domain layer defines abstract repository interfaces that define the methods to access data from the data layer. These interfaces are implemented by the data layer, allowing the domain layer to interact with the data layer without being dependent on its implementation details.
        - **use_cases**: Use cases represent application-specific business logic. They define the operations or actions that can be performed in the application. For example, a "GetUserListUseCase" might represent the logic to fetch a list of users from the data layer.

- #### Presentation Layer:
    - **Purpose**: The presentation layer handles the user interface (UI) and user interactions. It is responsible for rendering the UI screens and responding to user input.
    - **Components**:
        - **bloc**: BLoC stands for Business Logic Component. BLoC is a design pattern used to manage state and handle UI interactions in a predictable manner. It acts as a mediator between the presentation layer and the domain layer. BLoC takes input events from the UI, processes them using business logic from the domain layer (via use cases), and emits states back to the UI for rendering. It helps to keep the UI code separate from the business logic.
        - **pages**: This folder contains UI screens or pages. Each page represents a specific screen that the user interacts with. It uses BLoC to manage its state and business logic.
        - **widgets**: Reusable UI components that can be used across multiple screens. Widgets help in organizing the UI code and promoting code reuse.
        - **utils**: Utility classes or helper functions that assist with UI rendering or other common tasks.

### Folder Structure (Visual)

 ```bash
 📁 seymo_pay_frontend_mobile_app/
├── 📁 lib/
│   ├── 📁 data/  # (Data Layer - Layer in charge of interacting with APIs)
│   │   ├── 📁 models/  # (Data Models)
│   │   ├── 📁 repositories/  # (Data Repositories)
│   │   ├── 📁 data_sources/  # (Data Sources, e.g., API calls, local storage)
│   │   └── ...
│   ├── 📁 domain/  # (Domain Layer - Layer in charge of transforming the data that comes from the data layer.)
│   │   ├── 📁 entries/  # (Business Domain Models/Entities)
│   │   ├── 📁 repositories/  # (Abstract Repositories)
│   │   ├── 📁 use_cases/  # (Application Business Logic - Specific Functionality a BLoC is responsible for)
│   │   └── ...
│   ├── 📁 ui/  # (User Interface Layer)
│   │   ├── 📁 screens/  # (UI Screens/Pages)
│   │   │   ├── 📁 administrators/  # (Administrators UI)
│   │   │   ├── 📁 auth/  # (Screens/Pages During Registration/Login)
│   │   │   ├── 📁 main/  # (Main Page With Bottom Navigation)
│   │   │   ├── 📁 parents/  # (Parents UI)
│   │   │   ├── 📁 school_owner/  # (School Owners UI)
│   │   │   └── ...
│   │   ├── 📁 widgets/  # (Reusable UI Components/Widgets)
│   │   ├── 📁 utilities/  # (Utility Classes/Helpers)
│   │   └── ...
│   ├── 📄 main.dart
│   └── ...
├── 📄 pubspec.lock
├── 📄 pubspec.yaml
└── ...
 ```