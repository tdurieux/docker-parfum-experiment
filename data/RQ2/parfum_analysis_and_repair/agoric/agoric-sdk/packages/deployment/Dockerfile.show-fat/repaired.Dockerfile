FROM alpine

WORKDIR /copied
COPY . .
RUN find . | sort