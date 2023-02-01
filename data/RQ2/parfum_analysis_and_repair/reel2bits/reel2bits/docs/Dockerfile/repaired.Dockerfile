FROM python:3.6

RUN apt-get update && apt-get install --no-install-recommends -y graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir sphinx livereload sphinx-guillotina-theme
WORKDIR /app/docs