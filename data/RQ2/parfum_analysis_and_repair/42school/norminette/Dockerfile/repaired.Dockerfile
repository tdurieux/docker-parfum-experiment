FROM python:3.7-alpine

WORKDIR /usr/src/norminette

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt \
	&& python3 setup.py install

WORKDIR /code

ENTRYPOINT ["norminette"]
