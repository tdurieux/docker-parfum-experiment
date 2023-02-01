FROM python:3.6.11-slim
ARG timezone=Europe/Brussels

RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install tzdata && \
    ln -snf /usr/share/zoneinfo/$timezone /etc/localtime && \
    echo "$timezone" > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && rm -rf /var/lib/apt/lists/*;

# Change locale to UTF-8
# Install gcc to resolve issue that appears with python-slim and installation of regex
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales gcc && rm -rf /var/lib/apt/lists/*;
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

ENV TZ=$timezone

# Install all Python requirements.
COPY ./requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt

COPY ./defaults /defaults
COPY ./use_cases /use_cases
COPY ./app/ /app

COPY ./VERSION /VERSION

# Let world write to unit test files so Jenkins and other tools can run and manipulate them
RUN chmod a+w -R /app/tests/unit_tests/files

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
