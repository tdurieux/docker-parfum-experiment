FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt upgrade -y
RUN apt install --no-install-recommends -y python3.6 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y unoconv && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir flask_sqlalchemy
RUN pip3 install --no-cache-dir PyJWT==1.7.1
RUN pip3 install --no-cache-dir argparse
RUN pip3 install --no-cache-dir PyPDF2
RUN pip3 install --no-cache-dir reportlab
RUN mkdir app
WORKDIR /app
COPY . .
RUN mv flag /flag
CMD python3 app.py
