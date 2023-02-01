FROM sebastianbergmann/amiga-gcc:latest

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;