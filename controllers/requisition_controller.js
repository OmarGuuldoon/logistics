import db from "../Config/config.js";

const createRequisition = async (req, res) => {
    const {
        rfq_id,
        delivery_address_id,
        to_location,
        from_location,
        transport_means,
        project_code,
        activity,
        m_code,
        currency,
        created_by
    } = req.body;

    if (!rfq_id || !delivery_address_id || !created_by) {
        return res.status(400).json({
            message: "rfq_id, delivery_address_id, and created_by are required."
        });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        const [result] = await connection.execute(
            `INSERT INTO Requisitions (rfq_id, delivery_address_id, to_location, from_location, transport_means, 
                project_code, activity, m_code, currency, created_by)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                rfq_id,
                delivery_address_id,
                to_location || null,
                from_location || null,
                transport_means || 'Road',
                project_code || null,
                activity || null,
                m_code || null,
                currency || 'USD',
                created_by
            ]
        );

        const requisition_id = result.insertId;

        const [items] = await connection.execute(
            `SELECT item_id, description, qty, uom, price_per_unit 
             FROM Items 
             WHERE rfq_id = ?`,
            [rfq_id]
        );

        if (items.length === 0) {
            await connection.rollback();
            return res.status(404).json({
                message: "No items found for the specified RFQ."
            });
        }

        const itemInsertPromises = items.map(item =>
            connection.execute(
                `INSERT INTO RequisitionItems (requisition_id, item_id, qty, uom, price_per_unit) 
                 VALUES (?, ?, ?, ?, ?)`,
                [requisition_id, item.item_id, item.qty, item.uom, item.price_per_unit]
            )
        );
        await Promise.all(itemInsertPromises);

        await connection.commit();

        res.status(201).json({
            status: "success",
            message: "Requisition created successfully.",
            requisition_id,
            items
        });
    } catch (error) {
        await connection.rollback();
        console.error("Error creating requisition:", error.message);
        res.status(500).json({
            message: "Failed to create requisition",
            error: error.message
        });
    } finally {
        connection.release();
    }
};

const getAllRequisitions = async (req, res) => {
    try {
        const [requisitions] = await db.query(
            `SELECT r.*, u.name AS created_by_name 
             FROM Requisitions r 
             JOIN Users u ON r.created_by = u.user_id`
        );

        res.status(200).json(requisitions);
    } catch (error) {
        console.error("Error fetching requisitions:", error.message);
        res.status(500).json({
            message: "Failed to fetch requisitions",
            error: error.message
        });
    }
};

const getRequisitionById = async (req, res) => {
    const { id } = req.params;

    try {
        const [requisition] = await db.query(
            `SELECT r.*, u.name AS created_by_name 
             FROM Requisitions r 
             JOIN Users u ON r.created_by = u.user_id 
             WHERE r.requisition_id = ?`,
            [id]
        );

        if (requisition.length === 0) {
            return res.status(404).json({ message: "Requisition not found" });
        }

        const [items] = await db.query(
            `SELECT ri.*, i.description 
             FROM RequisitionItems ri 
             JOIN Items i ON ri.item_id = i.item_id 
             WHERE ri.requisition_id = ?`,
            [id]
        );

        res.status(200).json({ ...requisition[0], items });
    } catch (error) {
        console.error("Error fetching requisition:", error.message);
        res.status(500).json({
            message: "Failed to fetch requisition",
            error: error.message
        });
    }
};

const updateRequisition = async (req, res) => {
    const { id } = req.params;
    const { to_location, from_location, transport_means, project_code, activity, m_code, currency } = req.body;

    try {
        const [result] = await db.query(
            `UPDATE Requisitions 
             SET to_location = ?, from_location = ?, transport_means = ?, 
                 project_code = ?, activity = ?, m_code = ?, currency = ? 
             WHERE requisition_id = ?`,
            [to_location, from_location, transport_means, project_code, activity, m_code, currency, id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: "Requisition not found or no changes made" });
        }

        res.status(200).json({ message: "Requisition updated successfully" });
    } catch (error) {
        console.error("Error updating requisition:", error.message);
        res.status(500).json({
            message: "Failed to update requisition",
            error: error.message
        });
    }
};

const deleteRequisition = async (req, res) => {
    const { id } = req.params;

    try {
        const [result] = await db.query(
            `DELETE FROM Requisitions WHERE requisition_id = ?`,
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).json({ message: "Requisition not found" });
        }

        res.status(200).json({ message: "Requisition deleted successfully" });
    } catch (error) {
        console.error("Error deleting requisition:", error.message);
        res.status(500).json({
            message: "Failed to delete requisition",
            error: error.message
        });
    }
};


export default { createRequisition , updateRequisition , getAllRequisitions , getRequisitionById , deleteRequisition}