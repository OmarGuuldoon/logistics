import express from 'express';
import approvalController from '../controllers/approvalWorkflow.js';

const approvalRoutes = express.Router();

approvalRoutes.post('/approve/:requisition_id', approvalController.approveRequisition);


export default approvalRoutes;
