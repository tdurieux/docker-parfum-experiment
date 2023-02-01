FROM nginx


# Download ontology files from remote server
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

COPY ./static /usr/share/nginx/html
COPY ./dc.conf /etc/nginx/conf.d/default.conf

RUN mkdir /usr/share/nginx/html/data
WORKDIR /usr/share/nginx/html/data

RUN wget https://chianti.ucsd.edu/~kono/ci/data/deep-cell/tree/tree-go-genes.json
RUN wget https://chianti.ucsd.edu/~kono/ci/data/deep-cell/tree/tree-clixo.json
