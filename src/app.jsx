// src/App.jsx
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

// Import your existing screens
import LandingPage from './pages/LandingPage'; // Assuming this exists
import WelcomeScreen from './pages/WelcomeScreen'; // Assuming this exists
import LoginScreen from './pages/LoginScreen';   // Assuming this exists

// Import the new Marketplace screens we are building
import Marketplace from './pages/Marketplace';
import Explore from './pages/Explore';
import BusinessStorefront from './pages/BusinessStorefront';
import ProductDetail from './pages/ProductDetail';

// Import Global Styles
import './styles/globals.css';

function App() {
  return (
    <Router>
      <Routes>
        {/* Existing Screens */}
        <Route path="/" element={<LandingPage />} />
        <Route path="/welcome" element={<WelcomeScreen />} />
        <Route path="/login" element={<LoginScreen />} />

        {/* New Marketplace Screens */}
        <Route path="/marketplace" element={<Marketplace />} />
        <Route path="/explore" element={<Explore />} />
        
        {/* Detail Pages (We will build these next) */}
        <Route path="/business/:id" element={<BusinessStorefront />} />
        <Route path="/product/:id" element={<ProductDetail />} />

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </Router>
  );
}

export default App;
