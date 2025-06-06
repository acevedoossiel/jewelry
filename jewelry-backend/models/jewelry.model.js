import mongoose from 'mongoose';

const JewelrySchema = new mongoose.Schema({
  id: {
    type: Number,
    required: true,
    unique: true,
  },
  name: {
    type: String,
    required: true,
    trim: true,
  },
  material: {
    type: String,
    required: true,
  },
  mediaLinks: {
    type: [String], // 👈 Ahora es un arreglo de strings
    required: true,
  },
  details: {
    type: [String],
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  quantity: {
    type: Number,
    default: 1,
  },
});

const Jewelry = mongoose.model('Jewelry', JewelrySchema);
export default Jewelry;
