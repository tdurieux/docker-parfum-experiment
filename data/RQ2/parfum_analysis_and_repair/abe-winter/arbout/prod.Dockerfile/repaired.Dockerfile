FROM python:3.7.6

WORKDIR /arbout

# deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# static css
COPY Makefile .
RUN mkdir static
RUN make static/bootstrap.min.css && rm *.zip

# files
COPY lib lib/
COPY static static/
COPY templates templates/
COPY app.py .

ENV AUTOMIG_CON postgres://postgres@arbout-db
ARG build_slug
ENV VERSION $build_slug
EXPOSE 8000
CMD gunicorn -w 2 -b 0.0.0.0 --access-logfile - --error-logfile - app:APP
