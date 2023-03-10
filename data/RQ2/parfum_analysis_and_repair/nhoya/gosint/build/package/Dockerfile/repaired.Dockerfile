FROM ubuntu:18.04

# Installing dependencies
RUN apt-get update && apt-get -fy upgrade 
RUN apt-get install --no-install-recommends -fy build-essential git tesseract-ocr libleptonica-dev libtesseract-dev golang-go && rm -rf /var/lib/apt/lists/*;

# Building gOSINT
RUN go get -u  github.com/Nhoya/gOSINT/cmd/gosint

ENV PATH $PATH:/root/go/bin

# Executing help
RUN gosint --help-long
