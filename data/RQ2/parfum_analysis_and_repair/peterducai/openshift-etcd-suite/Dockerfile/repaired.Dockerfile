# building container 
FROM registry.fedoraproject.org/fedora
RUN dnf install fio python-pip wget -y && dnf clean all -y
# RUN /usr/bin/python3 -m pip install --upgrade pip
# RUN pip install numpy
# RUN pip install matplotlib