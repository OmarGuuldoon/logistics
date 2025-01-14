import express from 'express';
import generalTermsControllers from '../controllers/generalTermsControllers.js';

const termsRoutes = express.Router();
// Define routes and map to controller
termsRoutes.get('/', generalTermsControllers.getAllGeneralTerms);
termsRoutes.get('/:id', generalTermsControllers.getGeneralTermsById);
termsRoutes.post('/', generalTermsControllers.createGeneralTerms);
termsRoutes.put('/:id', generalTermsControllers.updateGeneralTerms);
termsRoutes.delete('/:id', generalTermsControllers.deleteGeneralTerms);

export default termsRoutes;   
