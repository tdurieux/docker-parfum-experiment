FROM openlibrary/olbase:latest

ENV PYTHONPATH=/openlibrary:/openlibrary/vendor/infogami

USER root
COPY requirements*.txt ./
RUN pip install --no-cache-dir -r requirements_test.txt

WORKDIR /openlibrary/scripts/solr_builder

RUN pip install --no-cache-dir \

    cprofilev \

    Cython==3.0.0a9

# Build cython files
RUN ./build-cython.sh

EXPOSE 4000
