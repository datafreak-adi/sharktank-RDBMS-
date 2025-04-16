USE shark_tank;
-- ---------------------------------------------- CREATING TABLES ---------------------------------------------------------------------


CREATE TABLE Season (
    Season_ID INT PRIMARY KEY AUTO_INCREMENT,
    Season_Number INT NOT NULL,
    Season_Start DATE NOT NULL,
    Season_End DATE NOT NULL
);

CREATE TABLE Episode (
    Episode_ID INT PRIMARY KEY AUTO_INCREMENT,
    Episode_Number INT NOT NULL,
    Season_ID INT NOT NULL,
    Original_Air_Date DATE NOT NULL,
    Episode_Title VARCHAR(255),
    Anchor VARCHAR(100),
    FOREIGN KEY (Season_ID) REFERENCES Season(Season_ID)
);



CREATE TABLE Pitch (
    Pitch_ID INT PRIMARY KEY AUTO_INCREMENT,
    Pitch_Number INT NOT NULL,
    Startup_ID INT NOT NULL,
    Episode_ID INT NOT NULL,
    Deal_Status ENUM('Accepted', 'Rejected') NOT NULL,
    Amount_Asked DECIMAL(10,2),
    Equity_Asked FLOAT,
    Valuation_Asked DECIMAL(12,2),
    Amount_Raised DECIMAL(10,2),
    Equity_Given FLOAT,
    Debt DECIMAL(10,2),
    FOREIGN KEY (Startup_ID) REFERENCES Startup(Startup_ID),
    FOREIGN KEY (Episode_ID) REFERENCES Episode(Episode_ID)
);

CREATE TABLE GuestShark (
    Guest_ID INT PRIMARY KEY AUTO_INCREMENT,
    Guest_Name VARCHAR(100),
    Episode_ID INT NOT NULL,
    Season_ID INT NOT NULL,
    Expertise TEXT,
    Net_worth INT,
    FOREIGN KEY (Episode_ID) REFERENCES Episode(Episode_ID),
    FOREIGN KEY (Season_ID) REFERENCES Season(Season_ID)
);

CREATE TABLE Investment (
    Investment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Pitch_ID INT NOT NULL,
    Shark_ID INT NOT NULL,
    FOREIGN KEY (Pitch_ID) REFERENCES Pitch(Pitch_ID),
    FOREIGN KEY (Shark_ID) REFERENCES Shark(Shark_ID)
);

CREATE TABLE Shark (
    Shark_ID INT PRIMARY KEY AUTO_INCREMENT,
    Shark_Name VARCHAR(100) NOT NULL,
    Net_Worth DECIMAL(15,2),
    Industry_of_Expertise VARCHAR(100)
);



CREATE TABLE Startup (
    Startup_ID INT PRIMARY KEY AUTO_INCREMENT,
    Startup_Name VARCHAR(255) NOT NULL,
    Industry VARCHAR(100),
    Founders VARCHAR(255) NOT NULL
);


-- ---------------------------------------------- INSERTING VALUES ---------------------------------------------------------------------



INSERT INTO Season (Season_Number,Season_Start,Season_End) VALUES
    (1, '2021-12-20', '2022-02-04'),
    (2, '2023-01-05', '2023-04-10'),
    (3, '2024-01-15', '2024-04-20'),
    (4, '2025-01-20', '2025-04-30'),
    (5, '2026-02-01', '2026-05-15');

INSERT INTO Startup (Startup_Name,Industry,Founders) VALUES
    ('BluePineFoods',       'Food',                  'Rajat Dalal'),
    ('Skippi Pops',         'Food & Beverage',       'Yogesh Shinde,Aditya'),
    ('Hammer Lifestyle',    'Electronics',           'Rohit Nandwani'),
    ('TagZ Foods',          'Snacks',                'Anish Goyal'),
    ('Sunfox Technologies', 'Healthcare',            'Rajat Jain'),
    ('Bamboo India',        'Sustainable Products',  'Yogesh Shinde');
    

INSERT INTO Shark (Shark_Name,Net_Worth,Industry_of_Expertise) VALUES
    ('Aman Gupta',      500.00, 'Consumer Electronics'), ('Namita Thapar',   600.00, 'Pharmaceuticals'), 
    ('Ashneer Grover',  550.00, 'Fintech'), ('Peyush Bansal',   700.00, 'Eyewear'),
    ('Vineeta Singh',   450.00, 'Cosmetics');
    



INSERT INTO Episode (Season_ID, Episode_Number, Original_Air_Date, Episode_Title, Anchor)
 VALUES
    (1, 1, '2021-12-20', 'Badlegi Business Ki Tasveer', 'Rannvijay Singh'),
    (1, 2, '2022-01-02', 'Tech Startups Special', 'Rannvijay Singha'),
    (2, 3, '2023-01-05', 'Women Entrepreneurs Special', 'Rahul Dua'),
    (3, 4, '2024-02-10', 'Fintech Revolution', 'Rahul Dua'),
    (4, 5, '2025-03-15', 'Sustainable Innovation', 'Rannvijay Singha'),
    (1, 1, '2022-01-01', 'The Grand Opening', 'Rannvijay Singha');



