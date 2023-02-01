FROM numenta/nupic:latest
ADD . /opt/numenta/nostradamIQ
WORKDIR /opt/numenta/nostradamIQ
RUN pip install --no-cache-dir -r requirements.txt
