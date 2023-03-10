FROM node:13.12.0 as frontend-builder

WORKDIR /workspace

COPY console/frontend/ .
RUN rm -rf ./dist && rm -rf ./node_modules && rm -f ./package-lock.json
RUN npm install && npm cache clean --force;
RUN npm run build

FROM golang:1.13.6 as backend-builder

WORKDIR /workspace

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build  -o backend-server console/backend/cmd/backend-server/main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=frontend-builder /workspace/dist ./dist
COPY --from=backend-builder /workspace/backend-server ./backend-server
USER nonroot:nonroot

ENTRYPOINT ["/backend-server"]