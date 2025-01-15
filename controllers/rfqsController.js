import db from '../Config/config.js';

const createRFQs =  async (req, res) => {
    const { supplier_id, created_by, approved_by, address_id,supplier_ids, general_term_ids, 
        condition_ids, 
        criteria_ids  } = req.body;

    if (!supplier_id || !created_by) {
        return res.status(400).json({ message: 'supplier_id and created_by are required.' });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Insert the new RFQ
        const [result] = await connection.execute(
            `INSERT INTO RFQs (supplier_id, created_by, approved_by, address_id)
             VALUES (?, ?, ?, ?)`,
            [supplier_id, created_by, approved_by || null, address_id || null]
        );

        const rfq_id = result.insertId;
        if (supplier_ids && supplier_ids.length > 0) {
            const supplierInsertPromises = supplier_ids.map(supplier_id =>
                connection.execute(
                    `INSERT INTO rfq_suppliers (rfq_id, supplier_id)
                     VALUES (?, ?)`,
                    [rfq_id, supplier_id]
                )
            );
            await Promise.all(supplierInsertPromises);
        }
        if (general_term_ids && general_term_ids.length > 0) {
            const termInsertPromises = general_term_ids.map(term_id =>
                connection.execute(
                    `INSERT INTO rfq_general_terms (rfq_id, term_id)
                     VALUES (?, ?)`,
                    [rfq_id, term_id]
                )
            );
            await Promise.all(termInsertPromises);
        }

        // 4. Link Conditions (if provided)
        if (condition_ids && condition_ids.length > 0) {
            const conditionInsertPromises = condition_ids.map(condition_id =>
                connection.execute(
                    `INSERT INTO rfq_conditions (rfq_id, condition_id)
                     VALUES (?, ?)`,
                    [rfq_id, condition_id]
                )
            );
            await Promise.all(conditionInsertPromises);
        }

        // 5. Link Criteria (if provided)
        if (criteria_ids && criteria_ids.length > 0) {
            const criteriaInsertPromises = criteria_ids.map(criteria_id =>
                connection.execute(
                    `INSERT INTO rfq_criteria (rfq_id, criteria_id)
                     VALUES (?, ?)`,
                    [rfq_id, criteria_id]
                )
            );
            await Promise.all(criteriaInsertPromises);
        }

        await connection.commit();
        res.status(201).json({
            status: 'success',
            message: 'RFQ created successfully.',
            data: { rfq_id },
        });
    } catch (error) {
        await connection.rollback();
        console.error('Error creating RFQ:', error.message);
        res.status(500).json({ message: 'Failed to create RFQ', error: error.message });
    } finally {
        connection.release();
    }
}

const shareRFQToSuppliers = async (req, res) => {
    const { rfq_id, supplier_ids } = req.body;

    // Validate input
    if (!rfq_id || !supplier_ids || supplier_ids.length === 0) {
        return res.status(400).json({
            message: 'rfq_id and supplier_ids are required.',
        });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Check if the RFQ exists and has the "Draft" status
        const [rfq] = await connection.execute(
            `SELECT * FROM RFQs WHERE rfq_id = ? AND status = 'Draft'`,
            [rfq_id]
        );

        if (rfq.length === 0) {
            return res.status(404).json({
                message: `RFQ with ID ${rfq_id} not found or is not in 'Draft' status.`,
            });
        }

        // Add suppliers to the rfq_suppliers table
        const supplierInsertPromises = supplier_ids.map((supplier_id) =>
            connection.execute(
                `INSERT INTO rfq_suppliers (rfq_id, supplier_id)
                 VALUES (?, ?)`,
                [rfq_id, supplier_id]
            )
        );
        await Promise.all(supplierInsertPromises);

        // Update the RFQ status to "Sent"
        await connection.execute(
            `UPDATE RFQs SET status = 'Sent' WHERE rfq_id = ?`,
            [rfq_id]
        );

        await connection.commit();

        res.status(200).json({
            status: 'success',
            message: `RFQ ID ${rfq_id} shared successfully with suppliers.`,
        });
    } catch (error) {
        await connection.rollback();
        console.error('Error sharing RFQ:', error.message);
        res.status(500).json({ message: 'Failed to share RFQ', error: error.message });
    } finally {
        connection.release();
    }
};

const getRFQs =  async (req, res) => {
    try {
        const [rfqs] = await db.query('SELECT * FROM RFQs');
        res.status(200).json(rfqs);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred while fetching RFQs', details: error.message });
    }
}

