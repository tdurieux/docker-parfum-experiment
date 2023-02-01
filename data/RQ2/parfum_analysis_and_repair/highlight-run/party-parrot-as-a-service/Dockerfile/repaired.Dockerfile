FROM jjanzic/docker-python3-opencv:latest

COPY backend /app
WORKDIR /app

ARG SUPABASE_KEY
ARG SUPABASE_URL
ARG PORT=5000

#jpeg support
RUN apt-get update
RUN apt-get install --no-install-recommends libsm6 libxext6 libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libjpeg-dev -y && rm -rf /var/lib/apt/lists/*;
#tiff support
RUN apt-get install --no-install-recommends libtiff-dev -y && rm -rf /var/lib/apt/lists/*;
#freetype support
RUN apt-get install --no-install-recommends libfreetype6-dev -y && rm -rf /var/lib/apt/lists/*;
#openjpeg200support (needed to compile from source)
RUN wget https://downloads.sourceforge.net/project/openjpeg.mirror/2.0.1/openjpeg-2.0.1.tar.gz
RUN tar xzvf openjpeg-2.0.1.tar.gz && rm openjpeg-2.0.1.tar.gz
RUN cd openjpeg-2.0.1/
RUN apt-get install -y --no-install-recommends cmake && rm -rf /var/lib/apt/lists/*;
RUN cmake openjpeg-2.0.1
RUN make install
RUN apt-get install --no-install-recommends libsm6 libxext6 libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

# RUN pip3 install pipenv
# RUN pipenv sync
RUN pip install --no-cache-dir Pillow
RUN pip install --no-cache-dir autocrop
RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir python-dotenv
RUN pip install --no-cache-dir supabase
RUN pip install --no-cache-dir flask-cors
RUN pip install --no-cache-dir requests_toolbelt
RUN pip install --no-cache-dir validators

EXPOSE ${PORT}

CMD ["python3", "main.py"]
