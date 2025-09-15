// Node script: scanează folderul images/ și generează images.json + sitemap.xml
// Folosește: node tools/generate_manifest.js


const fs = require('fs');
const path = require('path');
const sizeOf = require('image-size'); // npm