const rfqDetails = async (req, res) => {
    const { id } = req.params;

    try {
        const connection = await db.getConnection();

        
        const [rfq] = await connection.query('SELECT * FROM RFQs WHERE rfq_id = ?', [id]);
        if (rfq.length === 0) {
            connection.release();
            return res.status(404).json({ error: 'RFQ not found' });
        }

        
        const [items] = await connection.query('SELECT * FROM Items WHERE rfq_id = ?', [id]);

        
        const [requirements] = await connection.query('SELECT * FROM Requirements WHERE rfq_id = ?', [id]);

    
        const [suppliers] = await connection.query(
            `SELECT s.supplier_id, s.name, s.email, s.telephone
             FROM rfq_suppliers rs
             JOIN Suppliers s ON rs.supplier_id = s.supplier_id
             WHERE rs.rfq_id = ?`,
            [id]
        );
        
        const [generalTerms] = await connection.query(
            `SELECT gt.description
             FROM rfq_general_terms rgt
             JOIN general_terms gt ON rgt.term_id = gt.id
             WHERE rgt.rfq_id = ?`,
            [id]
        );

        
        const [conditions] = await connection.query(
            `SELECT c.description
             FROM rfq_conditions rc
             JOIN conditions c ON rc.condition_id = c.id
             WHERE rc.rfq_id = ?`,
            [id]    
        );

        
        const [criteria] = await connection.query(
            `SELECT sc.description
             FROM rfq_criteria rc
             JOIN selection_criteria sc ON rc.criteria_id = sc.id
             WHERE rc.rfq_id = ?`,
            [id]
        );

        connection.release();

        
        const rfqDetails = {
            ...rfq[0],
            suppliers,
            items,
            requirements,
            generalTerms,
            conditions,
            criteria,
        };

        res.status(200).json(rfqDetails);
    } catch (error) {
        console.error('Error fetching RFQ details:', error.message);
        res.status(500).json({ error: 'An error occurred while fetching RFQ details', details: error.message });
    }
};

const getRFQDetailsForSupplier = async (req, res) => {
    const { rfq_id, supplier_id } = req.params;

    if (!rfq_id || !supplier_id) {
        return res.status(400).json({ message: 'RFQ ID and Supplier ID are required.' });
    }

    try {
        const connection = await db.getConnection();

        // Fetch supplier info
        const [supplierInfo] = await connection.execute(
            `SELECT s.supplier_id, s.name, s.email, s.telephone 
             FROM suppliers AS s
             WHERE s.supplier_id = ?`,
            [supplier_id]
        );

        if (supplierInfo.length === 0) {
            return res.status(404).json({ message: 'Supplier not found.' });
        }

        const supplier = supplierInfo[0];

        // Fetch shared RFQ details
        const [rfqDetails] = await connection.execute(
            `SELECT rfq_id, created_by, status, approved_by, address_id, validity_id, created_at, updated_at, grand_total 
             FROM RFQs 
             WHERE rfq_id = ?`,
            [rfq_id]
        );

        if (rfqDetails.length === 0) {
            return res.status(404).json({ message: 'RFQ not found.' });
        }

        const rfqData = rfqDetails[0];


        const [items] = await connection.query('SELECT * FROM Items WHERE rfq_id = ?', [rfq_id]);

        
        const [requirements] = await connection.execute(
            `SELECT r.quotation_valid_from , r.quotation_valid_to , r.payment_terms , r.delivery_time_days , r.client_reference_1 ,r.client_reference_2 ,r.client_reference_3 , r.purchase_order_1 ,r.purchase_order_2 , r.purchase_order_3
             FROM requirements AS r
             JOIN rfq_requirement AS rr ON rr.id = r.id
             JOIN rfq_suppliers AS rs ON rs.rfq_id = rr.rfq_id
             WHERE rr.rfq_id = ? AND rs.supplier_id = ?`,
            [rfq_id, supplier_id]
        );

        // Fetch general terms, conditions, and criteria (shared across suppliers)
        const [generalTerms] = await connection.query(
            `SELECT gt.description
             FROM rfq_general_terms rgt
             JOIN general_terms gt ON rgt.term_id = gt.id
             WHERE rgt.rfq_id = ?`,
            [rfq_id]
        );

        const [conditions] = await connection.query(
            `SELECT c.description
             FROM rfq_conditions rc
             JOIN conditions c ON rc.condition_id = c.id
             WHERE rc.rfq_id = ?`,
            [rfq_id]    
        );

        
        const [criteria] = await connection.query(
            `SELECT sc.description
             FROM rfq_criteria rc
             JOIN selection_criteria sc ON rc.criteria_id = sc.id
             WHERE rc.rfq_id = ?`,
            [rfq_id]
        );

        // Final response
        res.status(200).json({
            rfq_id: rfqData.rfq_id,
            supplier,
            items,
            requirements,
            address_id: rfqData.address_id,
            validity_id: rfqData.validity_id,
            generalTerms,
            conditions,
            criteria
        });
    } catch (error) {
        console.error('Error fetching RFQ details:', error.message);
        res.status(500).json({ message: 'Failed to fetch RFQ details', error: error.message });
    }
};


const getSuppliersForRFQ = async (req, res) => {
    const { rfq_id } = req.params;

    if (!rfq_id) {
        return res.status(400).json({ message: 'RFQ ID is required.' });
    }

    try {
        const connection = await db.getConnection();

        // Fetch suppliers associated with the RFQ
        const [suppliers] = await connection.execute(
            `SELECT s.supplier_id, s.name, s.email, s.telephone 
             FROM suppliers AS s
             JOIN rfq_suppliers AS rs ON rs.supplier_id = s.supplier_id
             WHERE rs.rfq_id = ?`,
            [rfq_id]
        );

        if (suppliers.length === 0) {
            return res.status(404).json({ message: 'No suppliers found for this RFQ.' });
        }

        res.status(200).json({
            rfq_id,
            suppliers
        });
    } catch (error) {
        console.error('Error fetching suppliers:', error.message);
        res.status(500).json({ message: 'Failed to fetch suppliers', error: error.message });
    }
};


export default {createRFQs,getRFQs,rfqDetails,getSuppliersForRFQ,getRFQDetailsForSupplier,shareRFQToSuppliers}
