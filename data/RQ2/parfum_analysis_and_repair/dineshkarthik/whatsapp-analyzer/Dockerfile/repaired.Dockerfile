FROM python:3.6.8-slim

LABEL maintainer="Dineshkarthik Raveendran <dineshkarthik.r@gmail.com>"

# App setup
COPY . /whatsapp-analyser
WORKDIR /whatsapp-analyser
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -e .

EXPOSE 5000

CMD ["wapp-analyzer", "run"]
