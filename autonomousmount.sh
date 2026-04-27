#!/bin/bash

kubectl patch serviceaccount default -n hello-world \
  -p '{"automountServiceAccountToken": false}'
