from ubuntu:16.04

# system level programs
run apt-get -qq update
run apt-get -qq --no-install-recommends install -y ranger && rm -rf /var/lib/apt/lists/*;
run apt-get -qq --no-install-recommends install -y tree && rm -rf /var/lib/apt/lists/*;
run apt-get -qq --no-install-recommends install -y cloc && rm -rf /var/lib/apt/lists/*;
run apt-get -qq --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;
run apt-get -qq --no-install-recommends install -y vim && rm -rf /var/lib/apt/lists/*;

# python
run apt-get -qq --no-install-recommends install -y ipython3 && rm -rf /var/lib/apt/lists/*;
run apt-get -qq --no-install-recommends install -y python3-pip && rm -rf /var/lib/apt/lists/*;

# dependencies
copy ./requirements.txt /srv/requirements.txt
workdir /srv
run pip3 install --no-cache-dir -r requirements.txt

expose 5000
