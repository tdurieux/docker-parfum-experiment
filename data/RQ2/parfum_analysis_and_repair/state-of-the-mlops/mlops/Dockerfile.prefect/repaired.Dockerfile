FROM hl8469/mlops-project:base-image-1.0

COPY ./prefect /prefect
COPY ./set_prefect.sh /

RUN prefect backend cloud

CMD /set_prefect.sh