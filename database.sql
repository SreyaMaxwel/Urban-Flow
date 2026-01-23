-- Create Database
CREATE DATABASE IF NOT EXISTS urbanflow;
USE urbanflow;


-- Station Table
CREATE TABLE Station (
    station_id INT PRIMARY KEY AUTO_INCREMENT,
    station_name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    safety_score FLOAT
);

-- Vehicle Table
CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_type ENUM('Bus','Metro','Tram'),
    capacity INT,
    accessibility_capacity INT
);

-- Safety Threshold Configuration Table
CREATE TABLE Safety_Threshold (
    threshold_id INT PRIMARY KEY AUTO_INCREMENT,
    threshold_name VARCHAR(50),
    max_value INT
);

-- Incident Log Table
CREATE TABLE Incident_Log (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_type ENUM('Fall','Surge','Panic'),
    severity ENUM('Low','Medium','High'),
    status ENUM('Open','Resolved'),
    reported_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    station_id INT,
    vehicle_id INT,
    FOREIGN KEY (station_id) REFERENCES Station(station_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

-- Accessibility Request Table
CREATE TABLE Accessibility_Request (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    requirement_type ENUM('Wheelchair','Stroller','Elderly'),
    request_status ENUM('Pending','Approved','Rejected'),
    vehicle_id INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

-- ===============================
-- WEAK ENTITIES
-- ===============================

-- Station Amenity (Weak Entity)
CREATE TABLE Station_Amenity (
    station_id INT,
    amenity_type ENUM('Ramp','Elevator','CCTV'),
    is_operational TINYINT(1),
    PRIMARY KEY (station_id, amenity_type),
    FOREIGN KEY (station_id) REFERENCES Station(station_id)
);

-- Crowd Log (Weak Entity)
CREATE TABLE Crowd_Log (
    log_id INT AUTO_INCREMENT,
    vehicle_id INT,
    footfall_count INT,
    anomaly_flag TINYINT(1),
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (log_id, vehicle_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

-- ===============================
-- RELATIONSHIP TABLES
-- ===============================

-- Occurs_At (Station ↔ Incident)
CREATE TABLE Occurs_At (
    station_id INT,
    incident_id INT,
    PRIMARY KEY (station_id, incident_id),
    FOREIGN KEY (station_id) REFERENCES Station(station_id),
    FOREIGN KEY (incident_id) REFERENCES Incident_Log(incident_id)
);

-- Involves (Vehicle ↔ Incident)
CREATE TABLE Involves (
    vehicle_id INT,
    incident_id INT,
    PRIMARY KEY (vehicle_id, incident_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (incident_id) REFERENCES Incident_Log(incident_id)
);

-- Reserves (Vehicle ↔ Accessibility Request)
CREATE TABLE Reserves (
    vehicle_id INT,
    request_id INT,
    PRIMARY KEY (vehicle_id, request_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id),
    FOREIGN KEY (request_id) REFERENCES Accessibility_Request(request_id)
);

-- Monitors (Station ↔ Station Amenity)
CREATE TABLE Monitors (
    station_id INT,
    amenity_type ENUM('Ramp','Elevator','CCTV'),
    PRIMARY KEY (station_id, amenity_type),
    FOREIGN KEY (station_id, amenity_type)
        REFERENCES Station_Amenity(station_id, amenity_type)
);

-- ===============================
-- SAMPLE DATA INSERTION
-- ===============================

-- Stations
INSERT INTO Station (station_name, location) VALUES
('MG Road Metro', 'Kochi'),
('Aluva Metro', 'Aluva'),
('Edappally Station', 'Edappally'),
('Vyttila Hub', 'Vyttila');

-- Vehicles
INSERT INTO Vehicle (vehicle_type, capacity, accessibility_capacity) VALUES
('Metro', 200, 10),
('Bus', 50, 2),
('Bus', 60, 3),
('Metro', 300, 15);

-- Safety Thresholds
INSERT INTO Safety_Threshold (threshold_name, max_value) VALUES
('Max_Density', 150),
('Max_Footfall', 500),
('Max_Vehicle_Load', 250);

-- Incident Logs
INSERT INTO Incident_Log (incident_type, severity, status, station_id, vehicle_id) VALUES
('Surge', 'High', 'Open', 1, 1),
('Fall', 'Medium', 'Resolved', 2, NULL),
('Panic', 'High', 'Open', 3, 2);

-- Accessibility Requests
INSERT INTO Accessibility_Request (requirement_type, request_status, vehicle_id) VALUES
('Wheelchair', 'Approved', 1),
('Elderly', 'Pending', 2),
('Stroller', 'Rejected', 3);

-- Station Amenities
INSERT INTO Station_Amenity VALUES
(1, 'Elevator', 1),
(1, 'Ramp', 1),
(2, 'CCTV', 1),
(3, 'Ramp', 0);

-- Crowd Logs
INSERT INTO Crowd_Log (vehicle_id, footfall_count, anomaly_flag) VALUES
(1, 180, 0),
(2, 260, 1),
(3, 120, 0);
