import './App.css';
import BestRest from './Components/BestRest';
import Footer from './Components/Footer';
import Navigate from './Components/Navigate';
import OffersBanner from './Components/OffersBanner';
import RestaurentChain from './Components/RestaurentChain';
import RestaurentOnline from './Components/RestaurentOnline';

function App() {
  return (
    <div>
      <Navigate/>
      <OffersBanner/>
      <RestaurentChain/>
      <RestaurentOnline/>
      <BestRest/>
      <Footer/>
    </div>
  );
}

export default App;

const express = require('express');
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

app.get('/', (req, res) => {
    res.send('Bienvenue sur mon application sécurisée.');
});

app.use((req, res) => {
    res.status(404).send('Page non trouvée.');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
});
