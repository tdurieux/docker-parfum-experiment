FROM node:14
RUN mkdir /app
COPY . /app
WORKDIR /app
EXPOSE 4200/tcp

RUN apt-get update && apt-get install -y --no-install-recommends nano && rm -rf /var/lib/apt/lists/*;
RUN chmod +x ./entrypoint.sh
CMD /bin/bash ./entrypoint.sh