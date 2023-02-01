FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install python3-dev build-essential && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace/

COPY backend/ .

RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt

COPY cli/create_and_populate_database.bash .

RUN cp backend/.env.dist backend/.env

ENTRYPOINT ["./create_and_populate_database.bash"]

CMD ["python3 manage.py runsever"]