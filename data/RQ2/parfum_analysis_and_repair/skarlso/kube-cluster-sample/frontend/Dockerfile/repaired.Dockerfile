FROM alpine
LABEL Author="Gergely Brautigam"
RUN apk add --no-cache -u ca-certificates
ARG port=8081
COPY ./build/linux/amd64/frontend /app/
COPY ./index.html /app/

EXPOSE ${port}
WORKDIR /app/
ENTRYPOINT [ "/app/frontend" ]
