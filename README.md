# Microservices based E-Commerce App - Deployed on Kubernetes

In this demo application, we are going to deploy a **microservices** based **E-Commerce** web application with **11** microservices on Kubernetes.

Application credit to [Google Cloud Platform](https://github.com/GoogleCloudPlatform/microservices-demo).

## Description 
**Online Boutique** is a cloud-native microservices demo application. Online Boutique consists of a 11-tier microservices application. The application is a web-based e-commerce app where users can browse items, add them to the cart, and purchase them.

**Google uses this application to demonstrate use of technologies like Kubernetes/GKE, Istio, Stackdriver, gRPC and OpenCensus**. This application works on any Kubernetes cluster, as well as Google Kubernetes Engine. It’s easy to deploy with little to no configuration.

## Architecture
Online Boutique is composed of 11 microservices written in different languages that talk to each other over gRPC.

![App Architecture](images/architecture-diagram.png)

## Microservices Detail
As a DevOps engineer, we need following information from the developer, to deploy the Microservices:
- Which microservices need to be deployed?
- Which microservice is talking to which microservice? 
- How are they communicating? 
  - Directly using API calls
  - Message Broker
  - Service Mesh 
- Which database are they using? 3rd Party Services
- On which port does each microservice run? 
- Which service is accessible form outside the K8s cluter?

**Note:** In this microservices demo, Redis as a Message Broker or in-memory database is being used. 

### Brief Description of Microservices

|Microservice |Language |Description             |
|----------|-------|----------------------------| 
| frontend     | Go | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically.|
| cartservice  | C# | Stores the items in the user's shopping cart in Redis and retrieves it. |
| productcatalogservice  | Go | Provides the list of products from a JSON file and ability to search products and get individual products. |
| currencyservice  | Nodejs | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| paymentservice  | Nodejs | Charges the given credit card info (mock) with the given amount and returns a transaction ID. |
| shippingservice  | Go | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock). |
| emailservice  | Python | Sends users an order confirmation email (mock). |
| checkoutservice  | Go | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification. |
| recommendationservice  | Python | Recommends other products based on what's given in the cart. |
| adservice  | Java | Provides text ads based on given context words. |
| loadgenerator  | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend. |

### Microservices Ports and Env. Variables

|Microservice |Working on Port | Env. Variables | Image Path |
|----------|--------|-------------|-------------|
| frontend     | 8080 | PORT="8080" -  PRODUCT_CATALOG_SERVICE_ADDR="productcatalogservice:3550" CURRENCY_SERVICE_ADDR="currencyservice:7000" CART_SERVICE_ADDR="cartservice:7070" RECOMMENDATION_SERVICE_ADDR="recommendationservice:8080" SHIPPING_SERVICE_ADDR="shippingservice:50051" CHECKOUT_SERVICE_ADDR="checkoutservice:5050" AD_SERVICE_ADDR="adservice:9555"    | gcr.io/google-samples/microservices-demo/frontend:v0.6.0    |
| cartservice  | 7070 | PORT="7070" -  REDIS_ADDR="redis-cart:6379"    | gcr.io/google-samples/microservices-demo/cartservice:v0.6.0    |
| productcatalogservice  | 3550 | PORT="3550"    | gcr.io/google-samples/microservices-demo/productcatalogservice:v0.6.0    |
| currencyservice  | 7000 | PORT="7000"    | gcr.io/google-samples/microservices-demo/currencyservice:v0.6.0    |
| paymentservice  | 50051 | PORT="50051"    | gcr.io/google-samples/microservices-demo/paymentservice:v0.6.0    |
| shippingservice  | 50051 | PORT="50051"    | gcr.io/google-samples/microservices-demo/shippingservice:v0.6.0    |
| emailservice  | 8080 | PORT="8080"    | gcr.io/google-samples/microservices-demo/emailservice:v0.6.0    |
| checkoutservice  | 5050 | PORT="5050" -  PRODUCT_CATALOG_SERVICE_ADDR="productcatalogservice:3550" SHIPPING_SERVICE_ADDR="shippingservice:50051" PAYMENT_SERVICE_ADDR="paymentservice:50051" EMAIL_SERVICE_ADDR="emailservice:5000" CURRENCY_SERVICE_ADDR="currencyservice:7000" CART_SERVICE_ADDR="cartservice:7070"    | gcr.io/google-samples/microservices-demo/checkoutservice:v0.6.0    |
| recommendationservice  | 8080 | PORT="8080" -  PRODUCT_CATALOG_SERVICE_ADDR="productcatalogservice:3550"    | gcr.io/google-samples/microservices-demo/recommendationservice:v0.6.0    |
| adservice  | 9555 | PORT="9555"    | gcr.io/google-samples/microservices-demo/adservice:v0.6.0    |
| loadgenerator  |  | FRONTEND_ADDR="frontend:80" - USERS="10"    | gcr.io/google-samples/microservices-demo/loadgenerator:v0.6.0    |



