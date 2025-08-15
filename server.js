const express = require('express');
const path = require('path');
const app = express();

// Middleware pour bloquer les requêtes malveillantes
app.use((req, res, next) => {
    try {
        decodeURIComponent(req.path);
        next();
    } catch (err) {
        console.error(`🚨 Requête malveillante détectée : ${req.path}`);
        return res.status(400).send('Bad Request');
    }
});

// Servir les fichiers statiques de React (générés par npm run build)
app.use(express.static(path.join(__dirname, 'build')));

// Route pour la racine, redirige vers index.html
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

// Gestion des erreurs 404
app.use((req, res) => {
    res.status(404).send('Page non trouvée.');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});
