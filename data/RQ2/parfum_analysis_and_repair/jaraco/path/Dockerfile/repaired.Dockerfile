from ubuntu:bionic
RUN apt update && apt install --no-install-recommends -y python python-pip git && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install tox
RUN mkdir /app
ENV LANG=C.UTF-8
WORKDIR /app
COPY . .
CMD tox
