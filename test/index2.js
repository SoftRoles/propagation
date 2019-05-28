const propagation = require('../')

console.log(propagation.radiohorizon({height: 10}))
console.log(propagation.lineofsight({height: 10}))
console.log(propagation.pathloss({freq:1, dist:3}))
