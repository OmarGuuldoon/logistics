import express from 'express';
import approvalController from '../controllers/approvalWorkflow.js';

const approvalRoutes = express.Router();
// Define routes and map to controller

approvalRoutes.post('/approve/:requisition_id', approvalController.approveRequisition);
// approvalRoutes.put('/:id',conditionController.updateCondition);

export default approvalRoutes;
