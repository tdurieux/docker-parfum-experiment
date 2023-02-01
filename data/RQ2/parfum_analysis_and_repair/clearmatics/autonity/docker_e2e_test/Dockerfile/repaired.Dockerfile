FROM ubuntu:18.04
RUN apt-get update && \
  apt-get dist-upgrade --yes && \
  apt-get install --no-install-recommends --yes python3 && \
  apt-get install --no-install-recommends --yes python3-pip && \
  apt-get install --no-install-recommends --yes openssh-client && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN pip3 install --no-cache-dir -r ./requirements.txt
RUN apt-get clean
EXPOSE 22 6000 7000 8000 30303
