import express from 'express';
import rfqController from '../controllers/rfqsController.js';

const rfqsRouter = express.Router();
// CRUD Routes for Supplier
rfqsRouter.post('/submit',rfqController.createRFQs); 
rfqsRouter.post('/share',rfqController.shareRFQToSuppliers); 
rfqsRouter.get('/',rfqController.getRFQs);
rfqsRouter.get('/:rfq_id',rfqController.getSuppliersForRFQ);
rfqsRouter.get('/:id/details',rfqController.rfqDetails);   
rfqsRouter.get('/:rfq_id/supplier/:supplier_id',rfqController.getRFQDetailsForSupplier);   

export default rfqsRouter;