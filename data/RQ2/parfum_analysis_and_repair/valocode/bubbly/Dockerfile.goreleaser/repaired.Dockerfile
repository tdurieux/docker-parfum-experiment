# This Dockerfile is written for use with goreleaser
FROM gcr.io/distroless/base-debian10

# Copy the static executable built by goreleaser
COPY bubbly /bubbly

EXPOSE 8111

# Run as unprivileged user