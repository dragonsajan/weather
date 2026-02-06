# Weather App (SwiftUI + Core Data)

A simple iOS Weather application built using **SwiftUI** for UI and **Core Data** for local data persistence.  

---

## 📸 App Screenshots

| Home | Search | Detail |
|------|--------|--------|
| ![](Resources/01.jpg) | ![](Resources/02.jpg) | ![](Resources/03.jpg) |

---


## Tech Stack

- **Language:** Swift  
- **UI Framework:** SwiftUI  
- **Architecture:** MVVM  
- **Persistence:** Core Data  
- **Networking:** URLSession



## Requirements

- macOS 13+
- Xcode 15+
- iOS 17+
- Swift 5.9+

---

## Project Setup (Step-by-Step)

### 1. Clone the repository
```bash
git clone git@github.com:dragonsajan/weather.git
cd WeatherApp
```

### 2. Secrets & API Configuration (using .xcconfig)

This project uses `.xcconfig` files to securely manage API keys, base URLs, and other sensitive values — **never** hardcode secrets in source code.

### Step-by-step Setup

1. **Locate the sample file**  
   In the project navigator, find:  
   `Resources/sample.secrets.xcconfig` (or `Sample.secrets.xcconfig`)

2. **Create your personal secrets file**  
   - Right-click the sample file → **Duplicate**  
   - Rename the duplicate to: **`Secret.xcconfig`**  
   - **Important**: Do **not** commit `secret.xcconfig` to version control
