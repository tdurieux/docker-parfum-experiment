# This is a base Docker image used in prod/sandbox/preview Jenkinsfile
FROM artifactory.wikia-inc.com/sus/php-wikia-base:0b02db1c1f7

# disable the opcache
RUN sed -i 's/zend_extension=/;zend_extension=/g' /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

RUN apt update && apt install --no-install-recommends -q -y vim procps less git openssl make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl && rm -rf /var/lib/apt/lists/*;

ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH" \
    PYENV_ROOT="/opt/pyenv" \
    PYENV_SHELL="bash" \
    WIKIA_ENVIRONMENT="sandbox" \
    WIKIA_DATACENTER="sjc" \
    PYTHONWARNINGS="ignore:Unverified HTTPS request"
RUN git clone --single-branch --depth 1 git://github.com/yyuu/pyenv.git $PYENV_ROOT

# Install needed version, skip if already exists
RUN pyenv install 3.6.4 -s
RUN echo 'eval "$( pyenv init -)"\n' >> ~/.pyenv_profile
RUN dash ~/.pyenv_profile
RUN pyenv local 3.6.4
RUN pip install --no-cache-dir --upgrade pip

ADD app /usr/wikia/slot1/current/src
ADD config /usr/wikia/slot1/current/config
ADD rebuild /usr/wikia/slot1/current/src/rebuild

RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir -r rebuild/requirements.txt

RUN cd rebuild && dash ~/.pyenv_profile &&  pyenv local 3.6.4  &&  pytest .


RUN SERVER_ID="177" php /usr/wikia/slot1/current/src/maintenance/rebuildLocalisationCache.php --primary
WORKDIR /usr/wikia/slot1/current/src/rebuild
