FROM cbica/captk:release-1.8.1

RUN yum install -y xz-devel && rm -rf /var/cache/yum

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir pandas synapseclient nibabel

RUN yum install python3.8 python3-pip -y && rm -rf /var/cache/yum

RUN cd /work/CaPTk/bin/ && \
    curl -f https://captk.projects.nitrc.org/Hausdorff95_linux.zip --output Hausdorff95_linux.zip && \
    unzip -o Hausdorff95_linux.zip && \
    chmod a+x Hausdorff95 && \
    rm Hausdorff95_linux.zip

COPY ./requirements.txt project/requirements.txt

RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --default-timeout=10000 --no-cache-dir -r project/requirements.txt

ENV LANG C.UTF-8

COPY . /project

WORKDIR /project

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "mlcube.py"]
