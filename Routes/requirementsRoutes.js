import express from 'express';
import requirementController from '../controllers/requirementsController.js';

const controllerRoutes = express.Router();
// Define routes and map to controller

controllerRoutes.post('/', requirementController.createRequirement);
controllerRoutes.get('/',requirementController.getAllRequirements);
controllerRoutes.get('/:id',requirementController.getRequirementById);
controllerRoutes.put('/:id',requirementController.updateRequirement);
controllerRoutes.delete('/:id',requirementController.deleteRequirement);
export default controllerRoutes