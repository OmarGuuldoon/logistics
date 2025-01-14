import db from '../Config/config.js';

const createGeneralTerms = async (req, res) => {
    try {
    

        // Step 2: Destructure and prepare data
        const { description} = req.body;

        // Step 3: Insert data into the database
        const query = 'INSERT INTO general_terms (description) VALUES (?)';
        const result = await db.execute(query, [description]);

        res.status(201).json({
            status: 'success',
            message: 'General Terms terms created successfully.',
            addressId: result.insertId,
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while creating the general terms.',
        });
    }
};

const updateGeneralTerms = async (req, res) => {
    try {

        // Step 2: Destructure and prepare data
        const { description } = req.body;
        const id = req.params.id;

        // Step 3: Check if address exists
        const checkGeneralTermsQuery = 'SELECT * FROM general_terms WHERE id = ?';
        const generalTerms = await db.execute(checkGeneralTermsQuery, [id]);

        if (generalTerms.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'General Terms not found.',
            });
        }

        // Step 4: Update the address
        const updateQuery = 'UPDATE general_terms SET description = ? WHERE id = ?';
        await db.execute(updateQuery, [description,id]);

        res.json({
            status: 'success',
            message: 'General Terms updated successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while updating the general terms.',
        });
    }
};

const getAllGeneralTerms = async (req, res) => {
    try {
        const query = 'SELECT * FROM general_terms';
        const [results] = await db.execute(query);
        res.json(results);
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({ error: err.message });
    }
};
const getGeneralTermsById = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(id)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid General Terms ID format.',
            });
        }

        const query = 'SELECT * FROM general_terms WHERE id = ?';
        const result = await db.execute(query, [id]);

        if (result.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'general term not found.',
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
            message: 'An error occurred while fetching the general terms.',
        });
    }
};

const deleteGeneralTerms = async (req, res) => {
    try {
        const id = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(id)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid General Term ID format.',
            });
        }

        const checkGeneralTermQuery = 'SELECT * FROM general_terms WHERE id = ?';
        const generalTerm = await db.execute(checkGeneralTermQuery, [id]);

        if (generalTerm.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'General Term not found.',
            });
        }

        const deleteQuery = 'DELETE FROM general_terms WHERE id = ?';
        await db.execute(deleteQuery, [id]);

        res.json({
            status: 'success',
            message: 'General Terms deleted successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while deleting the general terms.',
        });
    }
};


export default {createGeneralTerms,updateGeneralTerms,deleteGeneralTerms,getAllGeneralTerms,getGeneralTermsById}