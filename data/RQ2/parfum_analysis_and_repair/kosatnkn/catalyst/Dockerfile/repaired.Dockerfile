# Building
FROM golang:1.15-alpine AS builder

# define working directory
WORKDIR /opt/app

# copy source from current dir to working dir
COPY . .

# build
# NOTE: usage of CGO_ENABLED and installSuffix (as shown in following command) 
#       is no longer needed since go 1.10
# 
#       RUN GOOS=linux CGO_ENABLED=0 go build -a -installsuffix cgo -o app .
# 
#       Refer https://github.com/golang/go/issues/9344#issuecomment-69944514 for
#       more information.
RUN go build -o main .

# Running
FROM alpine:latest AS runner 

WORKDIR /opt/

COPY --from=builder /opt/app/main .
COPY ./configs/ ./configs/

# inform exposed ports 