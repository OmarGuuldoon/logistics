import db from '../Config/config.js';

const createRequirement = async (req, res) => {
    const { 
        quotation_valid_from, 
        quotation_valid_to, 
        payment_terms, 
        delivery_time_days, 
        client_reference_1, 
        client_reference_2, 
        client_reference_3, 
        purchase_order_1, 
        purchase_order_2, 
        purchase_order_3 
    } = req.body;

    if (
        !quotation_valid_from || !quotation_valid_to || !payment_terms || 
        !delivery_time_days || !client_reference_1 || !client_reference_2 || 
        !client_reference_3 || !purchase_order_1 || !purchase_order_2 || !purchase_order_3
    ) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const [result] = await db.execute(
            `INSERT INTO requirements 
            (quotation_valid_from, quotation_valid_to, payment_terms, delivery_time_days, 
            client_reference_1, client_reference_2, client_reference_3, 
            purchase_order_1, purchase_order_2, purchase_order_3)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                quotation_valid_from, quotation_valid_to, payment_terms, delivery_time_days,
                client_reference_1, client_reference_2, client_reference_3,
                purchase_order_1, purchase_order_2, purchase_order_3
            ]
        );
        res.status(201).json({ message: 'Requirement created successfully', requirementId: result.insertId });
    } catch (error) {
        res.status(500).json({ error: 'Failed to create requirement', message: error.message });
    }
};
const updateRequirement = async (req, res) => {
    const { id } = req.params; // ID to update
    const { 
        quotation_valid_from, 
        quotation_valid_to, 
        payment_terms, 
        delivery_time_days, 
        client_reference_1, 
        client_reference_2, 
        client_reference_3, 
        purchase_order_1, 
        purchase_order_2, 
        purchase_order_3 
    } = req.body;

    if (
        !quotation_valid_from || !quotation_valid_to || !payment_terms || 
        !delivery_time_days || !client_reference_1 || !client_reference_2 || 
        !client_reference_3 || !purchase_order_1 || !purchase_order_2 || !purchase_order_3
    ) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        const [result] = await db.execute(
            `UPDATE requirements SET 
            quotation_valid_from = ?, 
            quotation_valid_to = ?, 
            payment_terms = ?, 
            delivery_time_days = ?, 
            client_reference_1 = ?, 
            client_reference_2 = ?, 
            client_reference_3 = ?, 
            purchase_order_1 = ?, 
            purchase_order_2 = ?, 
            purchase_order_3 = ? 
            WHERE id = ?`,
            [
                quotation_valid_from, quotation_valid_to, payment_terms, delivery_time_days,
                client_reference_1, client_reference_2, client_reference_3,
                purchase_order_1, purchase_order_2, purchase_order_3, id
            ]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Requirement not found' });
        }

        res.status(200).json({ message: 'Requirement updated successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to update requirement', message: error.message });
    }
};

const getAllRequirements = async (req, res) => {
    try {
        const [rows] = await db.execute(`SELECT * FROM requirements`);

        res.status(200).json({ data: rows });
    } catch (error) {
        res.status(500).json({ error: 'Failed to retrieve requirements', message: error.message });
    }
};


const getRequirementById = async (req, res) => {
    const { id } = req.params;

    try {
        const [rows] = await db.execute(`SELECT * FROM requirements WHERE id = ?`, [id]);

        if (rows.length === 0) {
            return res.status(404).json({ error: 'Requirement not found' });
        }

        res.status(200).json({ data: rows[0] });
    } catch (error) {
        res.status(500).json({ error: 'Failed to retrieve requirement', message: error.message });
    }
};

const deleteRequirement = async (req, res) => {
    const { id } = req.params;

    try {
        const [result] = await db.execute(`DELETE FROM requirements WHERE id = ?`, [id]);

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Requirement not found' });
        }

        res.status(200).json({ message: 'Requirement deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Failed to delete requirement', message: error.message });
    }
};




export default {createRequirement,updateRequirement ,getAllRequirements, getRequirementById,deleteRequirement}
