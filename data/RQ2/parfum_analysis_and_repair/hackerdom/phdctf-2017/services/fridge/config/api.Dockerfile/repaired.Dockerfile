FROM python:3.6

MAINTAINER andgein@yandex.ru

# Install application requirements
ADD ./api/requirements.txt /
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -Ur /requirements.txt

# Add code
ADD ./api /srv
RUN chmod +x /srv/server.py

# Start server
CMD ["./srv/server.py"]