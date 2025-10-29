// ts-node src/sim/examples/run_moral_scan.ts
// Example runner for the moral dimensionality simulation.

import {
  type Layers,
  moralStability,
  dSdD,
  estimateDc,
  lift,
} from "../moral_dimensionality";

const layers: Layers = {
  I: { persistence: 0.55, collisionResistance: 0.6 },
  M: { immutability: 0.5, availability: 0.6 },
  T: { decentralization: 0.45, verifiability: 0.55 }, // bump to 0.9 to see Dc drop
  D: { contexts: 2, independence: 0.65 },
};

const hypocrisy = 0.25;

console.log("Lift ≈", lift(layers).toFixed(3));
console.log("S =", moralStability(layers, hypocrisy).toFixed(4));
console.log("∂S/∂D |contexts =", dSdD(layers, hypocrisy).toFixed(5));
console.log("Dc ≈", estimateDc(layers, hypocrisy));

