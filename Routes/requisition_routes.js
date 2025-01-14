import express from "express";
import requisition from '../controllers/requisition_controller.js';

const requisitionRoute = express.Router();

requisitionRoute.post('/create', requisition.createRequisition); 
requisitionRoute.get('/',requisition.getAllRequisitions);
requisitionRoute.get('/:id',requisition.getRequisitionById);
requisitionRoute.put('/update/:id',requisition.updateRequisition);
requisitionRoute.delete('/delete',requisition.deleteRequisition);
// Create a new requisition
// router.get("/", getAllRequisitions); // Fetch all requisitions
// router.get("/:id", getRequisitionById); // Fetch a single requisition by ID
// router.post("/:id/approve", updateRequisitionStatus); // Approve/Reject a requisition

export default requisitionRoute;
