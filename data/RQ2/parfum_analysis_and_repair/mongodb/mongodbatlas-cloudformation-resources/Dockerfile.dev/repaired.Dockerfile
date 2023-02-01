#FROM ubuntu:20.04
FROM bitnami/minideb:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG AWS_DEFAULT_REGION
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_SESSION_TOKEN
ARG CFN_CLI_SDK
RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    make \
    curl \
    zip \
    jq \
    golang \
    python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#RUN wget --quiet https://dl.google.com/go/go1.15.3.linux-amd64.tar.gz \
#&& tar -xf go1.15.3.linux-amd64.tar.gz \
#&& mv go /usr/local && chmod +x /usr/local/go

#RUN pip install --upgrade pip
RUN curl -f -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install

RUN curl -f -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" \
    -o "aws-sam-cli.zip" && unzip "aws-sam-cli.zip" -d "sam-installation" && ./sam-installation/install

#COPY $CFN_CLI_SDK /cfn-cli-sdk
#RUN pip3 install \
# docker==4.4 \
# cfn-cli-sdk/cloudformation-cli-0.2.1.tar.gz \
# cfn-cli-sdk/cloudformation-cli-python-plugin-2.1.3.tar.gz \
# cfn-cli-sdk/cloudformation-cli-python-lib-2.1.6.tar.gz

RUN python3 -m pip install docker==4.4 six==1.15
#RUN python3 -m pip install cloudformation-cli cloudformation-cli-java-plugin cloudformation-cli-go-plugin cloudformation-cli-python-plugin cloudformation-cli-typescript-plugin
RUN pip3 install --no-cache-dir cloudformation-cli-go-plugin
RUN pip3 list | grep cloudformation-cli

RUN echo "CloudFormation CLI Version"
RUN cfn --version
#RUN pip3 install cloudformation-cli-go-plugin
#
#RUN cd cfn-cli-sdk && unzip goplugin.zip
#RUN pip3 install -e cfn-cli-sdk/Github-cloudformation-cli-go-plugin



# Install mongocli
RUN MCLI_TAG=$( curl -f -sL --header "Accept: application/json" https://github.com/mongodb/mongocli/releases/latest | jq -r '.["tag_name"]') && \
    MCLI_VERSION=$(echo $MCLI_TAG | cut -dv -f2) && \
    MCLI_DEB="mongocli_${MCLI_VERSION}_linux_x86_64.deb" && \
    curl -f -OL https://github.com/mongodb/mongocli/releases/download/${MCLI_TAG}/${MCLI_DEB} && \
    echo "About to install mongocli from: ${MCLI_DEB}" && \
    dpkg -i ${MCLI_DEB}


#ENV WORKSPACE /workspace
#RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

#RUN --mount=type=ssh,id=github git clone --single-branch --branch develop git@github.com:aws-quickstart/quickstart-mongodb-atlas.git
#RUN --mount=type=ssh,id=github git clone --single-branch --branch develop git@github.com:jasonmimick/quickstart-mongodb-atlas.git
#RUN --mount=type=ssh,id=github git clone git@github.com:aws-quickstart/quickstart-mongodb-atlas-resources.git


#RUN cd quickstart-mongodb-atlas-resources/cfn-resources && \
# go mod edit \
# --replace github.com/aws-cloudformation/cloudformation-cli-go-plugin=/cfn-cli-sdk/Github-cloudformation-cli-go-plugin

# copy the repository form the previous image
#COPY --from=intermediate /quickstart-mongodb-atlas /workspace/quickstart-mongodb-atlas
#COPY --from=intermediate /quickstart-mongodb-atlas-resources /workspace/quickstart-mongodb-atlas-resources
# ... actually use the repo :)

## Fix importpath BUG work around
#
#COPY fix-importpath.py /
#RUN chmod +x fix-importpath.py
#RUN ls /quickstart-mongodb-atlas-resources/cfn-resources/**/.rpdk-config | xargs -I {} sh -c 'echo "Fixing: $1"' -- {}
#RUN ls /quickstart-mongodb-atlas-resources/cfn-resources/**/.rpdk-config | xargs -I {} sh -c '/fix-importpath.py "$1" > "$1.fixed"' -- {}
#RUN ls /quickstart-mongodb-atlas-resources/cfn-resources/**/.rpdk-config | xargs -I {} sh -c 'mv "$1.fixed" "$1"' -- {}

#RUN ls /quickstart-mongodb-atlas-resources/cfn-resources/**/.rpdk-config | xargs -I {} sh -c 'cat "$1"' -- {}


# Pre build everything
#RUN cd /quickstart-mongodb-atlas-resources/cfn-resources/ && BUILD_ONLY=true ./cfn-submit-helper.sh
# copy the build logs over to different name to help troubleshoot deployment logs
#RUN cd /quickstart-mongodb-atlas-resources/cfn-resources/ && ls **/rpdk.log | xargs -I {} mv {} {}.build

#COPY get-setup-aws-cfn.sh /

#RUN aws configure add-model \
#    --service-model "file:///cfn-cli-sdk/c2j-output-2021-01-11/cloudformation/2010-05-15/service-2.json" \
#    --service-name uno && \
#    aws uno help | grep enable-type

VOLUME /var/run/docker.sock

EXPOSE 3001

ENTRYPOINT ["bash", "-l", "-c"] 
CMD [ "ls" ]
