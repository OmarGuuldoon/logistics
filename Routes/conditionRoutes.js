import express from 'express';
import conditionController from '../controllers/conditionsController.js';

const controllerRoutes = express.Router();


controllerRoutes.post('/', conditionController.createConditionForSubmition);
controllerRoutes.put('/:id',conditionController.updateCondition);
controllerRoutes.get('/', conditionController.getAllConditions);
controllerRoutes.get('/:id', conditionController.getConditionById);
controllerRoutes.delete('/:id', conditionController.deleteCondition);

export default controllerRoutes;
