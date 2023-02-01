FROM python:alpine

WORKDIR /app

COPY requirements.txt .

RUN apk add --no-cache git --update
RUN git clone https://github.com/mseclab/PyJFuzz.git && cd PyJFuzz && python setup.py install
RUN rm -rf PyJFuzz
RUN cd ..
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "tntfuzzer/tntfuzzer.py"]