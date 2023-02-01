FROM python:2
RUN apt-get update && apt-get install --no-install-recommends -y python-pycurl python-geoip python-whois python-crypto python-requests openssl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir geoip requests pycrypto
RUN git clone https://github.com/epsylon/ufonet.git
WORKDIR /ufonet
RUN python setup.py install
EXPOSE 80 443
ENTRYPOINT ["python", "ufonet"]
CMD ["--help"]
