-- Drop tables if they already exist to override if needed

DROP TABLE IF EXISTS cardholder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;

-- Create carholder table with primary key designation

CREATE TABLE cardholder (
    cardholder_ID INT NOT NULL,
    cardholder_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (cardholder_ID)
);

-- Create credit_card table with primary & foreign key designation

CREATE TABLE credit_card (
    credit_card_number VARCHAR(200) NOT NULL,
    cardholder_ID INT NOT NULL,
    PRIMARY KEY (credit_card_number),
    FOREIGN KEY (cardholder_ID) REFERENCES cardholder(cardholder_ID)
);

-- Create merchant_category table with primary key designation

CREATE TABLE merchant_category (
    merchant_category_ID INT NOT NULL,
    merchant_category_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (merchant_category_ID)
);

-- Create merchant table with primary & foreign key designation

CREATE TABLE merchant (
    merchantID INT NOT NULL,
    merchant_name VARCHAR(50) NOT NULL,
    merchant_category_ID INT NOT NULL,
    PRIMARY KEY (merchantID),
    FOREIGN KEY (merchant_category_ID) REFERENCES merchant_category(merchant_category_ID)

);

-- Create transactions table with primary & foreign key designation

CREATE TABLE transactions (
    transaction_ID INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    transaction_amount FLOAT NOT NULL,
    credit_card_number VARCHAR(200) NOT NULL,
    merchantID INT NOT NULL,
    PRIMARY KEY (transaction_ID),
    FOREIGN KEY (credit_card_number) REFERENCES credit_card(credit_card_number),
    FOREIGN KEY (merchantID) REFERENCES merchant(merchantID)
);

