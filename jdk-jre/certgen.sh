#!/bin/bash
set -e
echo "[INFO] Generating SSL certs and keystore..."

# Generate a self-signed certificate with SANs
openssl req -x509 -newkey rsa:2048 -keyout /certs/https.key -out /certs/https.crt -days 365 -nodes \
  -subj "/CN=localhost" \
  -addext "subjectAltName = DNS:localhost, DNS:app, DNS:testclient" > /dev/null 2>&1

# Create a PKCS12 keystore containing the certificate and key
openssl pkcs12 -export -in /certs/https.crt -inkey /certs/https.key -out /certs/keystore.p12 -name "server" -password pass:changeit
chown -R 1000:1000 /certs/
echo "[SUCCESS] SSL certs and keystore generated in /certs"
