FROM alpine

RUN apk add --no-cache python3 bash git gcc g++ python3-dev libffi-dev \
	&& pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir twint

#
# Install SQLAlchemy for running any Python scripts within the container
#
RUN pip3 install --no-cache-dir sqlalchemy

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

