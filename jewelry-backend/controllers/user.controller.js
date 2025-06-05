import User from '../models/user.model.js';

// Crear nuevo usuario
export const registerUser = async (req, res) => {
    try {
        const { name, email, password, role } = req.body;

        // Validación básica
        if (!name || !email || !password || !role) {
            return res.status(400).json({ message: 'Todos los campos son obligatorios' });
        }

        // Verificar si el usuario ya existe
        const userExists = await User.findOne({ email });
        if (userExists) {
            return res.status(400).json({ message: 'El correo ya está registrado' });
        }

        // Crear y guardar nuevo usuario
        const newUser = new User({ name, email, password, role });
        await newUser.save();

        res.status(201).json({
            message: 'Usuario creado correctamente',
            user: newUser,
        });
    } catch (error) {
        console.error('[registerUser Error]:', error);
        res.status(500).json({ message: 'Error al crear el usuario', error });
    }
};

// Login de usuario
export const loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        // Buscar si existe el usuario con ese email
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        // Validar contraseña (simple sin encriptar por ahora)
        if (user.password !== password) {
            return res.status(401).json({ message: 'Contraseña incorrecta' });
        }

        return res.status(200).json({
            message: 'Inicio de sesión exitoso',
            user: {
                id: user._id,
                name: user.name,
                email: user.email,
                role: user.role,
            },
        });
    } catch (error) {
        console.error('[loginUser Error]:', error);
        return res.status(500).json({ message: 'Error en el servidor', error });
    }
};
