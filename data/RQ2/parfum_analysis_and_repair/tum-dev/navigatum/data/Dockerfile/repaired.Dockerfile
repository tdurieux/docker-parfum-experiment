FROM python:3.10.5-bullseye as build-stage
WORKDIR /app

ARG GIT_COMMIT_SHA
ENV GIT_COMMIT_SHA=${GIT_COMMIT_SHA}

# install requirements
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# collect data
COPY sources/ sources/
COPY external/ external/
COPY processors/ processors/
COPY *.py ./
RUN mkdir output \
    && python3 compile.py \
    && test -f "./output/search_data.json" \
    && test -f "./output/api_data.json" \
    && cp -r sources/img/* output

# put all data into the cdn folder
COPY external/maps/roomfinder output/maps/roomfinder

# Synonyms are also provided via the cdn for the server container build
COPY search_synonyms.json output/

# compress data (only using gzip, because brotli on ngnix is a royal pain)
RUN gzip --force --keep --recursive output/

FROM nginx as production-stage
RUN mkdir /cdn
COPY --from=build-stage /app/output /cdn
COPY nginx.conf /etc/nginx/nginx.conf
