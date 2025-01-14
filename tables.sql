CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telephone VARCHAR(50),
    contactPerson TEXT
);

CREATE TABLE RFQs (
    rfq_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT NOT NULL,
    created_by INT NOT NULL,
    delivery_address TEXT,
    validity_period INT,
    payment_terms TEXT,
    grand_total DECIMAL(15, 2),
    status ENUM('Draft', 'Sent', 'Awarded') DEFAULT 'Draft',
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id)
);

CREATE TABLE Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT NOT NULL,
    description TEXT NOT NULL,
    qty INT NOT NULL,
    uom VARCHAR(50) NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(15, 2) GENERATED ALWAYS AS (qty * price_per_unit) STORED,
    FOREIGN KEY (rfq_id) REFERENCES RFQs(rfq_id)
);

CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL,        -- e.g., "SRCS Garowe branch"
    attention_to VARCHAR(255),               -- e.g., "Jamal Said"
    designation VARCHAR(255),                -- e.g., "Puntland Logistics and Procurement Officer"
    location_details TEXT,                   -- e.g., "Close to parliament house"
    email VARCHAR(255),                      -- e.g., "srcs@gmail.com"
    mobile VARCHAR(50)                       -- e.g., "+2527709169"
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,              -- Full name of the individual
    email VARCHAR(255) UNIQUE NOT NULL,      -- Email address
    phone_number VARCHAR(50),                -- Contact number
    designation VARCHAR(255),                -- e.g., "Logistics Officer", "Project Manager"
    role ENUM('Requester', 'Approver', 'Viewer') NOT NULL, -- Role in the system
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


ALTER TABLE RFQs
ADD approved_by INT,  -- References the logistics officer approving the RFQ
ADD FOREIGN KEY (approved_by) REFERENCES Users(user_id);

ALTER TABLE RFQs
ADD address_id INT,
ADD FOREIGN KEY (address_id) REFERENCES Addresses(address_id);

ALTER TABLE RFQs
ADD created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;



CREATE TABLE ApprovalWorkflow (
    workflow_id INT AUTO_INCREMENT PRIMARY KEY,
    form_type ENUM('RFQ', 'LogisticsRequisition') NOT NULL,  -- Type of form
    form_id INT NOT NULL,                                    -- ID of the form being approved
    user_id INT NOT NULL,                                    -- ID of the approver
    approval_status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    approval_date TIMESTAMP NULL,                           -- When approval/rejection occurred
    FOREIGN KEY (form_id) REFERENCES RFQs(rfq_id),          -- Change if for LogisticsRequisition
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE conditions (
    id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique identifier for the condition
    description TEXT NOT NULL,            -- Description of the condition
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
);

CREATE TABLE rfq_conditions (
    id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique identifier for the relationship
    rfq_id INT(11) NOT NULL,                 -- Foreign key referencing the RFQ
    condition_id INT(11) NOT NULL,           -- Foreign key referencing the condition
    specific_time DATETIME DEFAULT NULL,     -- Custom time specific to the RFQ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Record creation timestamp

    -- Foreign Key Constraints
    CONSTRAINT fk_rfq FOREIGN KEY (rfq_id) REFERENCES rfqs(rfq_id) ON DELETE CASCADE,
    CONSTRAINT fk_condition FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE rfq_criteria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT(11) NOT NULL,
    criteria_id INT(11) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Unique Foreign Key Constraints
    CONSTRAINT fk_rfq_criteria_rfq FOREIGN KEY (rfq_id) REFERENCES rfqs(rfq_id) ON DELETE CASCADE,
    CONSTRAINT fk_rfq_criteria_criteria FOREIGN KEY (criteria_id) REFERENCES selection_criteria(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE general_terms (
    id INT AUTO_INCREMENT PRIMARY KEY, -- Unique identifier for the term
    description TEXT NOT NULL,         -- The term or condition text
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Record creation timestamp
) ENGINE=InnoDB;

CREATE TABLE rfq_general_terms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT NOT NULL,
    term_id INT NOT NULL,
    confirmed_by VARCHAR(255),
    confirmation_status ENUM('Pending', 'Confirmed') DEFAULT 'Pending',
    confirmed_at TIMESTAMP NULL DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rfq_id) REFERENCES rfqs(rfq_id),
    FOREIGN KEY (term_id) REFERENCES general_terms(id)
);

CREATE TABLE requirements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quotation_valid_from DATE NOT NULL,
    quotation_valid_to DATE NOT NULL,
    payment_terms VARCHAR(255) NOT NULL,
    delivery_time_days INT NOT NULL,
    client_reference_1 VARCHAR(255) NOT NULL,
    client_reference_2 VARCHAR(255) NOT NULL,
    client_reference_3 VARCHAR(255) NOT NULL,
    purchase_order_1 TEXT NOT NULL,
    purchase_order_2 TEXT NOT NULL,
    purchase_order_3 TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE rfq_requirement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT NOT NULL,
    validity_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rfq_id) REFERENCES rfqs(rfq_id),
    FOREIGN KEY (id) REFERENCES requirements(id)
);


