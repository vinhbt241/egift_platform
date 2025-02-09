# 🎁 eGiftHub - The Ultimate eGift Platform

## 🚀 Overview
eGiftHub is a modern eGift platform that allows users to manage brands, products, clients, and issue digital gifts seamlessly. Whether for birthdays, holidays, or just because, eGiftHub makes gifting easy and fun!

## 📜 Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Configuration](#configuration)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## 🔧 Installation
```sh
git clone https://github.com/vinhbt241/egift_platform.git
cd egift_platform
bundle install
```

## 🚀 Usage
```sh
# Start the server
rails s
# Annotate models' tables
bundle exec annotate
```

## ✨ Features
- **User Authentication:**
  - Enables user registration and login using email credentials.
  - Preloads default accounts through a seed mechanism.
- **Brand Management:**
  - Allows adding brands with up to five customizable data fields per brand.
- **Product Management:**
  - Enables adding, updating, and deleting products associated with brands.
  - Supports up to five customizable data fields per product.
  - Requires a price value for products, accommodating various currencies.
- **State Management:**
  - Allows toggling brand and product states between "active" and "inactive."
- **Client Management:**
  - Enables adding clients with authentication credentials and configurable payout rates.
- **Product Access Control:**
  - Empowers users to specify accessible products for their clients.
- **Card Issuance and Management:**
  - Allows clients to request new cards for products.
  - Provides clients with a unique activation number and an optional purchase details PIN upon issuance.
- **Card Cancellation:**
  - Enables clients to cancel previously issued cards as needed.
- **Reporting:**
  - Supports generating comprehensive reports on spending and card cancellation activities.

## ⚙️ Configuration
- Create an `.env` file and copy the variables from the `.example.env` file. Make necessary adjustments according to your local environment.

## 📚 API Documentation
- Simply start the server, then navigate to [http://localhost:3000/api-docs](http://localhost:3000/api-docs) to explore and interact with the full list of APIs.

## 🧪 Testing
Run tests using:
```sh
bundle exec rspec
```
To see the test coverage report, run the test suite first (if you haven't), then open the `coverage/index.html` file.

To re-generate API documentation from request test suites, run the following command:
```sh
bundle exec rake rswag:specs:swaggerize
```

## 📝 License
This project is licensed under the MIT License - see the [LICENSE](https://mit-license.org/) file for details.

## 📬 Contact
Maintainer: [Vinh](mailto:vinh2000bt@gmail.com)

---
Happy coding! 🚀
