import express from 'express';
import cors from 'cors';
import path from 'path';

import authRoutes from './routes/auth';
import employeeRoutes from './routes/employee';
import { errorHandler } from './middlewares/errorHandler';

const app = express();

app.use(cors());
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/auth', authRoutes);
app.use('/api/employees', employeeRoutes);

app.use(errorHandler);

export default app;
