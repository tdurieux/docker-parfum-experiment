# Development environment for FigureOne:
FROM airladon/pynode:python3.9.5-node16.10.0-npm7.24.1

# ## General ##
WORKDIR /opt/app

RUN apt-get update && \
				apt-get -y --no-install-recommends install apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; rm -rf /var/lib/apt/lists/*; apt-key add /tmp/dkey && \
	 	 add-apt-repository \
   	 "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   	 $(lsb_release -cs) \
   	 stable" && \
 		 apt-get update && \
    apt-get -y --no-install-recommends install docker-ce

# Needed for flow it seems (try removing in the future)
RUN apt-get update && apt-get install --no-install-recommends -y libatomic1 && rm -rf /var/lib/apt/lists/*;


# Install npm packages
ADD package.json .
ADD package-lock.json .

RUN npm install && npm cache clean --force;

# Update path so eslint can be run from anywhere
ENV PATH="/opt/app/node_modules/.bin:${PATH}"


ENTRYPOINT ["bash"]
