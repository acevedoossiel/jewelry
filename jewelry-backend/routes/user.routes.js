// routes/user.routes.js
import { Router } from 'express';
import { registerUser } from '../controllers/user.controller.js';
import { loginUser } from '../controllers/user.controller.js';

const router = Router();

// Ruta para registrar usuario
router.post('/register', registerUser);
router.post('/login', loginUser);

export default router;
