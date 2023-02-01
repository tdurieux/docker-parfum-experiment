FROM disconnect3d/nsjail

RUN apt-get update && apt-get install --no-install-recommends -y \
    gcc g++ && rm -rf /var/lib/apt/lists/*;

RUN mkdir /task
WORKDIR /task
ADD . /task
