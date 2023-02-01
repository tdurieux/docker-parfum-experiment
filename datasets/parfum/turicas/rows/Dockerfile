FROM	python:3.7
MAINTAINER	Álvaro Justen <https://github.com/turicas>

# Install system dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
                    build-essential git locales python3-dev libsnappy-dev \
                    libxml2-dev libxslt-dev libz-dev libmupdf-dev && \
    apt-get clean && \
    pip install --no-cache-dir -U pip

# Configure locale (needed to run tests)
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN echo 'pt_BR.UTF-8 UTF-8' >> /etc/locale.gen
RUN /usr/sbin/locale-gen

# Clone the repository and install Python dependencies
RUN git clone https://github.com/turicas/rows.git /rows
RUN cd /rows && \
    git checkout master && \
    pip install --no-cache-dir -r requirements-development.txt && \
    pip install --no-cache-dir -e .
