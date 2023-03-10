FROM alpine:3.10.3 as builder

RUN apk --update --no-cache add curl unzip
RUN curl -f -L https://object-storage.tyo2.conoha.io/v1/nc_2520839e1f9641b08211a5c85243124a/sudachi/sudachi-dictionary-20191030-core.zip -o system_core.dic.zip && unzip system_core.dic.zip


FROM docker.elastic.co/elasticsearch/elasticsearch:7.4.0

RUN elasticsearch-plugin install https://github.com/WorksApplications/elasticsearch-sudachi/releases/download/v7.4.0-1.3.1/analysis-sudachi-elasticsearch7.4-1.3.1.zip
COPY --from=builder /sudachi-dictionary-20191030 /usr/share/elasticsearch/config/sudachi/
