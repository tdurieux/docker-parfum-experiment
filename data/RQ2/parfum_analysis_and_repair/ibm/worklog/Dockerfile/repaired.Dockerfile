FROM python:3.7-alpine
MAINTAINER Max Shapiro "maxshapiro32@ibm.com"
RUN apk add --no-cache gcc g++ make libffi-dev openssl-dev
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["-m", "app.__init__"]