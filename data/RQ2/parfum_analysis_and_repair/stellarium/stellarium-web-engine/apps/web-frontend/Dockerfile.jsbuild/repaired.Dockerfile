FROM emscripten/emsdk:1.39.17

RUN apt-get update && apt-get install --no-install-recommends -y wget build-essential apt-transport-https scons && rm -rf /var/lib/apt/lists/*;
WORKDIR /app

EXPOSE 8000
