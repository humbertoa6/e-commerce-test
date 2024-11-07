# Coupon Management and Cart System
This project is a demo application for managing coupons and a cart system built using Ruby on Rails. The application allows users to create coupons, associate them with a cart, and apply discounts to cart items. It also includes a validation mechanism for checking the validity of coupons.

## Getting Started
To get the project running locally, follow these steps:

### Prerequisites
- Make sure you have Ruby on Rails installed.
- PostgreSQL should be installed and running.
- Setup Instructions
```
rails db:create
rails db:migrate
rails db:seed
```
Configure the environment variables:

- Rename the `.env.example` file to `.env`.
- Fill in the necessary environment variables in the .env file.
- Run the Rails server:

```
rails s
```
Access the application:

- Go to http://localhost:3000 in your web browser.

The project uses RSpec for testing. To run the tests, use:
bash

- `rspec`

## Usage Guide
```
1. Accessing the Application
Visit http://localhost:3000 in your browser.
2. Creating Coupons
Navigate to the "Create Coupons" section.
Fill out the form to add new coupons, specifying the coupon code and discount percentage.
After creation, the coupon will be available for use in the cart.
3. Using Coupons in the Cart
Go to the "Cart" section. A new cart will be automatically created for you.
Apply a coupon code to see if it is valid and how the discount affects your total.
Validate that the coupon validator is functioning correctly and that discounts are properly applied.


```
### How Coupons Work
Logic for Discount Scalability in the CartCompletionService
Incremental Discount Calculation:

Base Discount: The discount starts at 5% for the first purchase in the month.
Progressive Increase: For each additional purchase made by the user in the same month, the discount increases by 5%. This increase continues until it reaches the cap of 30%. Specifically, the service calculates the discount as 5% * number_of_purchases_this_month, capping at 30%.
Maximum Discount: If the user makes more than six purchases in a month, the discount will be capped at 30%, ensuring that it does not exceed this maximum threshold.
Monthly Reset:

Reset Mechanism: At the beginning of each month, the count of purchases resets for all users. This ensures that users start over with a 5% discount on their first purchase of the new month, and the progressive discount logic is reapplied.
Additional Discount for Large Purchases:

Large Cart Threshold: If the total value of the cart exceeds $400 (defined as LARGE_CART_THRESHOLD), an additional 10% discount is added to the base discount.
Discount Limitation: Even with the additional discount, the total discount cannot exceed the maximum of 30%. This is enforced by the calculation logic, which takes the minimum of the calculated total discount and MAX_DISCOUNT_PERCENTAGE.
Coupon Generation and Assignment:

Unique Gift Card Code: The service generates a unique gift card code for the user using SecureRandom.hex. It ensures the uniqueness of this code by checking that it does not already exist in the Coupon database.
Coupon Expiration: The generated coupon comes with an expiration date set to 10 days from the creation date (defined by EXPIRATION_DAYS).
Cart Completion:

The service marks the cart as completed by setting completed_at to the current date and time.
If the user already has a pending coupon for this cart, it updates the status of that coupon to redeemed.

### Checklist for Testing
 - Open http://localhost:3000.
 - Go to "Create Coupons" and add some coupons.
 - Visit the cart, and verify that a new cart is created.
 - Use one of the created coupons to apply a discount.
 - Check that the discount is correctly applied and the final total is accurate.
 - Validate that the coupon status updates to redeemed after use.
 - Test invalid coupon codes and ensure error messages are displayed correctly.
- Description of the Solution
- The system is designed to manage coupons efficiently, allowing for easy creation, validation, and redemption. The core functionalities include creating coupons, applying them to a cart, and ensuring that discounts are correctly calculated. A validation service ensures that only valid coupons are applied, preventing misuse.

### Scalability and High-Load Considerations
If implemented in a real-world environment, the following considerations would be made to handle high load and many simultaneous users:

### Database Optimization:

Indexing critical columns such as code in the coupons table to speed up queries.
Using database sharding or partitioning for large datasets to distribute load.
### Caching:

Implementing caching strategies (e.g., Redis or Memcached) for frequently accessed data, such as available coupons and cart totals.
### Load Balancing:

Distributing incoming requests across multiple servers using a load balancer to ensure the system can handle a large number of users efficiently.
### Background Jobs:

Using background job processing (e.g., Sidekiq) for non-critical operations, such as sending notification emails or processing bulk coupon updates, to keep the main application responsive.

### Rate Limiting:

Implementing rate limiting to prevent abuse and ensure fair usage of resources.
### Scalable Infrastructure:

Deploying the application on a scalable infrastructure like AWS or Google Cloud, where resources can be dynamically allocated based on traffic.
These measures would help ensure the application performs well under heavy traffic and maintains a high level of reliability.


## Real-World Considerations
### Handling High User Traffic:

In a real-world scenario, the system might experience sudden spikes in traffic, especially during promotional events or sales. With load balancing and caching strategies in place, the system would be able to handle these spikes without significant performance degradation.
The use of background jobs for processing tasks ensures that critical paths (like coupon redemption) remain responsive.
Ensuring Data Integrity and Consistency:

For coupon validation and redemption, it is crucial to ensure that the same coupon is not redeemed multiple times. Using database-level constraints and locking mechanisms can help maintain data consistency, even under high load.
Distributed databases and eventual consistency models might be considered if the system grows to a global scale.
Scalability for Future Growth:

As the user base grows, the system should be able to scale easily. Adopting containerization (e.g., Docker) and orchestration tools (like Kubernetes) can help manage deployment and scaling efficiently.
A microservices approach could also be implemented for better scalability, especially if different teams are working on different features.
Conclusion
The current solution provides a solid foundation for managing coupons and carts efficiently, but as traffic increases, more sophisticated scaling and optimization strategies may be necessary. With a combination of database optimization, caching, load balancing, and thoughtful use of background jobs, the system can be prepared to handle high loads and ensure a seamless experience for users.