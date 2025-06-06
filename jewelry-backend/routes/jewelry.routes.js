import express from 'express';
import {
  createJewelry,
  getAllJewelry,
  getJewelryById,
  updateJewelry,
  deleteJewelry,
} from '../controllers/jewelry.controller.js';

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

export default router;
