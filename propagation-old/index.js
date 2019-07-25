module.exports = {
  radiohorizon: function(args) {
    return 4.12 * Math.sqrt(args.height);
  },
  lineofsight: function(args) {
    return 3.57 * Math.sqrt(args.height);
  },
  pathloss: function(args) {
    return 32.44 + 20 * Math.log10(args.freq * args.dist);
  }
}
