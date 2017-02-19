#!/bin/bash

echo -n "Verify Secret Key (hex): "
read -s verseckey
echo

echo "VERIFY_SECRET_KEY=$verseckey" > /secrets.env
