#!/usr/bin/env node

import { generateKeyPairSync } from "node:crypto";

function generatePrivateKey() {
  const key = generateKeyPairSync("ec", {
    namedCurve: "prime256v1",
  }).privateKey.export({
    type: "sec1",
    format: "pem",
  });

  if (key instanceof Buffer) {
    return key.toString("utf-8");
  }

  return key;
}

console.log(generatePrivateKey());
