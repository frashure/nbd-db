/*
-          Identify all the necessary check constraints
-          Identify and show at least 3 triggers that would be helpful
-          Identify and show examples of at least 3 transactions based on your database design and provided case
-          Identify and design a minimum of 3 VIEWS that would be helpful in presenting data as shown
-          Implement the database from ER model with:
o   All of the check constraints
o   All of the triggers
o   All of the views
o   Perform the necessary insert records in the tables
o   Demonstrate the transactions

CREATE DATABASE
*/
USE MASTER
GO
IF db_id('NBD3') IS NOT NULL
BEGIN
PRINT 'NBD3 exists, and will be dropped'
DROP DATABASE NBD3;
PRINT 'NBD3 database has been dropped'
END

CREATE DATABASE NBD3
GO

IF db_id('NBD3') IS NOT NULL
	BEGIN
		PRINT 'A *new database* mydb has been successfully created'
	END

--SET TO USE DATABASE

USE NBD3
GO
;

--CREATE TABLES

   ------CREATE TABLES------
    CREATE TABLE ZIPTABLE (
      zip char(5) NOT NULL,
      city varchar(45) NOT NULL,
      state char(2) NOT NULL,
      CONSTRAINT PK_ZIP PRIMARY KEY (zip)
    )

    CREATE TABLE CLIENT (
      accountNum char(8) NOT NULL,
      name varchar(45) NOT NULL,
      streetNum char(7) NOT NULL,
      streetName varchar(100) NOT NULL,
      zip char(5) NOT NULL,
      CONSTRAINT PK_CLIENT PRIMARY KEY (accountNum),
      CONSTRAINT FK_CLIENT_ZIP FOREIGN KEY (zip)
        REFERENCES ZIPTABLE (zip)
    )

    CREATE TABLE CONTACT (
      contactID char(16) NOT NULL,
      fName varchar(30) NOT NULL,
      lName varchar(30) NOT NULL,
      telNum char(10) NOT NULL,
      accountNum char(8) NOT NULL,
      CONSTRAINT PK_CONTACT PRIMARY KEY (contactID),
      CONSTRAINT FK_CLIENT_ACCTNUM FOREIGN KEY (accountNum)
        REFERENCES CLIENT (accountNum)
    )

    CREATE TABLE PROJECT (
      projectNum char(8) NOT NULL,
      projName varchar(45) NOT NULL,
      streetNum varchar(7) NOT NULL,
      streetName varchar(100) NOT NULL,
      accountNum char(8) NOT NULL,
      contactID char(16) NOT NULL,
      zip char(5) NOT NULL,
      CONSTRAINT PK_PROJECT PRIMARY KEY (projectNum),
      CONSTRAINT FK1_PROJECT_CLIENT FOREIGN KEY (accountNum)
        REFERENCES CLIENT (accountNum),
      CONSTRAINT FK2_PROJECT_CONTACT FOREIGN KEY (contactID)
        REFERENCES CONTACT (contactID),
      CONSTRAINT FK3_PROJECT_ZIP FOREIGN KEY (zip)
        REFERENCES ZIPTABLE (zip)
    )

    CREATE TABLE DESIGN_BID (
      bidID int NOT NULL,
      bidDate date NOT NULL,
      estBeginDate date NOT NULL,
      estCompletionDate date NOT NULL,
      bidAmount decimal NOT NULL,
      [status] char(1) NOT NULL,
      projectNum char(8) NOT NULL,
      CONSTRAINT PK_BID PRIMARY KEY (bidID),
      CONSTRAINT FK_BID_PROJECT FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum)
    )

    CREATE TABLE MATERIALS (
      materialCode char(8) NOT NULL,
      mType varchar(10) NOT NULL,
      CONSTRAINT PK_MATERIALS PRIMARY KEY (materialCode)
    )

    CREATE TABLE BID_MATERIALS (
      bidQty int NOT NULL,
      bidUnitPrice decimal NOT NULL,
      bidID int NOT NULL,
      projectNum char(8) NOT NULL,
      materialCode char(8) NOT NULL,
      CONSTRAINT PK_BID_MATERIALS PRIMARY KEY (bidID, projectNum, materialCode),
      ---These may need to be reworked; the FKs here are also FKs in other tables, so I wasn't sure if they needed to be referenced from the original table or the direct relationship. -------
      CONSTRAINT FK1_BIDMAT_DESBID FOREIGN KEY (bidID)
        REFERENCES DESIGN_BID (bidID),
      CONSTRAINT FK2_BIDMAT_PROJ FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum),
      CONSTRAINT FK3_BIDMAT_MAT FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE STAFF (
      empID char(4) NOT NULL,
      lName varchar(45) NOT NULL,
      fName varchar(45) NOT NULL,
      phone char(10) NULL,
      CONSTRAINT PK_STAFF PRIMARY KEY (empID)
    )

    CREATE TABLE BID_STAFF (
      role varchar(50) NOT NULL,
      bidID int NOT NULL,
      projectNum char(8) NOT NULL,
      empID char(4) NOT NULL,
      CONSTRAINT PK_BIDSTAFF PRIMARY KEY (bidID, projectNum, empID),
      CONSTRAINT FK1_BIDSTAFF_DESIGNBID FOREIGN KEY (bidID)
        REFERENCES DESIGN_BID (bidID),
      CONSTRAINT FK2_BIDSTAFF_PROJECT FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum),
      CONSTRAINT FK3_BIDSTAFF_STAFF FOREIGN KEY (empID)
        REFERENCES STAFF (empID)
    )

    CREATE TABLE LABOR (
      laborCode char(6) NOT NULL,
      laborDesc varchar(60) NOT NULL,
      CONSTRAINT PK_LABOR PRIMARY KEY (laborCode)
    )

    CREATE TABLE BID_LABOR (
      bidHours int NOT NULL,
      laborCost decimal NOT NULL,
      bidID int NOT NULL,
      projectNum char(8) NOT NULL,
      laborCode char(6) NOT NULL,
      CONSTRAINT PK_BIDLABOR PRIMARY KEY (bidID, projectNum, laborCode),
      CONSTRAINT FK1_BIDLABOR_DESIGNBID FOREIGN KEY (bidID)
        REFERENCES DESIGN_BID (bidID),
      CONSTRAINT FK2_BIDLABOR_PROJECT FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum),
      CONSTRAINT FK3_BIDLABOR_LABOR FOREIGN KEY (laborCode)
        REFERENCES LABOR (laborCode)
    )

    CREATE TABLE PLANT_INV (
      plantDesc varchar(45) NOT NULL,
      size int NULL,
      materialCode char(8) NOT NULL,
      QIS INT NOT NULL,
      IS_OB INT NOT NULL,
      QO INT NOT NULL,
      OO_OB INT NOT NULL,
      CONSTRAINT PK_PLANTINV PRIMARY KEY (materialCode),
      CONSTRAINT FK_PLANTINV_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE POTTERY (
      potteryDesc varchar(45) NULL,
      size int NULL,
      features varchar(45) NULL,
      materialCode char(8) NOT NULL,
      QIS INT NOT NULL,
      IS_OB INT NOT NULL,
      CONSTRAINT PK_POTTERY PRIMARY KEY (materialCode),
      CONSTRAINT FK_POTTERY_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE LANDSCAPE_MATERIALS (
      landscapeDesc varchar(45) NULL,
      materialCode char(8) NOT NULL,
      QIS INT NOT NULL,
      CONSTRAINT PK_LANDSCAPEMATERIALS PRIMARY KEY (materialCode),
      CONSTRAINT FK_LANDSCAPEMAT_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE SUPPLIERS (
      supplierID CHAR(5) NOT NULL,
      supplierName VARCHAR(15) NULL,
      street VARCHAR(45) NULL,
      CONSTRAINT PK_SUPPLIERS PRIMARY KEY (supplierID)
    )


    CREATE TABLE PURCHASE_ORDERS (
      orderNum CHAR(10) NOT NULL,
      orderDate smalldatetime NOT NULL,
      orderTotal DECIMAL(7,2) NOT NULL,
      supplierID char(5) NOT NULL
      CONSTRAINT PK_PURCHASEORDER PRIMARY KEY (orderNum),
      CONSTRAINT FK_PO_SUPPLIER FOREIGN KEY (supplierID)
          REFERENCES SUPPLIERS (supplierID)
    )

    CREATE TABLE OD_DETAILS (
      quantity INT NOT NULL,
      unitPrice DECIMAL(7,2) NOT NULL,
      orderNum char(10) NOT NULL,
      materialCode char(8) NOT NULL,
      CONSTRAINT PK_OD PRIMARY KEY (orderNum, materialCode),
      CONSTRAINT FK_OD_PO FOREIGN KEY (orderNum)
        REFERENCES PURCHASE_ORDERS (orderNum),
      CONSTRAINT FK_OD_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE DAILY_WORK_REPORT (
      reportID CHAR(5) NOT NULL,
      projectNum char(8) NOT NULL,
      [date] smalldatetime NOT NULL,
      CONSTRAINT PK_DAILYWORKREPT PRIMARY KEY (reportID),
      CONSTRAINT FK_DAILYWORK_PROJ FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum)
    )

    CREATE TABLE WORK_JOBS (
      jobsID CHAR(5) NOT NULL,
      [hours] int NOT NULL,
      task VARCHAR(45) NOT NULL,
      laborCode char(6) NOT NULL,
      empID char(4) NOT NULL,
      CONSTRAINT PK_WORKOBS PRIMARY KEY (jobsID),
      CONSTRAINT FK1_WJ_LABOR FOREIGN KEY (laborCode)
        REFERENCES LABOR (laborCode),
      CONSTRAINT FK2_WJ_STAFF FOREIGN KEY (empID)
        REFERENCES STAFF (empID)
    )

    CREATE TABLE DAILY_MATERIALS_USED (
      dailyMaterialCode CHAR(8) NOT NULL,
			materialCode char(8),
      reportID char(5) NOT NULL,
      projectNum char(8) NOT NULL,
      Quantity INT NOT NULL,
      unitCost DECIMAL NOT NULL,
      extCost DECIMAL NOT NULL,
      approvedBy VARCHAR(45) NOT NULL,
      CONSTRAINT PK_DAILYMATERIAL PRIMARY KEY (dailyMaterialCode),
      CONSTRAINT FK1_DM_DWR FOREIGN KEY (reportID)
        REFERENCES DAILY_WORK_REPORT (reportID),
      CONSTRAINT FK2_DM_PROJECT FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum),
			CONSTRAINT FK3_DM_MATERIALS FOREIGN KEY (materialCode)
				REFERENCES MATERIALS (materialCode)
    )

    CREATE TABLE DAILY_WORK_REPORT_has_WORK_JOBS (
      reportID CHAR(5) NOT NULL,
      projectNum CHAR(8) NOT NULL,
      jobsID CHAR(5) NOT NULL,
      CONSTRAINT PK_DWR_WJ PRIMARY KEY (reportID, projectNum, jobsID),
      CONSTRAINT FK1_DWRWJ_DWR FOREIGN KEY (reportID)
        REFERENCES DAILY_WORK_REPORT (reportID),
      CONSTRAINT FK2_DWRWJ_PROJECT FOREIGN KEY (projectNum)
        REFERENCES PROJECT (projectNum),
      CONSTRAINT FK3_DWRWJ_WJ FOREIGN KEY (jobsID)
        REFERENCES WORK_JOBS (jobsID)
        )
    CREATE TABLE PLANT_SUPPLIERS (
      materialCode char(8) NOT NULL,
      supplierID char(5) NOT NULL,
      leadTimeOne CHAR(10) NOT NULL,
      preferred CHAR(1) NOT NULL,
      CONSTRAINT PK_PS PRIMARY KEY (materialCode, supplierID),
      CONSTRAINT FK_PS_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode),
      CONSTRAINT FK2_PS_SUPPLIERS FOREIGN KEY (supplierID)
        REFERENCES SUPPLIERS (supplierID)
    )

    CREATE TABLE INVOICE (
      invoiceNumber CHAR(10) NOT NULL,
      orderNum char(10) NOT NULL,
      [date] smalldatetime NOT NULL,
      CONSTRAINT PK_INVOICE PRIMARY KEY (invoiceNumber),
      CONSTRAINT FK_INVOICE_PO FOREIGN KEY (orderNum)
        REFERENCES PURCHASE_ORDERS (orderNum)
     )

    CREATE TABLE SHIPPED_MATERIALS (
      invoiceNumber CHAR(10) NOT NULL,
      materialCode char(8) NOT NULL,
      shipDate smalldatetime NOT NULL,
      qtyShipped INT NOT NULL,
      unitCharged smallmoney NOT NULL,
      tax smallmoney NOT NULL,
      orderNum char(10) NOT NULL,
      CONSTRAINT PK_SHIPPED PRIMARY KEY (invoiceNumber, materialCode),
      CONSTRAINT FK1_SHIPPED_MATERIALS FOREIGN KEY (materialCode)
        REFERENCES MATERIALS (materialCode),
      CONSTRAINT FK2_SHIPPED_INVOICE FOREIGN KEY (invoiceNumber)
        REFERENCES INVOICE (invoiceNumber),
      CONSTRAINT FK3_SHIPPED_PO FOREIGN KEY (orderNum)
        REFERENCES PURCHASE_ORDERS (orderNum)
    )
    ;

 GO

--CHECK CONSTRAINTS

--CLIENT


--1. Client's zip code should be exact 5 digits
ALTER TABLE CLIENT
ADD CONSTRAINT CHK_ClientZip
CHECK (zip LIKE '[0-9][0-9][0-9][0-9][0-9]')
;

/*
DESIGN_BID

1.	Status can only have values A, R, P*/
ALTER TABLE DESIGN_BID
ADD CONSTRAINT CHK_BIDSTATUS
CHECK ([status] IN ('A', 'R', 'P'))
;

 /*
BID-MATERIALS

1.	Qty must be greater than 0*/
ALTER TABLE BID_MATERIALS
ADD CONSTRAINT CHK_BIDMATERIAQTY
CHECK (bidQty > 0)
;


/*LANDSCAPE_MATERIALS

1.	Quantity in stock must be greater than or equal to 0 */
ALTER TABLE LANDSCAPE_MATERIALS
ADD CONSTRAINT CHK_LANDSCAPEQTY
CHECK (QIS >=0)
;

/*
POTTERY

1.	Size must be >0*/
ALTER TABLE POTTERY
ADD CONSTRAINT CHK_POTTERYSIZE
CHECK ( SIZE >0)
;

/*
PURCHASE_ORDERS

1.	orderTotal must be greater than 0*/
ALTER TABLE PURCHASE_ORDERS
ADD CONSTRAINT CHK_POTOTAL
CHECK (orderTotal >0)
;

/*
BID-LABOR

1.	Bid hours should be more than 0*/
ALTER TABLE BID_LABOR
ADD CONSTRAINT CHK_LABORHRS
CHECK (bidHours >0)
;
/*
2.	Labor cost should be greater than 0*/
ALTER TABLE BID_LABOR
ADD CONSTRAINT CHK_LABORCOST
CHECK (laborCost >0)
;

/*
OD_DETAILS

1.	Quantity should be greater than or equal to 0*/
ALTER TABLE OD_DETAILS
ADD CONSTRAINT CHK_ODQTY
CHECK ( quantity >0)
;

/*2.	Unit price should be greater than 0 */
ALTER TABLE OD_DETAILS
ADD CONSTRAINT CHK_ODPRICE
CHECK (unitPrice >0)
;
go

--TRIGGERS

-----WHEN DESIGN BID IS REJECTED, UPDATE QUANTITY IN STOCK IN POTTERY----
CREATE TRIGGER BID_STATUS_CHANGE_POTTERY
ON DESIGN_BID
AFTER UPDATE
AS
  IF UPDATE (STATUS)
  begin
    IF
      EXISTS (
        SELECT *
        FROM INSERTED I
        WHERE I.[status] = 'R'
      )
      BEGIN
        UPDATE POTTERY
        SET QIS+= BM.bidQty,
        FROM BID_MATERIALS BM JOIN DELETED D
             ON BM.bidID = D.bidID
                 JOIN POTTERY P
                 ON P.materialCode = BM.materialCode
      end
    end
;
go

-------------------------
------trigger to make sure that design_bid exists when inserting into BID_MATERIALS ---------

CREATE TRIGGER BID_MATERIALS_CHECK
ON BID_MATERIALS
AFTER INSERT
AS
IF (
  EXISTS (
    SELECT *
    FROM DESIGN_BID DB JOIN INSERTED I
      ON DB.[bidID] = I.[bidID]
  )
)
  BEGIN
    PRINT 'Record added successfully.'
  END
ELSE
  BEGIN
    ROLLBACK
    PRINT 'No such bidVersion exists in DESIGN_BID table. Record deleted.'
  END
;
go
------On insert into WORK_JOBS table, ensure empID exists in STAFF---------

CREATE TRIGGER STAFF_JOB_CHECK
ON WORK_JOBS
AFTER INSERT
AS
IF (
  EXISTS (
    SELECT *
    FROM STAFF S JOIN INSERTED I
      ON S.[empID] = I.[empID]
  )
)
  BEGIN
    PRINT 'Record added successfully.'
  END
ELSE
  BEGIN
    ROLLBACK
    PRINT 'No such employee exists in STAFF table. Record deleted.'
  END
;

go

--INSERTS

INSERT INTO ZIPTABLE (zip, city, state)
VALUES ('95066', 'Scotts Valley', 'CA')
;

INSERT INTO CLIENT (accountNum, [name], streetNum, streetName, zip)
VALUES
('00000001','London Sq Mal', '12638', 'Mall Drive', '95066')
;

INSERT INTO STAFF (empID, lName, fName, phone)
VALUES
('0001', 'Reinhardt', 'Bill','4087753652'),
('0002', 'Bakken', 'Tamara', '4087753645'),
('0003', 'Goce', 'Monica', '4087753646'),
('0004', 'Smith', 'Bert', '4087753647')
;

INSERT INTO MATERIALS
VALUES
	('TCP50', 'Pottery'),
	('GP50', 'Pottery'),
	('TCF03', 'Pottery'),
	('MBB30', 'Pottery'),
	('GFN48', 'Pottery'),
  ('CBRK5', 'Landscape'),
  ('CRGRN', 'Landscape'),
  ('PGRV', 'Landscape'),
  ('GRV1', 'Landscape'),
  ('TSOIL', 'Landscape'),
  ('PBLKG', 'Landscape'),
  ('PBLKR', 'Landscape'),
  ('lacco', 'Plant'),
  ('arenga', 'Plant'),
  ('cham', 'Plant'),
  ('cera', 'Plant'),
  ('areca', 'Plant'),
  ('cary', 'Plant'),
  ('grnti5', 'Plant'),
  ('grnti7', 'Plant'),
  ('ficus14', 'Plant'),
  ('ficus17', 'Plant'),
  ('margi', 'Plant')
;

BEGIN TRANSACTION TRAN1;

BEGIN TRY
  INSERT INTO PLANT_INV (materialCode, plantDesc, size, QIS, IS_OB, QO, OO_OB)
  VALUES
  ('lacco', 'lacco australasica','15', '3', '3', '3', '1'),
  ('arenga', 'arenga pinnata','15', '4', '2', '3', '0'),
  ('cham', 'chamaedorea','15', '0', '0', '2', '0'),
  ('cera', 'ceratozamia molongo','14', '4', '2', '6', '0'),
  ('areca', 'arecastum coco','15','11', '5', '0', '0'),
  ('cary', 'caryota mitis','7', '14', '9', '4', '0'),
  ('grnti5', 'green ti','5', '11', '8', '6', '0'),
  ('grnti7', 'green ti','7', '8', '5', '6', '0'),
  ('ficus14', 'ficus green gem','14', '7', '7' ,'20', '2'),
  ('ficus17', 'ficus green gem','17', '6', '4', '12', '0'),
  ('margi', 'marginata','2', '16', '13', '12', '0')
  ;
	COMMIT TRANSACTION;
	PRINT 'INSERTS INTO PLANT_INV SUCCESSFUL';
END TRY

BEGIN CATCH
  ROLLBACK TRANSACTION
  PRINT 'INSERTS FAILED'
END CATCH;


INSERT INTO POTTERY (materialCode, potteryDesc, QIS, IS_OB)
VALUES
	('TCP50','tc pot', '6', '3'),
	('GP50', 'granite pot', '5', '3'),
	('TCF03', 'tc figurine swan', '3', '1'),
	('MBB30', 'marble bird bath', '2', '1'),
	('GFN48', 'granite fountain', '1', '1')
;

  INSERT INTO LANDSCAPE_MATERIALS (materialCode, QIS)
  VALUES
  ('CBRK5', '53'),
  ('CRGRN', '12'),
  ('PGRV', '7'),
  ('GRV1', '18'),
  ('TSOIL', '10'),
  ('PBLKG', '94'),
  ('PBLKR', '123')
  ;

BEGIN TRANSACTION TRAN3;

BEGIN TRY
  INSERT INTO SUPPLIERS (supplierID, supplierName)
  VALUES
  ('00001', 'Palms'),
  ('00002', 'GPC'),
  ('00003', 'Greens'),
  ('00004', 'Olsen'),
  ('00005', 'TisRUs'),
  ('00006', 'Figs'),
  ('00007', 'Lunds')
  ;
	COMMIT TRANSACTION;
	PRINT 'INSERTS INTO SUPPLIERS SUCCESSFUL.';
END TRY

BEGIN CATCH
  ROLLBACK TRANSACTION
  PRINT 'INSERTS FAILED'
END CATCH;


INSERT INTO PURCHASE_ORDERS (orderNum, orderDate, orderTotal, supplierId)
VALUES
	('NBD05494', '5/05/18', '2554.20', '00003')
;

INSERT INTO OD_DETAILS (orderNum, materialCode, quantity, unitPrice)
VALUES
	('NBD05494', 'areca', '5', '284.00'),
	('NBD05494', 'arenga', '3', '315.00')
;

INSERT INTO INVOICE
VALUES
	('GR097694','NBD05494', '5/05/18');

INSERT INTO SHIPPED_MATERIALS (invoiceNumber, orderNum, materialCode, shipDate, qtyShipped, unitCharged, tax)
VALUES
	('GR097694', 'NBD05494', 'areca', '5/06/18', '5', '284.00', '113.60')
;

INSERT INTO PLANT_SUPPLIERS (materialCode, supplierID, leadTimeOne, preferred)
VALUES
	('lacco', '00001', '4', '1'),
	('lacco', '00007', '5', '2'),
	('arenga', '00002', '2', '1'),
	('arenga', '00003', '3', '2')
;

INSERT INTO CONTACT
VALUES
	('1', 'Amy', 'Benson', '4088345603', '00000001')
;

INSERT INTO LABOR
VALUES
	('PW', 'production workers'),
	('DC', 'design consultant'),
	('HEO', 'heavy equipment operator')
;

INSERT INTO PROJECT
VALUES
	('1', 'London Sq Mall', '12638', 'Mall Drive', '00000001', '1', '95066')
;

INSERT INTO DESIGN_BID (bidID, bidDate, estBeginDate, estCompletionDate, bidAmount, [status], projectNum)
VALUES
	('1', '05/06/2018', '06/15/2018', '06/15/2018', '10000.00', 'P', '1')
;

INSERT INTO BID_MATERIALS
VALUES
	('3', '749.00', '1', '1', 'lacco'),
	('5' ,'233.00', '1', '1', 'cary'),
	('7', '75.00' , '1', '1', 'margi'),
	('1', '750.00', '1', '1', 'GFN48'),
	('3', '195.00', '1', '1', 'GP50'),
	('10', '15.95', '1', '1', 'CBRK5'),
	('1', '20.00', '1', '1', 'TSOIL')
;

INSERT INTO BID_STAFF
VALUES
	('Sales Associate', '1', '1', '0001'),
	('Designer', '1', '1', '0002')
;

INSERT INTO BID_LABOR
VALUES
	('30', '30.00', '1', '1', 'PW'),
	('10', '65.00', '1', '1', 'DC'),
	('10', '65.00', '1', '1', 'HEO')
;

INSERT INTO DAILY_WORK_REPORT
VALUES
	('DWR1', '1', '5/05/2018')
;

INSERT INTO WORK_JOBS
VALUES
	('J1','8', 'installed plants and bark', 'PW', '0003'),
	('J2', '8', 'installed plants and bark', 'PW', '0004')
;

INSERT INTO DAILY_WORK_REPORT_has_WORK_JOBS
VALUES
 ('DWR1', '1', 'J1'),
 ('DWR1', '1', 'J2')
;

INSERT INTO DAILY_MATERIALS_USED
VALUES
	('DM1', 'cary', 'DWR1', '1', '5', '143.00', '715.00', 'B. Johnson'),
	('DM2', 'margi', 'DWR1', '1', '7', '45.00', '315.00', 'B. Johnson'),
	('DM3', 'CBRK5', 'DWR1', '1', '10', '7.50', '75.00', 'B. Johnson')
;

/*
VIEWS

1.	View to show the landscape materials with a unit price higher than average unit price
*/
CREATE VIEW [Landscape Materials Above Avg Price] AS
SELECT landscapeDesc, unitPrice
FROM LANDSCAPE_MATERIALS
WHERE unitPrice > (SELECT AVG(unitPrice) from LANDSCAPE_MATERIALS)
;
go
/*
2.	View to show the current bids pending
*/
CREATE VIEW [Current Pending Bids] AS
SELECT bidID, bidDate
FROM DESIGN_BID
WHERE status IN 'P'
AND bidDate BETWEEN '2018-01-01' AND getdate()
;
go
/*
3.	View to show total sales of shipped materials YTD
*/
CREATE VIEW [SHIP SALES 2018] AS
SELECT invoiceNumber, sum(unitCharged) AS  Invoice Sales
FROM SHIPPED_MATERIALS SM
JOIN INVOICE I ON SM.invoiceNumber = I.invoiceNumber
WHERE shipDate BETWEEN '2018-01-01' AND getdate()
;
go