DELIMITER $$

CREATE TRIGGER update_grand_total_after_item_insert
AFTER INSERT ON Items
FOR EACH ROW
BEGIN
    UPDATE RFQs
    SET grand_total = (
        SELECT SUM(total_price)
        FROM Items
        WHERE rfq_id = NEW.rfq_id
    )
    WHERE rfq_id = NEW.rfq_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER update_grand_total_after_item_delete
AFTER DELETE ON Items
FOR EACH ROW
BEGIN
    UPDATE RFQs
    SET grand_total = (
        SELECT COALESCE(SUM(total_price), 0)
        FROM Items
        WHERE rfq_id = OLD.rfq_id
    )
    WHERE rfq_id = OLD.rfq_id;
END$$

DELIMITER ;

CREATE TABLE rfq_suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT NOT NULL,
    supplier_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rfq_id) REFERENCES RFQs(rfq_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);



CREATE TABLE Requisitions (
    requisition_id INT AUTO_INCREMENT PRIMARY KEY,
    rfq_id INT NOT NULL, -- References the approved RFQ
    delivery_address_id INT NOT NULL, -- References centralized addresses
    to_location VARCHAR(255),
    from_location VARCHAR(255),
    created_date DATE DEFAULT CURRENT_DATE,
    transport_means ENUM('Air', 'Sea', 'Road') DEFAULT 'Road',
    project_code VARCHAR(50), -- Accounting code section
    activity VARCHAR(255),
    m_code VARCHAR(50),
    currency ENUM('USD', 'EUR', 'SOM') DEFAULT 'USD',
    current_state ENUM('Requester', 'Project Manager', 'Finance Officer', 'Logistics', 'Global Fleet') DEFAULT 'Requester',
    status ENUM('Draft', 'Pending', 'Approved', 'Rejected') DEFAULT 'Draft',
    created_by INT NOT NULL, -- The user who created the requisition
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rfq_id) REFERENCES RFQs(rfq_id),
    FOREIGN KEY (delivery_address_id) REFERENCES Addresses(address_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);




field = supplier_id
Type = int(11)
Null = NO
Key = PRI
Default = NULL
Extra = auto_increment

field = name
Type = varchar(255)
Null = NO
Default = NULL

field = email
Type = varchar(255)
Null = NO
Default = NULL

field = telephone
Type = varchar(50)
Null = YES
Default = NULL

field = contactPerson
Type = text
Null = YES
Default = NULL

field = address
Type = text
Null = YES
Default = NULL

field = created_at
Type = timestamp
Null = NO
Default = current_timestamp()

field = updated_at
Type = timestamp
Null = NO
Default = current_timestamp()
Extra = on update current_timestamp()





Field = rfq_id
Type = int(11)
Null = NO
Key = PRI
Default = NULL
Extra = auto_increment

Field = supplier_id
Type = int(11)
Null = NO
Key = MUL
Default = NULL

Field = created_by
Type = int(11)
Null = NO
Key = MUL
Default = NULL

Field = status
Type = enum('Draft','Sent','Awarded')
Null = YES
Default = Draft

Field = approved_by
Type = int(11)
Null = YES
Key = MUL
Default = NULL

Field = address_id
Type = int(11)
Null = YES
Key = MUL
Default = NULL

Field = validity_id
Type = int(11)
Null = YES
Key = MUL
Default = NULL

Field = created_at
Type = timestamp
Null = NO
Default = current_timestamp()

Field = updated_at
Type = timestamp
Null = NO
Default = current_timestamp()
Extra = on update current_timestamp()

Field = grand_total
Type = decimal(15,2)
Null = YES
Default = 0.00
