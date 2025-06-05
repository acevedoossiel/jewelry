import express from 'express';
import mongoose from 'mongoose';
import userRoutes from './routes/user.routes.js';
import cors from 'cors';

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Rutas
app.use('/api/users', userRoutes);

// Conexión a MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/jewelryApp')
    .then(() => {
        console.log('🟢 Conectado a MongoDB');
        app.listen(PORT, () => console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`));
    })
    .catch((err) => console.error('🔴 Error al conectar a MongoDB:', err));
