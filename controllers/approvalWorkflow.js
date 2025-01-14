import db from '../Config/config.js';

const approveRequisition = async (req, res) => {
    const { requisition_id } = req.params;
    const { user_id, status, remarks } = req.body;

    // Validate input
    if (!status || !['Approved', 'Rejected'].includes(status)) {
        return res.status(400).json({ message: "Invalid status. Must be 'Approved' or 'Rejected'." });
    }

    if (!user_id || !requisition_id) {
        return res.status(400).json({ message: "Missing required parameters: user_id or requisition_id." });
    }

    const connection = await db.getConnection();
    await connection.beginTransaction();

    try {
        // Fetch the current requisition
        const [requisition] = await connection.execute(
            `SELECT * FROM Requisitions WHERE requisition_id = ?`,
            [requisition_id]
        );

        if (!requisition || requisition.length === 0) {
            connection.release();
            return res.status(404).json({ message: "Requisition not found." });
        }

        const { current_state, status: requisitionStatus } = requisition[0];

        if (!current_state) {
            connection.release();
            return res.status(400).json({ message: "Requisition current state is not defined." });
        }

        if (requisitionStatus === 'Rejected') {
            connection.release();
            return res.status(400).json({ message: "Requisition has already been rejected." });
        }

        if (requisitionStatus === 'Approved') {
            connection.release();
            return res.status(400).json({ message: "Requisition has already been fully approved." });
        }

        // Fetch the user's approval stage
        const [user] = await connection.execute(
            `SELECT approval_stage FROM Users WHERE user_id = ?`,
            [user_id]
        );

        if (!user || user.length === 0) {
            connection.release();
            return res.status(404).json({ message: "User not found." });
        }

        const { approval_stage } = user[0];

        // Ensure the user is authorized for the current state
        if (approval_stage !== current_state) {
            connection.release();
            return res.status(403).json({
                message: `You are not authorized to approve at this stage (${current_state}).`,
            });
        }

        // Check if the user has already approved or rejected
        const [approvalStatus] = await connection.execute(
            `SELECT status FROM ApprovalWorkflow 
             WHERE requisition_id = ? AND role = ?`,
            [requisition_id, current_state]
        );

        if (approvalStatus.length > 0 && approvalStatus[0].status === 'Approved') {
            connection.release();
            return res.status(400).json({
                message: `You have already approved this requisition.`,
            });
        }

        if (approvalStatus.length > 0 && approvalStatus[0].status === 'Rejected') {
            connection.release();
            return res.status(400).json({
                message: `You have already rejected this requisition.`,
            });
        }

        // Update ApprovalWorkflow Table
        await connection.execute(
            `UPDATE ApprovalWorkflow 
             SET status = ?, remarks = ?, approved_at = NOW() 
             WHERE requisition_id = ? AND role = ?`,
            [status, remarks || null, requisition_id, current_state]
        );

        if (status === 'Rejected') {
            // If rejected, update requisition status and end workflow
            await connection.execute(
                `UPDATE Requisitions 
                 SET status = 'Rejected' 
                 WHERE requisition_id = ?`,
                [requisition_id]
            );

            await connection.commit();
            connection.release();

            return res.status(200).json({ message: "Requisition rejected successfully." });
        }

        // Determine the next state in the approval workflow
        const nextState = getNextState(current_state);

        if (nextState) {
            await connection.execute(
                `UPDATE Requisitions 
                 SET current_state = ?, status = 'Pending' 
                 WHERE requisition_id = ?`,
                [nextState, requisition_id]
            );
        } else {
            // If no next state, mark the requisition as fully approved
            await connection.execute(
                `UPDATE Requisitions 
                 SET status = 'Approved', current_state = 'Approved' 
                 WHERE requisition_id = ?`,
                [requisition_id]
            );
        }

        await connection.commit();
        res.status(200).json({ message: "Requisition approved successfully." });
    } catch (error) {
        await connection.rollback();
        console.error("Error in approval workflow:", error.message);
        res.status(500).json({ message: "Failed to process approval.", error: error.message });
    } finally {
        connection.release();
    }
};

// Helper Function: Get Next State
const getNextState = (currentState) => {
    const states = [
        "Requester",
        "Project Manager",
        "Finance Officer",
        "Logistics Officer",
        "Global Fleet",
    ];
    const currentIndex = states.indexOf(currentState);

    if (currentIndex === -1) {
        console.error(`Invalid currentState: ${currentState}`);
        return null;
    }

    return currentIndex < states.length - 1 ? states[currentIndex + 1] : 'Approved';
};

export default { approveRequisition };
