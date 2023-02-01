FROM icr.io/codeengine/golang:alpine
COPY backend.go /
RUN go build -o /backend /backend.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/alpine
COPY --from=0 /backend /backend
CMD /backend