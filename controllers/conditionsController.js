import db from '../Config/config.js';

const createConditionForSubmition = async (req, res) => {
    try {
    

       
        const { description} = req.body;

        
        const query = 'INSERT INTO conditions (description) VALUES (?)';
        const result = await db.execute(query, [description]);

        res.status(201).json({
            status: 'success',
            message: 'condition terms created successfully.',
            addressId: result.insertId,
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while creating the condition terms.',
        });
    }
};

const updateCondition = async (req, res) => {
    try {

        
        const { description } = req.body;
        const conditionId = req.params.id;

        
        const checkConditionQuery = 'SELECT * FROM Addresses WHERE address_id = ?';
        const condition = await db.execute(checkConditionQuery, [conditionId]);

        if (condition.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'Address not found.',
            });
        }

       
        const updateQuery = 'UPDATE conditions SET description = ? WHERE id = ?';
        await db.execute(updateQuery, [description,conditionId]);

        res.json({
            status: 'success',
            message: 'Condition updated successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while updating the condition.',
        });
    }
};

const getAllConditions = async (req, res) => {
    try {
        const query = 'SELECT * FROM conditions';
        const [results] = await db.execute(query);
        res.json(results);
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({ error: err.message });
    }
};
const getConditionById = async (req, res) => {
    try {
        const conditionId = parseInt(req.params.id, 10);

       
        if (isNaN(conditionId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid condition ID format.',
            });
        }

        const query = 'SELECT * FROM conditions WHERE id = ?';
        const result = await db.execute(query, [conditionId]);

        if (result.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'condition term not found.',
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
            message: 'An error occurred while fetching the condition terms.',
        });
    }
};

const deleteCondition = async (req, res) => {
    try {
        const conditionId = parseInt(req.params.id, 10);

        
        if (isNaN(conditionId)) {
            return res.status(400).json({
                status: 'fail',
                message: 'Invalid condition ID format.',
            });
        }

        const checkAddressQuery = 'SELECT * FROM conditions WHERE id = ?';
        const condition = await db.execute(checkAddressQuery, [conditionId]);

        if (condition.length === 0) {
            return res.status(404).json({
                status: 'fail',
                message: 'condition not found.',
            });
        }

        const deleteQuery = 'DELETE FROM conditions WHERE id = ?';
        await db.execute(deleteQuery, [conditionId]);

        res.json({
            status: 'success',
            message: 'Condition deleted successfully.',
        });
    } catch (err) {
        console.error('Database Error:', err.message);
        res.status(500).json({
            status: 'error',
            message: 'An error occurred while deleting the condition.',
        });
    }
};


export default {createConditionForSubmition,getAllConditions, getConditionById,updateCondition,deleteCondition}