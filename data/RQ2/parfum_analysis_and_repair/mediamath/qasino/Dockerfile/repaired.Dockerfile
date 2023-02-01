FROM debian
MAINTAINER Felix Sun <fsun@mediamath.com>
RUN echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y \
git \
python-apsw \
python-jinja2 \
python-requests \
python-twisted \
python-txzmq \
python-yaml && rm -rf /var/lib/apt/lists/*;
ADD ./ opt/qasino
EXPOSE 15596 15597 15598
