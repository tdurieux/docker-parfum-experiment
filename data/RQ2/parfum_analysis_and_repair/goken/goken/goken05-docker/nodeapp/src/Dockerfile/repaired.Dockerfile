FROM    base
RUN apt-get update && apt-get install --no-install-recommends -q -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD     . /src
EXPOSE  8080
CMD     ["node", "/src/app.js"]

