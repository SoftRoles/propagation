const {equal} = require('assert')
const {pathLoss, radioHorizon} = require('../')

// freq = 2 MHz, d = 3km
equal(pathLoss(2,3).toFixed(2),48.00, null)
// h = 1500 m
equal(radioHorizon(1500).toFixed(0),160, null)
