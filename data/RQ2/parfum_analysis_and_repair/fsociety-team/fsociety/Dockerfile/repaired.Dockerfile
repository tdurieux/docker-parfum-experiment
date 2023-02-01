FROM python:3.11.0a7-alpine
COPY . /fsociety
WORKDIR /fsociety
RUN apk --update --no-cache add git nmap
RUN pip install --no-cache-dir -e .
CMD fsociety --info
