import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

// Necesario para usar __dirname en ESModules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Carpeta destino
const storage = multer.diskStorage({
  destination: path.join(__dirname, '../uploads'), // crea esta carpeta si no existe
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${file.originalname}`;
    cb(null, uniqueName);
  },
});

const upload = multer({ storage });

export default upload;
