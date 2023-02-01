FROM ubuntu:16.04

# Copy the executable to /app
COPY cppLinuxRunnerGame.out /app/

# Set the working directory to /app
WORKDIR /app

# Expose the port the game listens to
EXPOSE 3600

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
        curl \
        libcurl3 \
        libjsoncpp1 \
        libssl1.0.0 && rm -rf /var/lib/apt/lists/*;

# Run game when the container launches
CMD ./cppLinuxRunnerGame.out