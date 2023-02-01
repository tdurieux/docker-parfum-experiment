FROM ubuntu

# Install Stockfish.
RUN apt-get update && apt-get install --no-install-recommends -y stockfish curl && rm -rf /var/lib/apt/lists/*

# Add the annotate binary.
ADD annotate /
