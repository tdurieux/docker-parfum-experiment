#--------------------------------------------------------------------------------------------------
# This dockerfile builds the unified image for running Scalyr agent unit & smoke tests
#
# It requires the following files:
#
# smoketest
#   override_files
#     agent.json (agent config file with placeholder serverHost token)
#   smoketest.py (main smoketest python script)
# unittest
#   unittest.sh (unittest script)
#--------------------------------------------------------------------------------------------------

FROM centos

RUN yum install -y sudo gcc gcc-c++ make git patch openssl-devel zlib-devel readline-devel sqlite-devel bzip2-devel which wget && rm -rf /var/cache/yum
RUN yum install -y libffi-devel && rm -rf /var/cache/yum
RUN yum install -y ruby-devel gcc make rpm-build rubygems && rm -rf /var/cache/yum# fpm needed for building rpm
RUN yum install -y initscripts && rm -rf /var/cache/yum
# Install fpm globally
RUN gem install --no-user-install --no-ri --no-rdoc fpm
RUN yum -y install net-tools && rm -rf /var/cache/yum
RUN yum install -y epel-release && yum install -y python36 python36-pip && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir requests

RUN useradd -ms /bin/bash scalyr \
&& echo "scalyr:scalyr" | chpasswd \
&& usermod -aG wheel scalyr \
&& echo "scalyr ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install pyenv versions

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
&& echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
&& echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
&& echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

RUN source ~/.bashrc && pyenv install 3.7.3
RUN source ~/.bashrc && pyenv install 2.7.12
RUN source ~/.bashrc && pyenv install 2.6.9
RUN source ~/.bashrc && pyenv install 2.5.4
RUN source ~/.bashrc && pyenv install 2.4.1

RUN source ~/.bashrc && pyenv shell 3.7.3 && pip3 install --no-cache-dir requests
RUN source ~/.bashrc && pyenv shell 2.7.12 && pip install --no-cache-dir ujson mock
RUN source ~/.bashrc && pyenv shell 2.6.9 && pip install --no-cache-dir ujson mock

# Python 2.5 and below requires libssl.so which we need to build
# Also cannot install mock library with pip as it keeps upgrading to incompatible version
# Instead download source and build
RUN source ~/.bashrc && pyenv shell 2.5.4 \
&& pushd /tmp \
&& wget https://files.pythonhosted.org/packages/83/21/f469c9923235f8c36d5fd5334ed11e2681abad7e0032c5aba964dcaf9bbb/ssl-1.16.tar.gz \
&& tar zxvf ssl-1.16.tar.gz \
&& cd ssl-1.16 \
&& sudo ln -s /usr/lib64/libssl.so /usr/lib \
&& make && make install \
&& popd \
&& pip install --no-cache-dir ujson \
&& pushd /tmp && wget https://files.pythonhosted.org/packages/52/22/05f0fb67c51e86b485914b1da519b2df6afd36c41f81a21328bc69a2e3b1/mock-0.8.0.tar.gz \
&& tar zxf mock-0.8.0.tar.gz && cd mock-0.8.0 && python setup.py build && python setup.py install && rm ssl-1.16.tar.gz

# Install Python 2.4 packages
RUN source ~/.bashrc && pyenv shell 2.4.1 \
&& pip install --no-cache-dir --index-url=https://pypi.python.org/simple/ ujson \
&& pushd /tmp/mock-0.8.0 && python setup.py build && python setup.py install

#------------------------------------------------------
# Copy pyenv to scalyr user
#------------------------------------------------------
# RUN sudo cp ~scalyr/.bashrc /root/.bashrc
# RUN sudo ln -s ~scalyr/.pyenv /root/.pyenv
# RUN gem install --no-ri --no-rdoc fpm

USER scalyr
WORKDIR /home/scalyr

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
&& echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
&& echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
&& echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

RUN source ~/.bashrc && pyenv install 3.7.3
RUN source ~/.bashrc && pyenv install 2.7.12
RUN source ~/.bashrc && pyenv install 2.6.9
RUN source ~/.bashrc && pyenv install 2.5.4
RUN source ~/.bashrc && pyenv install 2.4.1

