#!/bin/sh
set -e
echo "[INFO] Generating TLS certs..."
cat > /certs/openssl.cnf <<EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no
[req_distinguished_name]
CN = app
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS.1 = app
DNS.2 = localhost
EOF
openssl req -x509 -newkey rsa:2048 -nodes \
  -keyout /certs/https.key \
  -out /certs/https.crt \
  -days 365 \
  -config /certs/openssl.cnf \
  -extensions v3_req > /dev/null 2>&1
chown -R 1000:1000 /certs/
echo "[SUCCESS] TLS certs generated in /certs"
