// moral_dimensionality.ts
// Node/TypeScript simulation of S = f(I, M, T, D) with critical-dimensionality scan.

export type IdentityLayer = {
  persistence: number;          // [0,1]
  collisionResistance: number;  // [0,1]
};

export type MemoryLayer = {
  immutability: number;         // [0,1]
  availability: number;         // [0,1]
};

export type TrustLayer = {
  decentralization: number;     // [0,1]
  verifiability: number;        // [0,1]
};

export type Dimensionality = {
  contexts: number;             // ≥ 1
  independence: number;         // [0,1]
};

export type Layers = {
  I: IdentityLayer;
  M: MemoryLayer;
  T: TrustLayer;
  D: Dimensionality;
};

function clamp01(x: number): number {
  return Math.max(0, Math.min(1, x));
}

export function lift(l: Layers): number {
  const I = 0.5 * (l.I.persistence + l.I.collisionResistance);
  const M = 0.5 * (l.M.immutability + l.M.availability);
  const T = 0.5 * (l.T.decentralization + l.T.verifiability);
  return clamp01(0.6 * I + 0.8 * M + 1.0 * T);
}

export function realD(l: Layers): number {
  return Math.max(1, l.D.contexts) * clamp01(l.D.independence);
}

export function visibleHypocrisy(l: Layers, hypocrisyRate: number): number {
  const D = realD(l);
  const L = lift(l);
  return hypocrisyRate * (1 + 0.5 * Math.log1p(D * (1 + L)));
}

export function baseEnergy(l: Layers): number {
  const D = realD(l);
  const L = lift(l);
  return 1 / (1 + D * L);
}

export function contradictionEnergy(l: Layers, hypocrisyRate: number): number {
  return baseEnergy(l) * (1 + visibleHypocrisy(l, hypocrisyRate));
}

export function moralStability(l: Layers, hypocrisyRate: number): number {
  const E = contradictionEnergy(l, hypocrisyRate);
  return 1 / (1 + E); // (0,1]
}

export function dSdD(l: Layers, hypocrisyRate: number, h = 1): number {
  const s0 = moralStability(l, hypocrisyRate);
  const l2: Layers = {
    ...l,
    D: { ...l.D, contexts: Math.max(1, l.D.contexts + h) },
  };
  const s1 = moralStability(l2, hypocrisyRate);
  return (s1 - s0) / h;
}

export function estimateDc(
  l: Layers,
  hypocrisyRate: number,
  maxContexts = 256
): number {
  let prev = Math.sign(dSdD(l, hypocrisyRate));
  for (let c = l.D.contexts + 1; c <= maxContexts; c++) {
    const l2: Layers = {
      ...l,
      D: { contexts: c, independence: l.D.independence },
    };
    const sign = Math.sign(dSdD(l2, hypocrisyRate));
    if (prev < 0 && sign > 0) return c;
    prev = sign;
  }
  return Infinity;
}

