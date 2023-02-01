FROM node:14
ARG next_version
ENV next_version=$next_version
RUN mkdir /publish
COPY . /publish
WORKDIR /publish
EXPOSE 4872/tcp

RUN apt-get update && apt-get install -y --no-install-recommends nano && rm -rf /var/lib/apt/lists/*;
RUN chmod +x ./entrypoint.sh
CMD /bin/bash ./entrypoint.sh