FROM alpine:latest

RUN apk add --no-cache curl

RUN curl -f "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&rettype=fasta&retmode=text&id=NC_045512.2" > wuhan.fasta

RUN curl -f "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&rettype=fasta&retmode=text&id=MW487270.1" > NY.fasta
