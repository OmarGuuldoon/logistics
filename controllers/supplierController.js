import db from '../Config/config.js';


const createSupplier = async (req, res) => {
    const { name, email, telephone, contactPerson, address , city , state , zip } = req.body;

    try {
        // Check if the supplier already exists
        const checkEmailSql = "SELECT email FROM suppliers WHERE email = ?";
        const [existingSupplier] = await db.execute(checkEmailSql, [email]);

        if (existingSupplier.length > 0) {
            return res.status(400).json({
                message: "Supplier with this email already exists."
            });
        }

        // Insert new supplier if not already exists
        const insertSql = `INSERT INTO suppliers (name, email, telephone, contactPerson, address,city,state,zip) VALUES (?, ?, ?, ?, ?,? , ? ,?)`;
        const [result] = await db.execute(insertSql, [name, email, telephone, contactPerson, address, city, state, zip]);

        res.status(201).json({
            message: 'Supplier created successfully',
            supplierId: result.insertId
        });
    } catch (error) {
        res.status(500).json({
            message: 'Error creating supplier',
            error: error.message
        });
    }
};


const getSuppliers = async (req, res) => {
    try {
        const sql = `SELECT * FROM suppliers`;
        const [suppliers] = await db.execute(sql);
        res.status(200).json(suppliers);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching suppliers', error });
    }
};


const getSupplier = async (req, res) => {
    try {
        const sql = `SELECT * FROM suppliers WHERE supplier_id = ?`;
        const [supplier] = await db.execute(sql, [req.params.supplier_id]);
        if (supplier.length === 0) {
            return res.status(404).json({ message: 'Supplier not found' });
        }
        res.status(200).json(supplier[0]);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching supplier', error });
    }
};


const updateSupplier = async (req, res) => {
    try {
        const { name, email, telephone,contactPerson, address } = req.body;
        const sql = `UPDATE suppliers SET name = ?, email = ?, telephone = ? , contactPerson = ? , address = ? WHERE supplier_id = ?`;
        const [result] = await db.execute(sql, [name, email, telephone,contactPerson, address, req.params.supplier_id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Supplier not found' });
        }
        res.status(200).json({ message: 'Supplier updated successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error updating supplier', error });
    }
};


const deleteSupplier = async (req, res) => {
    try {
        const sql = `DELETE FROM suppliers WHERE supplier_id = ?`;
        const [result] = await db.execute(sql, [req.params.supplier_id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Supplier not found' });
        }
        res.status(200).json({ message: 'Supplier deleted successfully' });
    } catch (error) {
        res.status(500).json({ message: 'Error deleting supplier', error });
    }
};

const submitRFQ = async (req, res) => {
    const { rfq_id, requirements, items } = req.body;

    const connection = await db.getConnection(); // Get a connection for the transaction
    await connection.beginTransaction(); // Begin transaction

    try {
        // Insert Requirements
        const [result] = await connection.query(`
            INSERT INTO Requirements (rfq_id, quotation_valid_from, quotation_valid_to, payment_terms, delivery_time_days, client_reference_1, client_reference_2, client_reference_3, purchase_order_1, purchase_order_2, purchase_order_3)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [
            rfq_id,
            requirements.quotation_valid_from,
            requirements.quotation_valid_to,
            requirements.payment_terms,
            requirements.delivery_time_days,
            requirements.client_reference_1,
            requirements.client_reference_2,
            requirements.client_reference_3,
            requirements.purchase_order_1,
            requirements.purchase_order_2,
            requirements.purchase_order_3
        ]);

        const validity_id = result.insertId;

        // Update RFQ with validity_id
        await connection.query(`UPDATE RFQs SET validity_id = ? WHERE rfq_id = ?`, [validity_id, rfq_id]);

        // Insert Items
        const itemPromises = items.map(item => {
            return connection.query(`
                INSERT INTO Items (rfq_id, description, qty, uom, price_per_unit)
                VALUES (?, ?, ?, ?, ?)
            `, [rfq_id, item.description, item.qty, item.uom, item.price_per_unit]);
        });

        await Promise.all(itemPromises);

        // Recalculate Grand Total
        const [totalResult] = await connection.query(`
            SELECT SUM(qty * price_per_unit) AS grand_total FROM Items WHERE rfq_id = ?
        `, [rfq_id]);

        const grand_total = totalResult[0].grand_total || 0;

        await connection.query(`UPDATE RFQs SET grand_total = ? WHERE rfq_id = ?`, [grand_total, rfq_id]);

        await connection.commit(); // Commit transaction
        res.status(200).json({ message: 'Submission successful', validity_id, grand_total });
    } catch (error) {
        await connection.rollback(); // Rollback transaction on error
        console.error(error);
        res.status(500).json({ error: 'An error occurred during submission', details: error.message });
    } finally {
        connection.release(); // Release the connection
    }
};



export default {createSupplier , getSuppliers , getSupplier , updateSupplier , deleteSupplier ,submitRFQ }