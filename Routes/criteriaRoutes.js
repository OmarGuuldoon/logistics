import express from 'express';
import criteriaController from '../controllers/criteriaControllers.js';

const controllerRoutes = express.Router();
// Define routes and map to controller

controllerRoutes.post('/', criteriaController.createCriteria);
controllerRoutes.put('/:id', criteriaController.updateCriteria);
controllerRoutes.get('/', criteriaController.getAllCriteria);
controllerRoutes.get('/:id', criteriaController.getCriteriaById);
controllerRoutes.delete('/:id', criteriaController.deleteCriteria);

export default controllerRoutes;