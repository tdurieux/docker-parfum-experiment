FROM icr.io/codeengine/golang
COPY frontend.go /
RUN go build -o /frontend /frontend.go

# Copy the exe into a smaller base image
FROM icr.io/codeengine/ubuntu
COPY --from=0 /frontend /frontend
CMD /frontend