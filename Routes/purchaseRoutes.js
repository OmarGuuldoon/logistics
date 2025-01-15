import express from 'express';
import purchaseController from '../controllers/purchaseOrderController.js';

const purchaseRoutes = express.Router();


purchaseRoutes.post('/', purchaseController.createPurchaseOrder);
// purchaseRoutes.get('/',requirementController.getAllRequirements);

export default purchaseRoutes