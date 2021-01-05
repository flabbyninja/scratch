const express = require('express');
const os = require("os");
var app = express();

const listenPort = 3000;

app.get('/', (req, res) => {
  res.send("Hello there, it's " + new Date() + " and I'm running on " + os.hostname + ":" + listenPort + ".");
});

app.listen(listenPort, () => {
  console.log('App listening on ' + os.hostname + ':' + listenPort);
});