# Dockerfile including EICAR test file to demo antivirus
#  docker build -t fortinetsolutioncse/ubuntu-eicar -f EICAR.Dockerfile .
FROM ubuntu:18.04
LABEL maintainer="Nicolas Thomas <nthomas@fortinet.com>" provider="Fortinet"
#check http://2016.eicar.org/86-0-Intended-use.html