INSERT INTO GuestShark ( Guest_Name, Episode_ID, Season_ID, Expertise, Net_worth ) 
VALUES ('Ratan Tata', 1, 1, 'Conglomerates', 10000), ('Sundar Pichai', 2, 2, 'Technology', 15000), 
('Elon Musk', 3, 3, 'Electric Vehicles', 200000), ('Warren Buffett', 4, 4, 'Investments', 120000), 
('Jeff Bezos', 5, 5, 'E-commerce', 180000);

INSERT INTO Pitch (Pitch_Number, Startup_ID, Episode_ID, Deal_Status, Amount_Asked, Equity_Asked, Valuation_Asked, Amount_Raised, Equity_Given, Debt) VALUES
(1, 1, 1, 'Accepted', 50.00, 10.0, 500.00, 50.00, 10.0, 0.00),
(2, 2, 2, 'Rejected', 75.00, 15.0, 750.00, 0.00, 0.0, 0.00),
(3, 3, 3, 'Accepted', 100.00, 20.0, 1000.00, 80.00, 18.0, 0.00),
(4, 4, 4, 'Accepted', 40.00, 8.0, 500.00, 30.00, 6.0, 5.00),
(5, 5, 5, 'Rejected', 60.00, 12.0, 600.00, 0.00, 0.0, 0.00);





-- ---------------------------------------------- CHECKING CONTRAINTS ---------------------------------------------------------------------

-- NOT NULL/UNIQUE	

CREATE TABLE test( ID int NOT NULL UNIQUE,
                     Name varchar(255));

INSERT INTO test (ID, Name)
VALUES (1, "Adi");

-- DROP TABLE

DROP TABLE test;

-- DATETIME

CREATE TABLE test_default (
    ID int NOT NULL,
    OrderNumber int NOT NULL,
    OrderDate DATETIME DEFAULT (CURRENT_DATE)
);
DROP TABLE test_default;


-- WHERE CLAUSE 

SELECT * FROM Pitch 
WHERE deal_status="Accepted";


-- ALTER Keyword

ALTER TABLE guestshark ADD COLUMN Season_ID INT;

ALTER TABLE guestshark ADD FOREIGN KEY (Season_ID) REFERENCES season(Season_ID);

SELECT * FROM guestshark;


-- CHECK CONTRANINT

CREATE TABLE test_Enterpreneur (
    ID int NOT NULL,
    Name varchar(255),
    Age int,
    CHECK (Age>=18)
);

INSERT INTO test_Enterpreneur (ID, Name, Age)
VALUES (11,'Ram Agrawal', 1), (11,'Ram Agrawal', 19),(11,'Ram Agrawal', 21),(11,'Ram Agrawal', 25);

DROP TABLE test_Enterpreneur;
-- ---------------------------------------------- NORMALIZATION ---------------------------------------------------------------------


-- We have multiple values in startup table(Founders {Multiple Founders})

CREATE TABLE Startup_new (
    Startup_ID INT PRIMARY KEY AUTO_INCREMENT,
    Startup_Name VARCHAR(255) NOT NULL,
    Industry VARCHAR(100)
);

INSERT INTO Startup_new (Startup_Name,Industry) VALUES
    ('BluePineFoods', 'Food'), ('Skippi Pops', 'Food & Beverage'), ('Hammer Lifestyle',    'Electronics'),
    ('TagZ Foods',   'Snacks'),('Sunfox Technologies', 'Healthcare'),
    ('Bamboo India',  'Sustainable Products');

CREATE TABLE Founder (
    Founder_ID INT PRIMARY KEY AUTO_INCREMENT,
    Founder_Name VARCHAR(255) NOT NULL,
    Startup_ID INT NOT NULL,
    FOREIGN KEY (Startup_ID) REFERENCES Startup(Startup_ID) ON DELETE CASCADE
);

INSERT INTO Founder (Founder_Name, Startup_ID) VALUES
('Yogesh Shinde',  6),('Ravi Kabra',  2),('Rohit Nandwani',  3), ('Anish Goyal',  4),
('Rajat Jain',  5),('Aditya',  6);



-- In investment Table t has a composite primary key (multiple columns as a primary key). Some columns depend only on part of that composite key rather than the whole key.

