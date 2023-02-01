FROM python:3.8-buster

ENV MATHICS_HOME=/usr/src/app
ENV ENTRYPOINT_COMMAND="docker run -it {MATHICS_IMAGE}"

WORKDIR $MATHICS_HOME

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

COPY requirements.txt ./
RUN apt-get update
RUN apt-get install -y --no-install-recommends -qq apt-utils && rm -rf /var/lib/apt/lists/*;
# we need libsqlite3-dev now if ubuntu doesn't come with that, we'll need
# to build our own Python
RUN apt-get install -y --no-install-recommends -qq liblapack-dev llvm-dev gfortran maria && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
COPY requirements-mathicsscript.txt ./
RUN pip install --no-cache-dir -r requirements-mathicsscript.txt

RUN pip install --no-cache-dir Mathics-Django
RUN pip install --no-cache-dir pymathics-natlang
RUN pip install --no-cache-dir pymathics-graph
RUN pip install --no-cache-dir mathicsscript
RUN python -m nltk.downloader wordnet omw
RUN python -m spacy download en

EXPOSE 8000

RUN groupadd mathics && \
    useradd -d $MATHICS_HOME -g mathics -m -s /bin/bash mathics && \
    mkdir -p $MATHICS_HOME/data && \
    chown -R mathics:mathics $MATHICS_HOME

USER mathics
COPY django-db/mathics.sqlite /usr/src/app/.local/var/mathics/mathics.sqlite

ENTRYPOINT ["/entrypoint.sh"]

CMD ["--help"]
