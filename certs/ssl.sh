#!/bin/bash

ROOT_DIR=$(dirname $(realpath $0))
SSLCertificateFile=$ROOT_DIR/fullchain.pem
SSLCertificateKeyFile=$ROOT_DIR/key.pem

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSLCertificateKeyFile -out $SSLCertificateFile -subj "/C=US/ST=CA/L=San Francisco/O=IT/CN=www.example.com"

