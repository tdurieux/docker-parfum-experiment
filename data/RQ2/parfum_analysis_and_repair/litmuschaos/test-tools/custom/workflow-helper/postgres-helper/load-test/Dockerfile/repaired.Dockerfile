FROM python:3

LABEL maintainer="LitmusChaos"
ADD . .
RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python3" ]
