-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 14, 2025 at 06:54 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

-- Database: `srcs_system`
--

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `requisitions`
--
ALTER TABLE `requisitions`
  ADD PRIMARY KEY (`requisition_id`),
  ADD KEY `rfq_id` (`rfq_id`),
  ADD KEY `delivery_address_id` (`delivery_address_id`),
  ADD KEY `created_by` (`created_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `requisitions`
--
ALTER TABLE `requisitions`
  MODIFY `requisition_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `requisitions`
--
ALTER TABLE `requisitions`
  ADD CONSTRAINT `requisitions_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`),
  ADD CONSTRAINT `requisitions_ibfk_2` FOREIGN KEY (`delivery_address_id`) REFERENCES `addresses` (`address_id`),
  ADD CONSTRAINT `requisitions_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

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
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `selection_criteria`
--
ALTER TABLE `selection_criteria`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `selection_criteria`
--
ALTER TABLE `selection_criteria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfq_id` (`rfq_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfq_suppliers`
--
ALTER TABLE `rfq_suppliers`
  ADD CONSTRAINT `rfq_suppliers_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rfq_suppliers_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE CASCADE;
COMMIT;
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rfq_id` (`rfq_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfq_requirement`
--
ALTER TABLE `rfq_requirement`
  ADD CONSTRAINT `rfq_requirement_ibfk_1` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`),
  ADD CONSTRAINT `rfq_requirement_ibfk_2` FOREIGN KEY (`id`) REFERENCES `requirements` (`id`);
COMMIT;
- --------------------------------------------------------

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq_gt` (`rfq_id`),
  ADD KEY `fk_gt_term` (`term_id`),
  ADD KEY `fk_gt_user` (`confirmed_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfq_general_terms`
--
ALTER TABLE `rfq_general_terms`
  ADD CONSTRAINT `fk_gt_term` FOREIGN KEY (`term_id`) REFERENCES `general_terms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_gt_user` FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_rfq_gt` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;
COMMIT;
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq_criteria_rfq` (`rfq_id`),
  ADD KEY `fk_rfq_criteria_criteria` (`criteria_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfq_criteria`
--
ALTER TABLE `rfq_criteria`
  ADD CONSTRAINT `fk_rfq_criteria_criteria` FOREIGN KEY (`criteria_id`) REFERENCES `selection_criteria` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rfq_criteria_rfq` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;
COMMIT;
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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rfq` (`rfq_id`),
  ADD KEY `fk_condition` (`condition_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfq_conditions`
--
ALTER TABLE `rfq_conditions`
  ADD CONSTRAINT `fk_condition` FOREIGN KEY (`condition_id`) REFERENCES `conditions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rfq` FOREIGN KEY (`rfq_id`) REFERENCES `rfqs` (`rfq_id`) ON DELETE CASCADE;
COMMIT;

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

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `rfqs`
--
ALTER TABLE `rfqs`
  MODIFY `rfq_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `rfqs`
--
ALTER TABLE `rfqs`
  ADD CONSTRAINT `rfqs_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  ADD CONSTRAINT `rfqs_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `rfqs_ibfk_3` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`),
  ADD CONSTRAINT `rfqs_ibfk_4` FOREIGN KEY (`validity_id`) REFERENCES `requirements` (`id`),
  ADD CONSTRAINT `rfqs_ibfk_5` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);
COMMIT;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `general_terms`
--
ALTER TABLE `general_terms`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `general_terms`
--
ALTER TABLE `general_terms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `conditions`
--
ALTER TABLE `conditions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `conditions`
--
ALTER TABLE `conditions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  ADD PRIMARY KEY (`id`),
  ADD KEY `requisition_id` (`requisition_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `approvalworkflow`
--
ALTER TABLE `approvalworkflow`
  ADD CONSTRAINT `approvalworkflow_ibfk_1` FOREIGN KEY (`requisition_id`) REFERENCES `requisitions` (`requisition_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `approvalworkflow_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`address_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;
