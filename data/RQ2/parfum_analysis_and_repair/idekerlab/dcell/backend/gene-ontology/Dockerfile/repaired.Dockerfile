FROM continuumio/anaconda3

RUN apt-get update -y && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;


WORKDIR /app
RUN wget https://purl.obolibrary.org/obo/go.obo -O ./go.obo

# ID to GO Name map
RUN wget https://chianti.ucsd.edu/~kono/ci/data/deep-cell/goID_2_name.tab -O ./id2name.tab

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

ENTRYPOINT ["python"]
CMD ["app.py"]