import express from 'express';
import {
  createJewelry,
  getAllJewelry,
  getJewelryById,
  updateJewelry,
  deleteJewelry,
  toggleFavorite,     // ✅ nueva función
  uploadMedia         // ✅ nueva función
} from '../controllers/jewelry.controller.js';

import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

// ✅ configuración de ruta absoluta para carpeta 'uploads'
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const storage = multer.diskStorage({
  destination: path.join(__dirname, '../uploads'),
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  }
});
const upload = multer({ storage });

const router = express.Router();

// Crear nuevo producto
router.post('/', createJewelry);

// Obtener todos los productos
router.get('/', getAllJewelry);

// Obtener un producto por ID
router.get('/:id', getJewelryById);

// Actualizar producto
router.put('/:id', updateJewelry);

// Eliminar producto
router.delete('/:id', deleteJewelry);

// ✅ Alternar favorito
router.patch('/:id/favorite', toggleFavorite);

// ✅ Subir imagen
router.post('/upload', upload.single('file'), uploadMedia);

export default router;
