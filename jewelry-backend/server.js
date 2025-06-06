import express from 'express';
import mongoose from 'mongoose';
import userRoutes from './routes/user.routes.js';
import jewelryRoutes from './routes/jewelry.routes.js';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

// Necesario para usar __dirname con ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// ✅ Servir archivos desde carpeta /media
app.use('/media', express.static(path.join(__dirname, 'media')));

// Rutas API
app.use('/api/users', userRoutes);
app.use('/api/jewelry', jewelryRoutes);

// Conexión a MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/jewelryApp')
  .then(() => {
    console.log('🟢 Conectado a MongoDB');
    
    // ✅ Escuchar en 0.0.0.0 para que funcione en red local
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
    });
  })
  .catch((err) => console.error('🔴 Error al conectar a MongoDB:', err));
