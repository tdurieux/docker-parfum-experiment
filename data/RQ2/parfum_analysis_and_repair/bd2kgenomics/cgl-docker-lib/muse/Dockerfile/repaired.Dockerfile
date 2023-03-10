FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y python wget samtools tabix python-pip python-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pysam

RUN mkdir /opt/bin
RUN wget -O /opt/bin/MuSEv1.0rc https://bioinformatics.mdanderson.org/Software/MuSE/MuSEv1.0rc_submission_c039ffa
RUN chmod +x /opt/bin/MuSE*
ADD ./muse.py /opt/bin/

# Set WORKDIR to /data -- predefined mount location.
RUN mkdir /data
WORKDIR /data

ENV PATH /usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/bin

# And clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["python", "/opt/bin/muse.py"]
