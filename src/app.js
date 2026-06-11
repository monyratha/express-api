// src/app.js
const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.json({
    message: 'Hello DevOps'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'UP'
  });
});

app.listen(3000, () => {
  console.log('Running on port 3000');
});