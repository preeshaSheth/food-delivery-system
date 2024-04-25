 Create tables
BEGIN
  -- Create User table
  EXECUTE IMMEDIATE 'CREATE TABLE Users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(255),
    email VARCHAR2(255) UNIQUE,
    password VARCHAR2(255)
  )';

  -- Create Restaurant table
  EXECUTE IMMEDIATE 'CREATE TABLE Restaurants (
    restaurant_id NUMBER PRIMARY KEY,
    name VARCHAR2(255),
    address VARCHAR2(255),
    cuisine_type VARCHAR2(255),
    is_open NUMBER(1, 0) DEFAULT 1
  )';

  -- Create Menu Item table
  EXECUTE IMMEDIATE 'CREATE TABLE Menu_Items (
    item_id NUMBER PRIMARY KEY,
    restaurant_id NUMBER,
    name VARCHAR2(255),
    description VARCHAR2(255),
    price NUMBER
  )';

  -- Create Order table
  EXECUTE IMMEDIATE 'CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    order_date DATE,
    total_price NUMBER,
    delivery_address VARCHAR2(255)
  )';

  -- Create Order Item table
  EXECUTE IMMEDIATE 'CREATE TABLE Order_Items (
    order_item_id NUMBER PRIMARY KEY,
    order_id NUMBER,
    item_id NUMBER,
    quantity NUMBER
  )';

  -- Create Delivery Driver table
  EXECUTE IMMEDIATE 'CREATE TABLE Delivery_Drivers (
    driver_id NUMBER PRIMARY KEY,
    name VARCHAR2(255),
    phone_number VARCHAR2(20)
  )';

  -- Create Delivery Assignment table
  EXECUTE IMMEDIATE 'CREATE TABLE Delivery_Assignments (
    assignment_id NUMBER PRIMARY KEY,
    order_id NUMBER,
    driver_id NUMBER,
    assignment_date DATE,
    status VARCHAR2(20)
  )';
END;

-- Insert sample data into User table
BEGIN
  FOR i IN 1..50 LOOP
    INSERT INTO Users (user_id, username, email, password)
VALUES 
    (1, 'john_d', 'john_doe@example.com', 'password123'),
    (2, 'sarah_m', 'sarah_miller@example.com', 'qwerty789'),
    (3, 'mike_s', 'mike_smith@example.com', 'pass1234'),
    (4, 'emily_j', 'emily_jones@example.com', 'abcdef'),
    (5, 'david_k', 'david_k@example.com', 'securepass');

  END LOOP;
END;

-- Insert sample data into Restaurant table
BEGIN
  FOR i IN 1..50 LOOP
    INSERT INTO Restaurants (restaurant_id, name, address, cuisine_type)
VALUES 
    (1, 'The Blue Orchid', '123 Main St, Anytown', 'Thai'),
    (2, 'La Trattoria', '456 Elm St, Anycity', 'Italian'),
    (3, 'Sushi Fusion', '789 Oak St, Anycity', 'Japanese'),
    (4, 'The Brass Lantern', '101 Pine St, Anycity', 'American'),
    (5, 'Spice Avenue', '246 Maple St, Anycity', 'Indian');
  END LOOP;
END;

-- Insert sample data into Menu_Item table
BEGIN
  FOR i IN 1..50 LOOP
    INSERT INTO Menu_Items (item_id, restaurant_id, name, description, price)
VALUES 
    (1, 1, 'Pad Thai', 'Stir-fried rice noodles with shrimp, tofu, peanuts, bean sprouts, and lime', 12.99),
    (2, 1, 'Green Curry', 'Traditional Thai green curry with chicken, eggplant, and basil', 14.99),
    (3, 2, 'Spaghetti Bolognese', 'Spaghetti pasta with homemade meat sauce and parmesan cheese', 13.50),
    (4, 3, 'Sashimi Platter', 'Assorted slices of fresh raw fish served with soy sauce and wasabi', 16.50),
    (5, 4, 'BBQ Ribs', 'Slow-cooked pork ribs smothered in tangy barbecue sauce', 18.99);
  END LOOP;
END;

--  cursor to retrieve data from the Restaurant table
DECLARE
  v_restaurant_id NUMBER;
  v_restaurant_name VARCHAR2(255);
  v_cuisine_type VARCHAR2(255);

  -- Cursor declaration
  CURSOR restaurant_cursor IS
    SELECT restaurant_id, name, cuisine_type FROM Restaurants;
BEGIN
  OPEN restaurant_cursor;
  LOOP
    FETCH restaurant_cursor INTO v_restaurant_id, v_restaurant_name, v_cuisine_type;
    EXIT WHEN restaurant_cursor%NOTFOUND;

    -- Perform data processing here (you can add your specific processing logic)
    DBMS_OUTPUT.PUT_LINE('Restaurant ID: ' || v_restaurant_id);
    DBMS_OUTPUT.PUT_LINE('Restaurant Name: ' || v_restaurant_name);
    DBMS_OUTPUT.PUT_LINE('Cuisine Type: ' || v_cuisine_type);
  END LOOP;
  CLOSE restaurant_cursor;
END;

-- trigger that calculates the total price of an order
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER Calculate_Order_Total
  BEFORE INSERT ON Orders
  FOR EACH ROW
  DECLARE
    v_total NUMBER := 0;
  BEGIN
    SELECT SUM(mi.price * oi.quantity) INTO v_total
    FROM Menu_Items mi
    JOIN Order_Items oi ON mi.item_id = oi.item_id
    WHERE oi.order_id = :new.order_id;
    
    :new.total_price := v_total;
  END;';
END;
/

--  trigger to send automatic notifications to delivery drivers
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER Send_Delivery_Notification
  AFTER INSERT ON Delivery_Assignments
  FOR EACH ROW
  BEGIN
    -- Simulate a notification by printing a message to DBMS_OUTPUT
    DBMS_OUTPUT.PUT_LINE('Notification: Driver ' || :new.driver_id || ' assigned to order ' || :new.order_id);
  END;';
END;
/

-- trigger to ensure that an order is not placed if a restaurant is closed
BEGIN
  EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER Check_Restaurant_Open
  BEFORE INSERT ON Orders
  FOR EACH ROW
  BEGIN
    IF :new.user_id IS NOT NULL THEN
      SELECT r.is_open INTO :new.is_open
      FROM Restaurants r
      WHERE r.restaurant_id = :new.restaurant_id;

      IF :new.is_open = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, ''The restaurant is closed and cannot accept orders.'');
      END IF;
    END IF;
  END;';
END;
/