FROM amd64/golang:1.16.4-buster AS builder

# ca-certificates are required if you are going to interact with any
# HTTPS endpoints (e.g. AWS).
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates git && rm -rf /var/lib/apt/lists/*;
