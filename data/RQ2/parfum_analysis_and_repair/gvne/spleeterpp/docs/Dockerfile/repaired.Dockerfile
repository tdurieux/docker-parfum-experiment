FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y python-dev python-pip doxygen && rm -rf /var/lib/apt/lists/*;
COPY docs/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir sphinx_rtd_theme
WORKDIR /code/docs
