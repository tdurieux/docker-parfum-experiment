FROM python:2.7

WORKDIR /opt/app
RUN apt-get update && apt-get install --no-install-recommends -y avahi-discover libavahi-compat-libdnssd-dev net-tools && rm -rf /var/lib/apt/lists/*;
COPY source .

# comment these two lines out if not working (packages are in distro/packages folder, unzip them in the source folder)
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -e git+https://github.com/Eichhoernchen/pybonjour.git#egg=pybonjour

EXPOSE 2080
CMD ./ibrewui