FROM ubuntu
RUN apt-get update && apt-get -y --no-install-recommends install curl wget git cloc && rm -rf /var/lib/apt/lists/*;
COPY . /code
WORKDIR /code
RUN chmod +x ./analysis.sh
CMD ./analysis.sh
