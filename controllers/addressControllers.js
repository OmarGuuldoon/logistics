import db from '../Config/config.js';
import addressSchema from '../validation/addressValidation.js'; // Import the validation schema

// Helper function to handle async database queries
// const queryAsync = (query, params) => {
//     return new Promise((resolve, reject) => {
//         db.query(query, params, (err, results) => {
//             if (err) {
//                 reject(err);
//             } else {
//                 resolve(results);
//             }
//         });
//     });
// };

// Create a new address
const createAddress = async (req, res) => {
    try {
        // Step 1: Validate input data
        const { error } = addressSchema.validate(req.body);
        if (error) {
            return res.status(400).json({
                status: 'fail',
                message: error.details[0].message,
            });
        }

        // Step 2: Destructure and prepare data
        const { branch_name, attention_to, designation, location_details, email, mobile } = req.body;

        // Step 3: Insert data into the database
        const query = 'INSERT INTO Addresses (branch_name, attention_to, designation, location_details, email, mobile) VALUES (?, ?, ?, ?, ?, ?)';
        const result = await db.execute(query, [branch_name, attention_to, designation, location_details, email, mobile]);

        res.status(201).json({
            status: 'success',
            message: 'Address created successfully.',
            addressId: result.insertId,
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while creating the address.',
        });
    }
};

// Update an existing address
const updateAddress = async (req, res) => {
    try {
        // Step 1: Validate input data
        const { error } = addressSchema.validate(req.body);
        if (error) {
            return res.status(400).json({
                status: 'fail',
                message: error.details[0].message,
            });
        }

        // Step 2: Destructure and prepare data
        const { branch_name, attention_to, designation, location_details, email, mobile } = req.body;
        const addressId = req.params.id;

        // Step 3: Check if address exists
        const checkAddressQuery = 'SELECT * FROM Addresses WHERE address_id = ?';
        const address = await db.execute(checkAddressQuery, [addressId]);

        if (address.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'Address not found.',
            });
        }

        // Step 4: Update the address
        const updateQuery = 'UPDATE Addresses SET branch_name = ?, attention_to = ?, designation = ?, location_details = ?, email = ?, mobile = ? WHERE address_id = ?';
        await db.execute(updateQuery, [branch_name, attention_to, designation, location_details, email, mobile, addressId]);

        res.json({
            status: 'success',
            message: 'Address updated successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while updating the address.',
        });
    }
};

// Get all addresses
const getAllAddresses = async (req, res) => {
    try {
        const query = 'SELECT * FROM Addresses';
        const [results] = await db.execute(query);
        res.json(results);
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({ error: err.message });
    }
};

// Get an address by ID
const getAddressById = async (req, res) => {
    try {
        const addressId = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(addressId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid address ID format.',
            });
        }

        const query = 'SELECT * FROM Addresses WHERE address_id = ?';
        const result = await db.execute(query, [addressId]);

        if (result.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'Address not found.',
            });
        }

        res.json({
            status: 'success',
            data: result[0],
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while fetching the address.',
        });
    }
};

// Delete an address
const deleteAddress = async (req, res) => {
    try {
        const addressId = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(addressId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid address ID format.',
            });
        }

        const checkAddressQuery = 'SELECT * FROM Addresses WHERE address_id = ?';
        const address = await db.execute(checkAddressQuery, [addressId]);

        if (address.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'Address not found.',
            });
        }

        const deleteQuery = 'DELETE * FROM Addresses WHERE address_id = ?';
        await db.execute(deleteQuery, [addressId]);

        res.json({
            status: 'success',
            message: 'Address deleted successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while deleting the address.',
        });
    }
};

export default { createAddress, updateAddress, getAllAddresses, getAddressById, deleteAddress };
