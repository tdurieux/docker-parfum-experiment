FROM ubuntu
MAINTAINER Rohit Sehgal (rsehgal@iitk.ac.in)

RUN apt-get update -y && apt-get install --no-install-recommends python2.7 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends python tcpdump python-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends aptitude -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/smb

COPY libs /home/smb/libs
COPY credentials_file /home/smb/credentials_file
COPY __init__.py /home/smb/__init__.py
COPY shares.conf /home/smb/shares.conf
COPY smbserver.py /home/smb/smbserver.py
COPY smb.conf /home/smb/smb.conf

COPY startup_scripts.sh /home/smb/startup_scripts.sh
RUN chmod 754 /home/smb/startup_scripts.sh

COPY requirements.txt /home/smb/requirements.txt
RUN pip install --no-cache-dir -r /home/smb/requirements.txt

EXPOSE 445 139

ENTRYPOINT ["bash"]
CMD ["-c","/home/smb/startup_scripts.sh"]
