import db from '../Config/config.js';

// const createCriteria =  async (req, res) => {
//     const { description } = req.body;
//     try {
//         const result = await db.query(
//             'INSERT INTO selection_criteria (description) VALUES (?)',
//             [description]
//         );
//         res.status(201).json({ id: result.insertId, description });
//     } catch (err) {
//         res.status(500).json({ error: 'Failed to add criterion' });
//     }
// }

const createCriteria = async (req, res) => {
    try {
        // Step 1: Validate input data
        // const { error } = addressSchema.validate(req.body);
        // if (error) {
        //     return res.status(400).json({
        //         status: 'fail',
        //         message: error.details[0].message,
        //     });
        // }

        // Step 2: Destructure and prepare data
        const {description} = req.body;

        // Step 3: Insert data into the database
        const query = 'INSERT INTO selection_criteria (description) VALUES (?)';
        const result = await db.execute(query, [description]);

        res.status(201).json({
            status: 'success',
            message: 'Criteria created successfully.',
            addressId: result.insertId,
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while creating the criteria.',
        });
    }
};

const updateCriteria = async (req, res) => {
    try {
        // // Step 1: Validate input data
        // const { error } = addressSchema.validate(req.body);
        // if (error) {
        //     return res.status(400).json({
        //         status: 'fail',
        //         message: error.details[0].message,
        //     });
        // }

        // Step 2: Destructure and prepare data
        const {description} = req.body;
        const criteriaId = req.params.id;

        // Step 3: Check if address exists
        const checkAddressQuery = 'SELECT * FROM selection_criteria WHERE id = ?';
        const [criteria] = await db.execute(checkAddressQuery, [criteriaId]);

        if (criteria.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'criteria not found.',
            });
        }

        // Step 4: Update the address
        const updateQuery = 'UPDATE selection_criteria SET  description = ? WHERE id = ?';
        await db.execute(updateQuery, [description,criteriaId]);

        res.json({
            status: 'success',
            message: 'Criteria updated successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while updating the criteria.',
            error : err
        });
    }
};
const getAllCriteria = async (req, res) => {
    try {
        const query = 'SELECT * FROM selection_criteria';
        const [results] = await db.execute(query);
        res.status(201).json({
            message : results
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({ error: err.message });
    }
};
const getCriteriaById = async (req, res) => {
    try {
        const criteriaId = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(criteriaId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid criteria ID format.',
            });
        }

        const query = 'SELECT * FROM selection_criteria WHERE id = ?';
        const result = await db.execute(query, [criteriaId]);

        if (result.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'criteria not found.',
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
            message: 'An error occurred while fetching the criteria.',
        });
    }
};

// Delete an address
const deleteCriteria = async (req, res) => {
    try {
        const criteriaId = parseInt(req.params.id, 10);

        // Validate address ID format
        if (isNaN(criteriaId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid criteria ID format.',
            });
        }

        const checkAddressQuery = 'SELECT * FROM selection_criteria WHERE id = ?';
        const criteria = await db.execute(checkAddressQuery, [criteriaId]);

        if (criteria.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'Criteria not found.',
            });
        }

        const deleteQuery = 'DELETE FROM selection_criteria WHERE id = ?';
        await db.execute(deleteQuery, [criteriaId]);

        res.json({
            status: 'success',
            message: 'Criteria deleted successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while deleting the criteria.',
        });
    }
};
export default {createCriteria,updateCriteria,getAllCriteria,getCriteriaById,deleteCriteria}