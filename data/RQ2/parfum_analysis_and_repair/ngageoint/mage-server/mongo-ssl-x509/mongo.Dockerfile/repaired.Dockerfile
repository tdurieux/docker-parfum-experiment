# This Docker file will build a MongoDB image that runs a MongoDB server with 2-way SSL and x509 authentication.
# From this directory, run 
# $ docker build -t mage-mongo:ssl -f mongo.Dockerfile .
# $ docker run -d --name mage-mongo-ssl -p 27017:27017 mage-mongo:ssl
# You can then start a local MAGE server with proper environment configuration pointing to the certificates in this directory.