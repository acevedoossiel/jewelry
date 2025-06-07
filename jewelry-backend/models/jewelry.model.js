import mongoose from 'mongoose';

const JewelrySchema = new mongoose.Schema({
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
    type: [String],
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
  isFavorite: {
    type: Boolean,
    default: false,
  },
});

const Jewelry = mongoose.model('Jewelry', JewelrySchema);
export default Jewelry;
