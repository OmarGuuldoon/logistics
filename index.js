import ('dotenv/config');
import express from 'express';
import cors from 'cors';
import supplierRouter from './Routes/supplierRoutes.js';
import addressRoutes from './Routes/addresses.js';
import criteriaRoutes from './Routes/criteriaRoutes.js';
import conditionRoutes from './Routes/conditionRoutes.js';
import termsRoutes from './Routes/generalTermsRoutes.js';
import requirementRoutes  from './Routes/requirementsRoutes.js';
import rfqsRouter from './Routes/rfqs.js';
import userRouter from './Routes/userRoutes.js';
import requisitionRoute from './Routes/requisition_routes.js';
import approvalRoutes from './Routes/approvalWorkflowRoutes.js';
import purchaseRoutes from './Routes/purchaseRoutes.js';


const app = express();
app.use(cors());
app.use(express.urlencoded({extended: true}));
app.use(express.json());
app.use('/supplier',supplierRouter);
app.use('/address',addressRoutes);
app.use('/criteria',criteriaRoutes);
app.use('/conditions',conditionRoutes);
app.use('/generalTerms',termsRoutes);
app.use('/requirement',requirementRoutes);
app.use('/rfqs',rfqsRouter);
app.use('/user',userRouter);
app.use('/requisition',requisitionRoute);
app.use('/approval',approvalRoutes);
app.use('/purchase',purchaseRoutes);





export default app;