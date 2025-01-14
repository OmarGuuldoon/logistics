import express from 'express';
import supplierController from '../controllers/supplierController.js';

const supplierRouter = express.Router();
// CRUD Routes for Supplier
supplierRouter.post('/', supplierController.createSupplier);
supplierRouter.post('/submit', supplierController.submitRFQ);      // Create
supplierRouter.get('/', supplierController.getSuppliers);         // Read All
supplierRouter.get('/:supplier_id', supplierController.getSupplier);      // Read One
supplierRouter.put('/:supplier_id', supplierController.updateSupplier);   // Update
supplierRouter.delete('/:supplier_id', supplierController.deleteSupplier);// Delete

export default   supplierRouter;
