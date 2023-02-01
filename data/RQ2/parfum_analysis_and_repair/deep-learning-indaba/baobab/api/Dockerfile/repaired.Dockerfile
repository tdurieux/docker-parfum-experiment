FROM gcr.io/google-appengine/python

RUN virtualenv /env -p python3.7

# Setting these environment variables are the same as running
# source /env/bin/activate.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y software-properties-common \
    && apt-get install --no-install-recommends -y libreoffice && rm -rf /var/lib/apt/lists/*;

# Upgrade pip
RUN python -m pip install --upgrade pip

# Add the application source code.
ADD requirements.txt /code/requirements.txt
RUN pip3 install --no-cache-dir -r /code/requirements.txt

ADD . /code/
WORKDIR /code

EXPOSE 5000
