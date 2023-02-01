# Use with the following command from the 'visualizers' directory: podman build -t <name> -f DockerfilePostPCP .
FROM quay.io/pbench/live-metric-visualizer:latest

ARG PCP_VERSION="5.2.5-2.fc33"
    
# ENV VARS THAT CAN BE CHANGED: REDIS_HOST, REDIS_PORT