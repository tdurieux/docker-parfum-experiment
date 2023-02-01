FROM python:3-stretch
COPY . /openfisca
WORKDIR /openfisca

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -e . && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD [ "/usr/local/bin/openfisca", "serve", "-b", "0.0.0.0:5000" ]