-- 2NF(Invested_Amount, Equity_Taken, and Debt_Given depend only on Shark_ID, not on the entire composite key (Pitch_ID, Shark_ID).


CREATE TABLE Investment (
    Investment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Pitch_ID INT NOT NULL,
    Shark_ID INT NOT NULL,
    FOREIGN KEY (Pitch_ID) REFERENCES Pitch(Pitch_ID),
    FOREIGN KEY (Shark_ID) REFERENCES Shark(Shark_ID)
);

INSERT INTO Investment (Pitch_ID, Shark_ID) VALUES
(5, 1),  (2, 2), (3, 3), (4, 4); 

CREATE TABLE Investment_Details (
    Investment_ID INT NOT NULL,
    Invested_Amount DECIMAL(10,2),
    Equity_Taken FLOAT,
    Debt_Given DECIMAL(10,2),
    PRIMARY KEY (Investment_ID),
    FOREIGN KEY (Investment_ID) REFERENCES Investment(Investment_ID)
);

INSERT INTO Investment_Details (Investment_ID,Invested_Amount,Equity_Taken,Debt_Given) VALUES
(14,  50.00, 10.0,  5.00), (15,  75.00, 12.5,  0.00), (16,  40.00,  8.0, 10.00), (17, 100.00, 15.0,  0.00);



SELECT * FROM Investment;

-- ---------------------------------------------- VIEW---------------------------------------------------------------------------------


CREATE VIEW Successful_Pitches AS 
SELECT p.Pitch_ID, p.Pitch_Number, s.Startup_Name, p.Deal_Status, p.Amount_Asked, p.Amount_Raised, p.Equity_Given 
FROM Pitch p
JOIN Startup s ON p.Startup_ID = s.Startup_ID
WHERE p.Deal_Status = 'Accepted';


SELECT * FROM Enterpreneur;





-- ---------------------------------------------- JOINS ---------------------------------------------------------------------------------

-- NATURAL JOINS

SELECT *
FROM Startup
NATURAL JOIN Pitch;

-- INNER JOIN

SELECT P.Pitch_ID, ST.Startup_Name, E.Episode_Title
FROM Pitch P
INNER JOIN Episode E ON P.Episode_ID = E.Episode_ID
INNER JOIN Startup ST ON P.Startup_ID = ST.Startup_ID;


-- LEFT JOIN 

SELECT P.Pitch_ID, ST.Startup_Name
FROM Pitch P
LEFT JOIN Startup ST ON P.Startup_ID = ST.Startup_ID;

-- RIGHT JOIN

SELECT SH.Shark_Name, I.Pitch_ID
FROM Investment I
RIGHT JOIN Shark SH ON I.Shark_ID = SH.Shark_ID;


-- FULL OUTER JOIN

SELECT P.Pitch_ID, I.Investment_ID
FROM Pitch P
LEFT JOIN Investment I ON P.Pitch_ID = I.Pitch_ID

UNION

SELECT P.Pitch_ID, I.Investment_ID
FROM Investment I
RIGHT JOIN Pitch P ON P.Pitch_ID = I.Pitch_ID;

-- ---------------------------------------------- INDEXES---------------------------------------------------------------------------------


CREATE INDEX idx_pitch_episode ON Pitch(Episode_ID);

CREATE INDEX idx_investment_shark_pitch ON Investment(Shark_ID, Pitch_ID);

CREATE INDEX idx_startup_name ON Startup(Startup_Name);


SELECT * FROM Startup
WHERE Startup_Name= "Skippi Pops";


-- ---------------------------------------------- TRIGGERS ---------------------------------------------------------------------------------


CREATE TABLE Audit_Log (
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    Table_Changed VARCHAR(50),
    Action_Taken VARCHAR(50),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- Triggers(Insertion)

Delimiter //

CREATE TRIGGER log_investment_insert
AFTER INSERT ON investment_details
FOR EACH ROW
BEGIN
    INSERT INTO Audit_Log (Table_Changed, Action_Taken)
    VALUES ('investment_pitches', 'INSERT');
END;

//

-- Updation (f someone invests in a pitch, automatically mark its deal status as 'Accepted'.)

Delimiter //

CREATE TRIGGER update_deal_status
AFTER INSERT ON investment
FOR EACH ROW
BEGIN
    UPDATE Pitch
    SET Deal_Status = 'Accepted'
    WHERE Pitch_ID = NEW.Pitch_ID;
END;

//


-- ---------------------------------------------- STORED PROCEDURE ---------------------------------------------------------------------------------


DELIMITER //

CREATE PROCEDURE AddInvestmentPitch (
    IN p_Pitch_ID INT,
    IN p_Shark_ID INT,
    IN p_Amount DECIMAL(10,2),
    IN p_Equity FLOAT,
    IN p_Debt DECIMAL(10,2)
)
BEGIN
    DECLARE newInvestmentID INT;

    -- Step 1: Insert into Investment Table
    INSERT INTO Investment(Pitch_ID, Shark_ID)
    VALUES (p_Pitch_ID, p_Shark_ID);

    -- Step 2: Get last inserted ID
    SET newInvestmentID = LAST_INSERT_ID();

    -- Step 3: Insert into Investment_Details
    INSERT INTO Investment_Details(Investment_ID, Invested_Amount, Equity_Taken, Debt_Given)
    VALUES (newInvestmentID, p_Amount, p_Equity, p_Debt);
END;
//

CALL AddInvestmentPitch(10, 3, 50000.00, 10.0, 0.0);

SELECT * FROM Investment
