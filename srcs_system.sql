-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 15, 2025 at 07:31 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `srcs_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `address_id` int(11) NOT NULL,
  `branch_name` varchar(255) NOT NULL,
  `attention_to` varchar(255) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `location_details` text DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`address_id`, `branch_name`, `attention_to`, `designation`, `location_details`, `email`, `mobile`) VALUES
(1, 'SRCS Garowe Branch', 'Jamal Said', 'Puntland Logistics and Procurement Officer', 'Near Parliament House', 'srcs@example.com', '+2527709169'),
(2, 'SRCS Garowe Branch', 'Jamal Said', 'Puntland Logistics and Procurement Officer', 'Near Parliament House', 'srcs@example.com', '+2527709169'),
(3, 'SRCS Garowe Branch', 'Jamal Said', 'Puntland Logistics and Procurement Officer', 'Near Parliament House', 'srcs@example.com', '+2527709169'),
(4, 'SRCS Garowe Branch', 'Jamal Said', 'Puntland Logistics and Procurement Officer', 'Near Parliament House', 'srcs@example.com', '+2527709169'),
(5, 'SRCS Garowe Branchs', 'Jamal Said Muse', 'Puntland Logistics and Procurement Officers', 'Near Parliament House', 'srcs@example.com', '+2527709169');

-- --------------------------------------------------------

--
-- Table structure for table `approvalworkflow`
--

CREATE TABLE `approvalworkflow` (
  `id` int(11) NOT NULL,
  `requisition_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('Requester','Project Manager','Finance Officer','Logistics Officer','Global Fleet') NOT NULL,
  `status` enum('Pending','Approved','Rejected') DEFAULT 'Pending',
  `remarks` text DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `conditions`
--

