import { Router } from 'express';
import { 
  getMe, 
  updateMe, 
  uploadMyPhoto,
  getAllEmployees,
  getEmployeeById,
  createEmployee,
  updateEmployee,
  deleteEmployee,
  uploadEmployeePhoto
} from '../controllers/employeeController';
import { authenticate, requireAdmin } from '../middlewares/auth';
import { upload } from '../middlewares/upload';

const router = Router();

// Employee self-service routes
router.get('/me', authenticate, getMe);
router.put('/me', authenticate, updateMe);
router.post('/me/photo', authenticate, upload.single('photo'), uploadMyPhoto);

// Admin routes
router.use(authenticate, requireAdmin);

router.get('/', getAllEmployees);
router.get('/:id', getEmployeeById);
router.post('/', createEmployee);
router.put('/:id', updateEmployee);
router.delete('/:id', deleteEmployee);
router.post('/:id/photo', upload.single('photo'), uploadEmployeePhoto);

export default router;
