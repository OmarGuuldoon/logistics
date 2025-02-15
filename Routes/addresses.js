import express from 'express';
import addressController from '../controllers/addressControllers.js';

const addressRoutes = express.Router();

addressRoutes.get('/', addressController.getAllAddresses);
addressRoutes.get('/:id', addressController.getAddressById);
addressRoutes.post('/', addressController.createAddress);
addressRoutes.put('/:id', addressController.updateAddress);
addressRoutes.delete('/:id', addressController.deleteAddress);

export default addressRoutes;   