CREATE TABLE `conditions` (
  `id` int(11) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `conditions`
--

INSERT INTO `conditions` (`id`, `description`, `created_at`) VALUES
(2, 'condition one', '2024-12-19 11:35:50'),
(3, 'condition two', '2024-12-19 11:36:01');

-- --------------------------------------------------------

--
-- Table structure for table `general_terms`
--

CREATE TABLE `general_terms` (
  `id` int(11) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `general_terms`
--

INSERT INTO `general_terms` (`id`, `description`, `created_at`) VALUES
(2, 'abcd', '2024-12-19 11:34:43'),
(3, 'cdef', '2024-12-19 11:35:12');

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `qty` int(11) NOT NULL,
  `uom` varchar(50) NOT NULL,
  `price_per_unit` decimal(10,2) NOT NULL,
  `total_price` decimal(15,2) GENERATED ALWAYS AS (`qty` * `price_per_unit`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `items`
--

INSERT INTO `items` (`item_id`, `rfq_id`, `description`, `qty`, `uom`, `price_per_unit`) VALUES
(1, 4, 'Product A', 10, 'Units', '50.00'),
(3, 4, 'Product B', 5, 'Boxes', '100.00'),
(5, 4, 'Product A', 10, 'Units', '50.00'),
(6, 4, 'Product B', 5, 'Boxes', '100.00'),
(8, 16, 'cunto', 10, 'pcs', '5.00'),
(9, 16, 'cabitaan', 20, 'pcs', '40.00');

--
-- Triggers `items`
--
DELIMITER $$
CREATE TRIGGER `update_grand_total_after_item_delete` AFTER DELETE ON `items` FOR EACH ROW BEGIN
    UPDATE RFQs
    SET grand_total = (
        SELECT COALESCE(SUM(total_price), 0)
        FROM Items
        WHERE rfq_id = OLD.rfq_id
    )
    WHERE rfq_id = OLD.rfq_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_grand_total_after_item_insert` AFTER INSERT ON `items` FOR EACH ROW BEGIN
    UPDATE RFQs
    SET grand_total = (
        SELECT SUM(total_price)
        FROM Items
        WHERE rfq_id = NEW.rfq_id
    )
    WHERE rfq_id = NEW.rfq_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `requirements`
--

CREATE TABLE `requirements` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `quotation_valid_from` date NOT NULL,
  `quotation_valid_to` date NOT NULL,
  `payment_terms` varchar(255) NOT NULL,
  `delivery_time_days` int(11) NOT NULL,
  `client_reference_1` varchar(255) NOT NULL,
  `client_reference_2` varchar(255) NOT NULL,
  `client_reference_3` varchar(255) NOT NULL,
  `purchase_order_1` text NOT NULL,
  `purchase_order_2` text NOT NULL,
  `purchase_order_3` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requirements`
--

INSERT INTO `requirements` (`id`, `rfq_id`, `quotation_valid_from`, `quotation_valid_to`, `payment_terms`, `delivery_time_days`, `client_reference_1`, `client_reference_2`, `client_reference_3`, `purchase_order_1`, `purchase_order_2`, `purchase_order_3`, `created_at`, `updated_at`) VALUES
(2, 4, '2024-12-01', '2024-12-31', 'Net 30', 15, 'Ref123', 'Ref124', 'Ref125', 'PO#1 Details', 'PO#2 Details', 'PO#3 Details', '2024-12-18 17:57:07', '2024-12-18 17:57:07'),
(3, 4, '2024-12-01', '2024-12-31', 'Net 30', 15, 'Ref123', 'Ref124', 'Ref125', 'PO#1 Details', 'PO#2 Details', 'PO#3 Details', '2024-12-18 17:57:21', '2024-12-18 17:57:21'),
(4, 4, '2024-12-01', '2024-12-31', 'Net 30', 15, 'Ref123', 'Ref124', 'Ref125', 'PO#1 Details', 'PO#2 Details', 'PO#3 Details', '2024-12-18 18:00:16', '2024-12-18 18:00:16'),
(6, 16, '2024-12-01', '2024-12-31', 'net30', 20, 'Ref16', '17', '18', 'PO#1', 'P0#2', 'PO#3', '2024-12-24 10:37:23', '2024-12-24 10:37:23'),
(7, 16, '2024-12-13', '2024-12-27', 'net50', 14, 'Ref1', 'Ref2', 'Ref3', 'PO#1', 'PO#2', 'PO#3', '2024-12-24 10:38:43', '2024-12-24 10:38:43');

-- --------------------------------------------------------

--
-- Table structure for table `requisitionitems`
--

CREATE TABLE `requisitionitems` (
  `id` int(11) NOT NULL,
  `requisition_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `uom` varchar(50) DEFAULT NULL,
  `price_per_unit` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) GENERATED ALWAYS AS (`qty` * `price_per_unit`) STORED,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requisitionitems`
--

INSERT INTO `requisitionitems` (`id`, `requisition_id`, `item_id`, `qty`, `uom`, `price_per_unit`, `created_at`) VALUES
(5, 2, 1, 10, 'Units', '50.00', '2025-01-09 08:45:00'),
(6, 2, 3, 5, 'Boxes', '100.00', '2025-01-09 08:45:00'),
(7, 2, 5, 10, 'Units', '50.00', '2025-01-09 08:45:00'),
(8, 2, 6, 5, 'Boxes', '100.00', '2025-01-09 08:45:00');

-- --------------------------------------------------------

--
-- Table structure for table `requisitions`
--

CREATE TABLE `requisitions` (
  `requisition_id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `delivery_address_id` int(11) NOT NULL,
  `to_location` varchar(255) DEFAULT NULL,
  `from_location` varchar(255) DEFAULT NULL,
  `created_date` date DEFAULT curdate(),
  `transport_means` enum('Air','Sea','Road') DEFAULT 'Road',
  `project_code` varchar(50) DEFAULT NULL,
  `activity` varchar(255) DEFAULT NULL,
  `m_code` varchar(50) DEFAULT NULL,
  `currency` enum('USD','EUR','SOM') DEFAULT 'USD',
  `current_state` enum('Requester','Project Manager','Finance Officer','Logistics Officer','Global Fleet','Approved') DEFAULT 'Requester',
  `status` enum('Draft','Pending','Approved','Rejected') DEFAULT 'Draft',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `requisitions`
--

INSERT INTO `requisitions` (`requisition_id`, `rfq_id`, `delivery_address_id`, `to_location`, `from_location`, `created_date`, `transport_means`, `project_code`, `activity`, `m_code`, `currency`, `current_state`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(2, 4, 2, 'Warehouse B', 'Head Office', '2025-01-09', 'Air', 'P1234', 'Construction Materials', 'M001', 'USD', 'Approved', 'Pending', 1, '2025-01-09 08:45:00', '2025-01-12 06:51:15');

-- --------------------------------------------------------

--
-- Table structure for table `rfqs`
--

CREATE TABLE `rfqs` (
  `rfq_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `status` enum('Draft','Sent','Awarded') DEFAULT 'Draft',
  `approved_by` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `validity_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `grand_total` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfqs`
--

INSERT INTO `rfqs` (`rfq_id`, `supplier_id`, `created_by`, `status`, `approved_by`, `address_id`, `validity_id`, `created_at`, `updated_at`, `grand_total`) VALUES
(4, 2, 1, 'Draft', 1, 1, 4, '2024-12-18 15:16:42', '2024-12-18 18:00:16', '2000.00'),
(15, 2, 1, 'Draft', 1, 1, NULL, '2024-12-19 11:41:20', '2024-12-19 11:41:20', '0.00'),
(16, 2, 1, 'Draft', 1, 1, NULL, '2024-12-22 07:00:58', '2024-12-24 10:28:27', '850.00'),
(17, 2, 1, 'Sent', 1, 1, NULL, '2024-12-25 15:55:08', '2024-12-25 16:11:21', '0.00');

-- --------------------------------------------------------

--
-- Table structure for table `rfq_conditions`
--

CREATE TABLE `rfq_conditions` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `condition_id` int(11) NOT NULL,
  `specific_time` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfq_conditions`
--

INSERT INTO `rfq_conditions` (`id`, `rfq_id`, `condition_id`, `specific_time`, `created_at`) VALUES
(7, 15, 2, NULL, '2024-12-19 11:41:20'),
(8, 15, 3, NULL, '2024-12-19 11:41:20'),
(9, 16, 2, NULL, '2024-12-22 07:00:58'),
(10, 16, 3, NULL, '2024-12-22 07:00:58'),
(11, 17, 2, NULL, '2024-12-25 15:55:08'),
(12, 17, 3, NULL, '2024-12-25 15:55:08');

-- --------------------------------------------------------

--
-- Table structure for table `rfq_criteria`
--

CREATE TABLE `rfq_criteria` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `criteria_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfq_criteria`
--

INSERT INTO `rfq_criteria` (`id`, `rfq_id`, `criteria_id`, `created_at`) VALUES
(7, 15, 2, '2024-12-19 11:41:20'),
(8, 15, 3, '2024-12-19 11:41:20'),
(9, 16, 2, '2024-12-22 07:00:58'),
(10, 16, 3, '2024-12-22 07:00:58'),
(11, 17, 2, '2024-12-25 15:55:08'),
(12, 17, 3, '2024-12-25 15:55:08');

-- --------------------------------------------------------

--
-- Table structure for table `rfq_general_terms`
--

CREATE TABLE `rfq_general_terms` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `term_id` int(11) NOT NULL,
  `confirmed_by` int(11) DEFAULT NULL,
  `confirmation_status` enum('Confirmed','Pending') DEFAULT 'Pending',
  `confirmed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfq_general_terms`
--

INSERT INTO `rfq_general_terms` (`id`, `rfq_id`, `term_id`, `confirmed_by`, `confirmation_status`, `confirmed_at`) VALUES
(9, 15, 2, NULL, 'Pending', NULL),
(10, 15, 3, NULL, 'Pending', NULL),
(11, 16, 2, NULL, 'Pending', NULL),
(12, 16, 3, NULL, 'Pending', NULL),
(13, 17, 2, NULL, 'Pending', NULL),
(14, 17, 3, NULL, 'Pending', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `rfq_requirement`
--

CREATE TABLE `rfq_requirement` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `validity_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfq_requirement`
--

INSERT INTO `rfq_requirement` (`id`, `rfq_id`, `validity_id`, `created_at`) VALUES
(6, 16, 0, '2024-12-24 10:41:34'),
(7, 16, 2, '2024-12-24 10:43:49');

-- --------------------------------------------------------

--
-- Table structure for table `rfq_suppliers`
--

CREATE TABLE `rfq_suppliers` (
  `id` int(11) NOT NULL,
  `rfq_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rfq_suppliers`
--

INSERT INTO `rfq_suppliers` (`id`, `rfq_id`, `supplier_id`, `created_at`, `updated_at`) VALUES
(1, 16, 2, '2024-12-22 07:00:58', '2024-12-22 07:00:58'),
(2, 16, 3, '2024-12-22 07:00:58', '2024-12-22 07:00:58'),
(3, 17, 2, '2024-12-25 16:11:21', '2024-12-25 16:11:21'),
(4, 17, 3, '2024-12-25 16:11:21', '2024-12-25 16:11:21');

-- --------------------------------------------------------

--
-- Table structure for table `selection_criteria`
--

CREATE TABLE `selection_criteria` (
  `id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `selection_criteria`
--

INSERT INTO `selection_criteria` (`id`, `description`, `created_at`) VALUES
(2, 'criteria one', '2024-12-19 11:40:56'),
(3, 'criteria two', '2024-12-19 11:41:05');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `contactPerson` text DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`, `email`, `telephone`, `contactPerson`, `address`, `created_at`, `updated_at`) VALUES
(2, 'Updated Supplier Name', 'updated@srcs.com', '+25298765432', 'ali isse abdi', 'Updated Address', '2024-12-09 09:46:03', '2024-12-09 09:46:03'),
(3, 'Updated Supplier Name', 'updated@srcs.com', '+25298765432', 'ali isse abdi', 'Updated Address', '2024-12-09 09:46:06', '2024-12-09 09:46:06'),
(4, 'Updated Supplier Name', 'updated1@srcs.com', '+25298765432', 'ali isse abdi', 'Updated Address', '2024-12-09 09:46:29', '2024-12-09 09:46:29'),
(5, 'Updated Supplier Name', 'updated2@srcs.com', '+25298765432', 'ali isse abdi', 'Updated Address', '2024-12-09 09:46:34', '2024-12-09 09:46:34');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `designation` varchar(255) DEFAULT NULL,
  `role` enum('Requester','Approver','Viewer') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `approval_stage` enum('Requester','Project Manager','Finance Officer','Logistics Officer','Global Fleet') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `phone_number`, `designation`, `role`, `created_at`, `updated_at`, `approval_stage`) VALUES
(1, 'John Doe', 'john.doe@example.com', '1234567890', 'Logistics Officer', 'Requester', '2024-12-18 13:50:17', '2025-01-09 13:07:52', 'Requester'),
(2, 'abdi ali', 'abdi@gmail.com', '123456789', 'Project Manager', 'Approver', '2025-01-09 11:58:55', '2025-01-09 13:08:03', 'Project Manager'),
(3, 'ciise', 'ciise@gmail.com', '123456789', 'Finance Officer', 'Approver', '2025-01-09 13:15:03', '2025-01-09 13:21:18', 'Finance Officer'),
(4, 'xasan', 'xasan@gmail.com', '123456789', 'Logistics Officer', 'Approver', '2025-01-09 13:20:53', '2025-01-09 13:20:53', 'Logistics Officer'),
(5, 'brad', 'brad@gmail.com', '123456789', 'Global Fleet', 'Approver', '2025-01-09 13:21:57', '2025-01-09 13:21:57', 'Global Fleet');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`address_id`);

--
-- Indexes for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requisition_id` (`requisition_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `conditions`
--
ALTER TABLE `conditions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `general_terms`
--
ALTER TABLE `general_terms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `rfq_id` (`rfq_id`);

--
-- Indexes for table `requirements`
--
ALTER TABLE `requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_requirements_rfq` (`rfq_id`);

--
-- Indexes for table `requisitionitems`
--
ALTER TABLE `requisitionitems`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requisition_id` (`requisition_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `requisitions`
--
ALTER TABLE `requisitions`
  ADD PRIMARY KEY (`requisition_id`),
  ADD KEY `rfq_id` (`rfq_id`),
  ADD KEY `delivery_address_id` (`delivery_address_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `rfqs`
--
ALTER TABLE `rfqs`
  ADD PRIMARY KEY (`rfq_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `address_id` (`address_id`),
  ADD KEY `rfqs_ibfk_4` (`validity_id`),
  ADD KEY `rfqs_ibfk_5` (`created_by`);

--
-- Indexes for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq` (`rfq_id`),
  ADD KEY `fk_condition` (`condition_id`);

--
-- Indexes for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq_criteria_rfq` (`rfq_id`),
  ADD KEY `fk_rfq_criteria_criteria` (`criteria_id`);

--
-- Indexes for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq_gt` (`rfq_id`),
  ADD KEY `fk_gt_term` (`term_id`),
  ADD KEY `fk_gt_user` (`confirmed_by`);

--
-- Indexes for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfq_id` (`rfq_id`);

--
-- Indexes for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfq_id` (`rfq_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `selection_criteria`
--
ALTER TABLE `selection_criteria`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conditions`
--
ALTER TABLE `conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `general_terms`
--
ALTER TABLE `general_terms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `requirements`
--
ALTER TABLE `requirements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `requisitionitems`
--
ALTER TABLE `requisitionitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `requisitions`
--
ALTER TABLE `requisitions`
  MODIFY `requisition_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `rfqs`
--
ALTER TABLE `rfqs`
  MODIFY `rfq_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `selection_criteria`
--
ALTER TABLE `selection_criteria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  ADD CONSTRAINT `approvalworkflow_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `requisitions` (`requisition_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `approvalworkflow_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`);

--
-- Constraints for table `requirements`
--
ALTER TABLE `requirements`
  ADD CONSTRAINT `fk_requirements_rfq` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;

--
-- Constraints for table `requisitionitems`
--
ALTER TABLE `requisitionitems`
  ADD CONSTRAINT `requisitionitems_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `requisitions` (`requisition_id`),
  ADD CONSTRAINT `requisitionitems_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`);

--
-- Constraints for table `requisitions`
--
ALTER TABLE `requisitions`
  ADD CONSTRAINT `requisitions_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`),
  ADD CONSTRAINT `requisitions_ibfk_2` FOREIGN KEY (`delivery_address_id`) REFERENCES `addresses` (`address_id`),
  ADD CONSTRAINT `requisitions_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `rfqs`
--
ALTER TABLE `rfqs`
  ADD CONSTRAINT `rfqs_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  ADD CONSTRAINT `rfqs_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `rfqs_ibfk_3` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`),
  ADD CONSTRAINT `rfqs_ibfk_4` FOREIGN KEY (`validity_id`) REFERENCES `requirements` (`id`),
  ADD CONSTRAINT `rfqs_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  ADD CONSTRAINT `fk_condition` FOREIGN KEY (`condition_id`) REFERENCES `conditions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rfq` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;

--
-- Constraints for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  ADD CONSTRAINT `fk_rfq_criteria_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `selection_criteria` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rfq_criteria_rfq` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;

--
-- Constraints for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  ADD CONSTRAINT `fk_gt_term` FOREIGN KEY (`term_id`) REFERENCES `general_terms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_gt_user` FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rfq_gt` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;

--
-- Constraints for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  ADD CONSTRAINT `rfq_requirement_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`),
  ADD CONSTRAINT `rfq_requirement_ibfk_2` FOREIGN KEY (`id`) REFERENCES `requirements` (`id`);

--
-- Constraints for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  ADD CONSTRAINT `rfq_suppliers_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rfq_suppliers_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE CASCADE;


-- --------------------------------------------------------

--
-- Table structure for table `purchaseorders`
--

CREATE TABLE `purchaseorders` (
  `po_id` int(11) NOT NULL,
  `requisition_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `address_id` int(11) NOT NULL,
  `po_code` varchar(50) NOT NULL,
  `required_ship_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `purchaseorders`
--
ALTER TABLE `purchaseorders`
  ADD PRIMARY KEY (`po_id`),
  ADD UNIQUE KEY `po_code` (`po_code`),
  ADD KEY `requisition_id` (`requisition_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `address_id` (`address_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `purchaseorders`
--
ALTER TABLE `purchaseorders`
  MODIFY `po_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `purchaseorders`
--
ALTER TABLE `purchaseorders`
  ADD CONSTRAINT `purchaseorders_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `requisitions` (`requisition_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchaseorders_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchaseorders_ibfk_3` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`) ON DELETE CASCADE;

-- --------------------------------------------------------

--
-- Table structure for table `purchaseorderitems`
--

CREATE TABLE `purchaseorderitems` (
  `item_id` int(11) NOT NULL,
  `po_id` int(11) NOT NULL,
  `description` text NOT NULL,
  `qty` int(11) NOT NULL,
  `uom` varchar(50) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `purchaseorderitems`
--
ALTER TABLE `purchaseorderitems`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `po_id` (`po_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `purchaseorderitems`
--
ALTER TABLE `purchaseorderitems`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `purchaseorderitems`
--
ALTER TABLE `purchaseorderitems`
  ADD CONSTRAINT `purchaseorderitems_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchaseorders` (`po_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


