
DROP TABLE PurchasePart CASCADE CONSTRAINTS;
DROP TABLE Purchase CASCADE CONSTRAINTS;
DROP TABLE HomeAddress CASCADE CONSTRAINTS;
DROP TABLE Thing CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;


CREATE TABLE Client (
    client_id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    email_address VARCHAR2(50) NOT NULL
);


CREATE TABLE HomeAddress (
    home_address_id NUMBER PRIMARY KEY,
    client_id NUMBER UNIQUE NOT NULL,
    street VARCHAR2(50),
    city VARCHAR2(50) NOT NULL,
    postal_code VARCHAR2(10),
    CONSTRAINT fk_homeAddress_client FOREIGN KEY (client_id) REFERENCES Client(client_id)
);


CREATE TABLE Thing (
    thing_id NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    description VARCHAR2(100),
    size NUMBER,
    purchase_price NUMBER,
    sell_price NUMBER
);


CREATE TABLE Purchase (
    purchase_id NUMBER PRIMARY KEY,
    client_id NUMBER NOT NULL,
    CONSTRAINT fk_purchase_client FOREIGN KEY (client_id) REFERENCES Client(client_id)
);


CREATE TABLE PurchasePart (
    purchase_part_id NUMBER PRIMARY KEY,
    purchase_id NUMBER NOT NULL,
    thing_id NUMBER NOT NULL,
    quantity NUMBER DEFAULT 1,
    CONSTRAINT fk_purchasePart_purchase FOREIGN KEY (purchase_id) REFERENCES Purchase(purchase_id),
    CONSTRAINT fk_purchasePart_thing FOREIGN KEY (thing_id) REFERENCES Thing(thing_id)
);
