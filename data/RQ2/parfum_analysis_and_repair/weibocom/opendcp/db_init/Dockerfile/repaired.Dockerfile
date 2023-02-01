FROM library/mysql

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

ADD . /

CMD ["./run.sh"]
