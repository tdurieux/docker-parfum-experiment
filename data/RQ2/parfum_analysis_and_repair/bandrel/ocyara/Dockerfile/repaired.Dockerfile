FROM ubuntu:16.10

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tesseract-ocr libtesseract-dev libleptonica-dev libpng-dev libjpeg-dev libtiff5-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y virtualenv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir cython
RUN wget -O requirements.txt https://raw.githubusercontent.com/bandrel/OCyara/master/requirements.txt && pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir pytest
RUN git clone https://github.com/bandrel/OCyara.git
