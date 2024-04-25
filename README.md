# food-delivery-system
Database Management System (DBMS) Description:

The project focuses on designing and implementing a robust and scalable database management system (DBMS) to support an online food ordering and delivery platform. The DBMS will efficiently manage the storage, retrieval, and manipulation of data related to users, restaurants, menu items, orders, delivery drivers, and delivery assignments.

Key Components:

Entity-Relationship (ER) Model: The DBMS will be designed based on an ER model that accurately represents the relationships between entities such as users, restaurants, menu items, orders, and delivery drivers.

Database Schema: The schema will define the structure of the database, including tables for each entity and their corresponding attributes. Primary and foreign keys will be appropriately defined to ensure data integrity and enforce relationships between entities.

Data Storage and Indexing: Data will be stored efficiently to optimize query performance. Indexing will be utilized to speed up retrieval of frequently accessed data, such as orders by user or menu items by restaurant.

Transaction Management: The DBMS will support transaction management to ensure data consistency and integrity, particularly during operations such as order placement and delivery assignment.

Query Optimization: Query optimization techniques have been employed to enhance the efficiency of database operations, reducing response times and resource consumption.

Security and Access Control: Access to the database is controlled through user authentication and authorization mechanisms to protect sensitive information and prevent unauthorized access.

Trigger: Triggers have been implemented to generate bill, send notification to delivery partner and to notify if restaurant is shut

Stored Procedures: Stored procedures have been utilized to encapsulate frequently executed database operations into reusable modules, enhancing code maintainability and performance.

Cursor: Cursors hav been employed for iterating over result sets returned by queries, enabling efficient processing of data row by row and to retieve data from the restaurant table
