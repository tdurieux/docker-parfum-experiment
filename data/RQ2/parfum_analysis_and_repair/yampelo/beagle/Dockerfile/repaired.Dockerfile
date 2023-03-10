FROM python:3.6.8


RUN apt-get update && apt-get install --no-install-recommends -y \
    g++ \
    gcc \
    libxslt-dev \
    libssl-dev \
    libffi-dev \
    bash \
    ncurses-dev \
    curl \
    libncurses5-dev \
    libncursesw5-dev \
    && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs \
    && npm install -g npm typescript && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/beagle/beagle/web/static

WORKDIR /opt/beagle

COPY beagle/web/static/package.json beagle/web/static/package-lock.json /opt/beagle/beagle/web/static/

WORKDIR /opt/beagle/beagle/web/static

RUN npm install && npm audit fix && npm cache clean --force;

COPY . /opt/beagle

WORKDIR /opt/beagle/beagle/web/static

RUN npm run build

WORKDIR /opt/beagle

RUN pip install --no-cache-dir ".[all]"

RUN mkdir -p /data/beagle

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "-w", "12", "--timeout", "3600", "beagle.web.wsgi:app"]
