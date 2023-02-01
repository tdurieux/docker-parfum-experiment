FROM phusion/baseimage

RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN add-apt-repository -y ppa:builds/sphinxsearch-beta
RUN apt-get update
RUN apt-get -y --no-install-recommends install sphinxsearch && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/lib/sphinx
RUN mkdir /var/lib/sphinx/data
RUN mkdir /var/log/sphinx
RUN mkdir /var/run/sphinx
ADD indexandsearch.sh /
RUN chmod a+x indexandsearch.sh
ADD searchd.sh /
RUN chmod a+x searchd.sh
ADD lordsearchd.sh /
RUN chmod a+x lordsearchd.sh
