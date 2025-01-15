import express from "express";
import requisition from '../controllers/requisition_controller.js';

const requisitionRoute = express.Router();

requisitionRoute.post('/create', requisition.createRequisition); 
requisitionRoute.get('/',requisition.getAllRequisitions);
requisitionRoute.get('/:id',requisition.getRequisitionById);
requisitionRoute.put('/update/:id',requisition.updateRequisition);
requisitionRoute.delete('/delete',requisition.deleteRequisition);


export default requisitionRoute;
