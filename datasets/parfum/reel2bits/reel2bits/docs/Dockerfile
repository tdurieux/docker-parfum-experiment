FROM python:3.6

RUN apt-get update && apt-get install -y graphviz
RUN pip install sphinx livereload sphinx-guillotina-theme
WORKDIR /app/docs