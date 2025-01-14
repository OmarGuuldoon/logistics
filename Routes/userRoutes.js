import express from 'express';
import userController from '../controllers/userController.js';

const userRouter = express.Router();
// CRUD Routes for Supplier
userRouter.post('/',userController.registerUser);   

export default userRouter;