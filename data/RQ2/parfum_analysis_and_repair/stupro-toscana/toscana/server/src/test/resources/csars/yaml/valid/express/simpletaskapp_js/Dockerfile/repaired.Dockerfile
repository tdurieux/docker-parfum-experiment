FROM node:latest
WORKDIR /stajs
COPY stajs.zip /stajs/stajs.zip
COPY *.sh /stajs/
RUN apt-get update && apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN ./install_stajs.sh
EXPOSE 3000
ENTRYPOINT ./start_stajs.sh
