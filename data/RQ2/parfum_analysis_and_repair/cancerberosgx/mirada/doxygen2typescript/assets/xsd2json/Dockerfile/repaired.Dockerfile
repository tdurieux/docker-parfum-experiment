# docker build assets/xsd2json -t xsd2json
# docker run --rm -u root --workdir /code -v "$PWD":/code xsd2json xsd2json assets/compound.xsd > tmp.json
FROM swipl

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y curl build-essential libssl-dev sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir tmp_test && cd tmp_test&& npm init -y && npm i xsd2json && npm cache clean --force;