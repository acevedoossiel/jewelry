import Jewelry from '../models/jewelry.model.js';

// Crear producto
export const createJewelry = async (req, res) => {
  try {
    const { name, material, mediaLinks, details, price, quantity, id } = req.body;

    // Validación básica
    if (!name || !material || !mediaLinks || !Array.isArray(mediaLinks) || mediaLinks.length === 0 || !details || !price) {
      return res.status(400).json({ message: 'Faltan campos obligatorios o formato incorrecto' });
    }

    const newJewelry = new Jewelry({
      id,
      name,
      material,
      mediaLinks,
      details,
      price,
      quantity: quantity ?? 1,
    });

    await newJewelry.save();
    res.status(201).json(newJewelry);
  } catch (error) {
    res.status(500).json({ message: 'Error al crear el producto', error });
  }
};

// Obtener todos los productos
export const getAllJewelry = async (req, res) => {
  try {
    const items = await Jewelry.find();
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener productos', error });
  }
};

// Obtener un producto por ID
export const getJewelryById = async (req, res) => {
  try {
    const item = await Jewelry.findById(req.params.id);
    if (!item) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener el producto', error });
  }
};

// Actualizar producto
export const updateJewelry = async (req, res) => {
  try {
    const updated = await Jewelry.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!updated) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    res.json(updated);
  } catch (error) {
    res.status(500).json({ message: 'Error al actualizar el producto', error });
  }
};

// Eliminar producto
export const deleteJewelry = async (req, res) => {
  try {
    const deleted = await Jewelry.findByIdAndDelete(req.params.id);
    if (!deleted) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    res.json({ message: 'Producto eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ message: 'Error al eliminar el producto', error });
  }
};
