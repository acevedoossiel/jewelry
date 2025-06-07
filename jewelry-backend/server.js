import express from 'express';
import mongoose from 'mongoose';
import userRoutes from './routes/user.routes.js';
import jewelryRoutes from './routes/jewelry.routes.js';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

// ✅ Cargar variables de entorno
dotenv.config();

// Necesario para usar __dirname con ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// ✅ Servir archivos subidos desde la carpeta /uploads
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Rutas API
app.use('/api/users', userRoutes);
app.use('/api/jewelry', jewelryRoutes);

// Conexión a MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/jewelryApp')
  .then(() => {
    console.log('🟢 Conectado a MongoDB');

    // ✅ Escuchar en 0.0.0.0 para permitir acceso desde la red
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 Servidor corriendo en http://${process.env.HOST_IP || 'localhost'}:${PORT}`);
    });
  })
  .catch((err) => console.error('🔴 Error al conectar a MongoDB:', err));
