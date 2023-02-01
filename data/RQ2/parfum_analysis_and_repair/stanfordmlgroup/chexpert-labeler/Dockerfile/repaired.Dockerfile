FROM continuumio/miniconda

RUN apt-get update --allow-releaseinfo-change && apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /usr/share/man/man1


WORKDIR /app/chexpert-labeler

RUN git clone https://github.com/ncbi-nlp/NegBio.git
ENV PYTHONPATH=NegBio:$PYTHONPATH

COPY environment.yml environment.yml
RUN conda env create -f environment.yml

# Copy chexpert-labeler (see .dockerignore)
COPY . .
RUN chmod +x ./entrypoint.sh

RUN ./entrypoint.sh python -m nltk.downloader universal_tagset punkt wordnet
RUN ./entrypoint.sh python -c "from bllipparser import RerankingParser; RerankingParser.fetch_and_load('GENIA+PubMed')"

ENTRYPOINT ["./entrypoint.sh"]
