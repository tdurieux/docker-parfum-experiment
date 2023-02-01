FROM bhomnick/python-multi
ENV PYTHONUNBUFFERED 1
RUN apt-get update -yy && apt-get install --no-install-recommends -q -y pandoc && rm -rf /var/lib/apt/lists/*;
RUN mkdir /src
WORKDIR /src
COPY requirements.txt /src/
RUN bash -lc "pip3.6 install -r requirements.txt"
