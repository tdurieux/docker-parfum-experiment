# Dockerfile for apollo-portal
# Build with:
# docker build -t apollo-portal .
# Run with:
# docker run -p 8080:8080 -d -v /tmp/logs:/opt/logs --name apollo-portal apollo-portal
# Or if 8080 was taken:
# docker run -p 8070:8080 -d -v /tmp/logs:/opt/logs --name apollo-portal apollo-portal