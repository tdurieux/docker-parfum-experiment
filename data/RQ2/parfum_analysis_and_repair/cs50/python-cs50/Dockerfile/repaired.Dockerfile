FROM cs50/cli

RUN sudo apt update && sudo apt install --no-install-recommends --yes libmysqlclient-dev pgloader postgresql && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir mysqlclient psycopg2-binary

WORKDIR /mnt
