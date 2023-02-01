FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y libzmq1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

ADD agent/example_learner /app/

ENV NAME Learner

CMD ["./example_learner"]

