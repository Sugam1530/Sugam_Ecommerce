## Flutter eCommerce App

# Overview

This Flutter application is a simple eCommerce app that demonstrates how to use the GetX package for 
state management and adheres to the MVC architecture. The app retrieves product data from a mock API 
and provides features such as search and pagination.

# Features
Product Listing: Displays a paginated list of products.
Search Functionality: Allows users to filter products based on search input.
Product Details: Provides detailed information about selected products.
Pagination: Loads additional products as the user scrolls down.

# Technologies Used
Flutter: Framework for building cross-platform applications.
GetX: State management solution for Flutter.
MVC Architecture: Used to maintain a clean separation of concerns.

# API
Mock API: [Fake Store API](https://fakestoreapi.com/products)
 Provides a list of 20 products.

## Installation and Setup

# Clone the Repository:
git clone <repository-url>

# Navigate to the Project Directory:
cd <project-directory>

# Install Dependencies:
flutter pub get

# Run the Application:
flutter run

## Project Structure

# Controllers:
ProductListController: Manages state, fetches products, handles search queries, and manages the wishlist.
# Models:
ProductModel: Defines the structure of product data.
# Pages:
ProductListPage: Displays the list of products with search and pagination.
ProductDetailsPage: Shows detailed information about a selected product.