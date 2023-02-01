FROM python:3.8.2

RUN apt-get update
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir "nebulo==0.0.7"

ENV DB_CONNECTION=""
ENV SCHEMA="public"
ENV JWT_IDENTIFIER=""
ENV JWT_SECRET=""

EXPOSE 80

CMD ["sh", "-c", "neb run -c $DB_CONNECTION --schema $SCHEMA --jwt-identifier \"$JWT_IDENTIFIER\" --jwt-secret \"$JWT_SECRET\" --port 80"]
