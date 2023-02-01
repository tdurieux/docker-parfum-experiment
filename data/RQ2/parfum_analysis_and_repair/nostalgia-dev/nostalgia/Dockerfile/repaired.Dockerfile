FROM python

RUN mkdir /nostalgia

WORKDIR /nostalgia

COPY . /nostalgia

RUN pip install --no-cache-dir -e .

CMD tail -f /dev/null
