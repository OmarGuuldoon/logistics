import express from 'express';
import supplierController from '../controllers/supplierController.js';

const supplierRouter = express.Router();


supplierRouter.post('/', supplierController.createSupplier);
supplierRouter.post('/submit', supplierController.submitRFQ);      
supplierRouter.get('/', supplierController.getSuppliers);         
supplierRouter.get('/:supplier_id', supplierController.getSupplier);      
supplierRouter.put('/:supplier_id', supplierController.updateSupplier);   
supplierRouter.delete('/:supplier_id', supplierController.deleteSupplier);

export default   supplierRouter;
