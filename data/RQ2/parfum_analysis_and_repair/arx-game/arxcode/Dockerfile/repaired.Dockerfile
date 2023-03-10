FROM python:3.8

WORKDIR /usr/src

RUN git clone https://github.com/TehomCD/evennia.git
RUN pip install --no-cache-dir -e evennia

WORKDIR /usr/src/arx

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p server/logs
RUN mkdir -p /var/logs

ENV PATH="/usr/src/arx/bin:${PATH}"

RUN chmod +x -R /usr/src/arx/bin

CMD ["start"]
