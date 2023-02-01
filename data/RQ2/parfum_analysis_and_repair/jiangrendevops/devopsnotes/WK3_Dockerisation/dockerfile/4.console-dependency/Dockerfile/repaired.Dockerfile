FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y curl && apt-get autoclean && rm -rf /var/lib/apt/lists/*;

COPY app/main.sh .

ENTRYPOINT ["/bin/bash"]

CMD ["main.sh"]
