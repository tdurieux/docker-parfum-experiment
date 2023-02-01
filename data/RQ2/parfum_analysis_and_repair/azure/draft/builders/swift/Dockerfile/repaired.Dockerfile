FROM swift:5.5

WORKDIR /src
COPY . /src
RUN apt-get update && apt-get install --no-install-recommends -y sudo openssl libssl-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN swift build -c release

ENV PORT {{PORT}}
EXPOSE {{PORT}}

CMD ["swift", "run"]
