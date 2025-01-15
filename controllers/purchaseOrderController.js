import db from '../Config/config.js';

export const createPurchaseOrder = async (req, res) => {
    const { requisition_id, required_ship_date } = req.body;

    if (!requisition_id || !required_ship_date) {
        return res.status(400).json({ message: "Requisition ID and required ship date are required." });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Step 1: Validate the requisition and check its status
        const [requisition] = await connection.execute(
            `SELECT rfq_id, status FROM Requisitions WHERE requisition_id = ?`,
            [requisition_id]
        );

        if (requisition.length === 0) {
            connection.release();
            return res.status(404).json({ message: "Requisition not found." });
        }

        const { rfq_id, status: requisitionStatus } = requisition[0];

        // Check if the requisition is approved
        if (requisitionStatus !== 'Approved') {
            connection.release();
            return res.status(400).json({
                message: "Requisition is not approved. Only approved requisitions can generate a Purchase Order."
            });
        }

        console.log("Requisition validated. RFQ ID:", rfq_id);

        // Step 2: Fetch supplier_id from the RFQs table
        const [rfq] = await connection.execute(
            `SELECT supplier_id FROM RFQs WHERE rfq_id = ?`,
            [rfq_id]
        );

        if (rfq.length === 0) {
            connection.release();
            return res.status(404).json({ message: "RFQ not found or no supplier associated." });
        }

        const { supplier_id } = rfq[0];
        console.log("Supplier ID:", supplier_id);

        // Step 3: Fetch supplier details
        const [supplier] = await connection.execute(
            `SELECT * FROM Suppliers WHERE supplier_id = ?`,
            [supplier_id]
        );

        if (supplier.length === 0) {
            connection.release();
            return res.status(404).json({ message: "Supplier not found." });
        }

        console.log("Supplier Info:", supplier[0]);

        // Step 4: Fetch items related to the requisition
        const [items] = await connection.execute(
            `SELECT * FROM RequisitionItems WHERE requisition_id = ?`,
            [requisition_id]
        );

        if (items.length === 0) {
            connection.release();
            return res.status(400).json({ message: "No items found for the specified requisition." });
        }

        console.log("Items:", items);

        // Step 5: Fetch the organization address
        const [address] = await connection.execute(`SELECT * FROM Addresses`);

        if (address.length === 0) {
            connection.release();
            return res.status(400).json({ message: "Organization address not found." });
        }

        const { address_id } = address[0];
        console.log("Address ID:", address_id);

        // Step 6: Generate a unique PO code
        const currentYear = new Date().getFullYear();
        const [poCount] = await connection.execute(`SELECT COUNT(*) AS count FROM PurchaseOrders`);
        const poNumber = poCount[0].count + 1;
        const poCode = `PO#${poNumber}/${currentYear}`;
        console.log("Generated PO Code:", poCode);

        // Step 7: Insert into PurchaseOrders table
        const [poResult] = await connection.execute(
            `INSERT INTO PurchaseOrders (requisition_id, supplier_id, address_id, po_code, required_ship_date)
             VALUES (?, ?, ?, ?, ?)`,
            [requisition_id, supplier_id, address_id, poCode, required_ship_date]
        );

        const po_id = poResult.insertId;
        console.log("PO ID:", po_id);

        // Step 8: Insert items into PurchaseOrderItems table
        const itemInsertPromises = items.map((item) =>
            connection.execute(
                `INSERT INTO PurchaseOrderItems (po_id, description, qty, uom, unit_price, total_price)
                 VALUES (?, ?, ?, ?, ?, ?)`,
                [
                    po_id,
                    item.description,
                    item.qty,
                    item.uom,
                    item.unit_price,
                    item.total_price,
                ]
            )
        );
        await Promise.all(itemInsertPromises);

        await connection.commit();
        res.status(201).json({
            message: "Purchase Order created successfully.",
            po_id,
            po_code: poCode,
        });
    } catch (error) {
        await connection.rollback();
        console.error("Error creating Purchase Order:", error.message);
        res.status(500).json({ message: "Failed to create Purchase Order", error: error.message });
    } finally {
        connection.release();
    }
};

export default { createPurchaseOrder };
