# Build container
FROM debian AS build

# Setup environment
RUN mkdir -p /data
WORKDIR /data

# Build the release
COPY . .
RUN ./Hydrunfile

# Extract the release
RUN mkdir -p /out
RUN cp out/release/bofied-backend/bofied-backend.linux-$(uname -m) /out/bofied-backend

# Release container
FROM debian

# Add certificates
RUN apt update && apt install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

# Add the release
COPY --from=build /out/bofied-backend /usr/local/bin/bofied-backend

CMD /usr/local/bin/bofied-backend
