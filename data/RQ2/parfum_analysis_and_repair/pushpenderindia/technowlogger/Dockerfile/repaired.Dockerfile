FROM ubuntu

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;

WORKDIR \

COPY . /

ENTRYPOINT ["python"]
CMD [ "./installer_linux.py" ]
