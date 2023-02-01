FROM python:3.9
RUN apt update
RUN apt upgrade -y
RUN apt install --no-install-recommends -y chromium chromium-driver locales locales-all xvfb && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm --prefix /src install puppeteer && npm cache clean --force;

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /src
ARG requirements=requirements.txt
COPY $requirements requirements.txt
RUN pip install -r requirements.txt --no-cache-dir
COPY VERSION version.txt
COPY pyproject.toml .
COPY src .

ENTRYPOINT ["./init.bash"]
