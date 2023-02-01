FROM python:3.7-slim

WORKDIR /root

COPY ./requirements.txt /root/requirements.txt

ENV PYTHONIOENCODING=utf-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential curl wget nodejs gnupg && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Install Julia using the Jill installer script to make sure we get the proper version for this platform
ENV PATH="/usr/local/bin:${PATH}"
RUN pip install --no-cache-dir jill
RUN jill install 1.5.3 --upstream Official --confirm
RUN julia -e 'import Pkg; Pkg.add("JSON");'

CMD ["tail", "-f", "/dev/null"]
