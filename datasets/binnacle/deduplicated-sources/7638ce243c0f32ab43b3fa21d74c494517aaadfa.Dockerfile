FROM alephdata/memorious
COPY . /opensanctions
RUN pip install -e /opensanctions
ENV MEMORIOUS_CONFIG_PATH=/opensanctions/opensanctions/config