RUN source ~/.bashrc && pyenv shell 3.7.3 && pip3 install --no-cache-dir requests
RUN source ~/.bashrc && pyenv shell 2.7.12 && pip install --no-cache-dir ujson mock
RUN source ~/.bashrc && pyenv shell 2.6.9 && pip install --no-cache-dir ujson mock

# Python 2.5 and below requires libssl.so which we need to build
# Also cannot install mock library with pip as it keeps upgrading to incompatible version
# Instead download source and build
RUN sudo rm -rf /tmp/ssl-1.16
RUN sudo rm -rf /tmp/mock-0.8.0

# Install Python 2.5 packages AND fix mock library install locations (otherwise unittest-25 fails)
RUN source ~/.bashrc && pyenv shell 2.5.4 \
&& pushd /tmp \
&& wget https://files.pythonhosted.org/packages/83/21/f469c9923235f8c36d5fd5334ed11e2681abad7e0032c5aba964dcaf9bbb/ssl-1.16.tar.gz \
&& tar zxvf ssl-1.16.tar.gz \
&& cd ssl-1.16 \
&& sudo ln -sf /usr/lib64/libssl.so /usr/lib \
&& make && make install \
&& popd \
&& pip install --no-cache-dir ujson \
&& pushd /tmp && wget https://files.pythonhosted.org/packages/52/22/05f0fb67c51e86b485914b1da519b2df6afd36c41f81a21328bc69a2e3b1/mock-0.8.0.tar.gz \
&& tar zxf mock-0.8.0.tar.gz && cd mock-0.8.0 && python setup.py build && sudo python setup.py install --prefix=/home/scalyr/.pyenv/versions/2.5.4 \
&& sudo chown -R scalyr:scalyr /home/scalyr/.pyenv/versions/2.5.4/lib/python2.7 \
&& mv /home/scalyr/.pyenv/versions/2.5.4/lib/python2.7/site-packages/* /home/scalyr/.pyenv/versions/2.5.4/lib/python2.5/site-packages && rm ssl-1.16.tar.gz

# Install Python 2.4 packages AND fix mock library install locations (otherwise unittest-24 fails)
RUN source ~/.bashrc && pyenv shell 2.4.1 \
&& pip install --no-cache-dir --index-url=https://pypi.python.org/simple/ ujson \
&& pushd /tmp/mock-0.8.0 && sudo python setup.py build && sudo python setup.py install --prefix=/home/scalyr/.pyenv/versions/2.4.1 --prefix=/home/scalyr/.pyenv/versions/2.4.1 \
&& sudo chown -R scalyr:scalyr /home/scalyr/.pyenv/versions/2.4.1/lib/python2.7 \
&& mv /home/scalyr/.pyenv/versions/2.4.1/lib/python2.7/site-packages/* /home/scalyr/.pyenv/versions/2.4.1/lib/python2.4/site-packages

#------------------------------------------------------
# Python 2.6 and 2.7 with non-working ssl
#------------------------------------------------------
RUN source ~/.bashrc && pyenv install 2.6.6
RUN source ~/.bashrc && pyenv install 2.7.2
RUN mv /home/scalyr/.pyenv/versions/2.6.6/lib/python2.6/ssl.py /home/scalyr/.pyenv/versions/2.6.6/lib/python2.6/ssl_hide.py
RUN /bin/rm -f /home/scalyr/.pyenv/versions/2.6.6/lib/python2.6/ssl.pyc
RUN mv /home/scalyr/.pyenv/versions/2.7.2/lib/python2.7/ssl.py /home/scalyr/.pyenv/versions/2.7.2/lib/python2.7/ssl_hide.py
RUN /bin/rm -f /home/scalyr/.pyenv/versions/2.7.2/lib/python2.7/ssl.pyc

#------------------------------------------------------
# Copy and run test scripts
#------------------------------------------------------
COPY unittest smoketest /tmp/
