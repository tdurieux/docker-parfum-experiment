FROM meltwaterfoundation/drone-awscli:1.18.106
ARG version

LABEL name=awsudo/awsudo
LABEL version="v${version}"
LABEL maintainer="awsudo opensource <awsudo.opensource@meltwater.com>"

RUN apk add --no-cache --update nodejs
RUN apk add --no-cache --update npm
RUN npm i -g awsudo@${version} && npm cache clean --force;

# Show banner warning when entering container interactively

RUN printf "\
******************************************************************************* \n\
* awsudo Docker image change                                                  * \n\
*                                                                             * \n\
* The package management system, and versions of the AWS CLI and node         * \n\
* available in the ':latest' Docker image of awsudo is scheduled to change in * \n\
* October 2022.                                                               * \n\
*                                                                             * \n\
* To test against the same version of node, use                               * \n\
*     awsudo/awsudo:v%s-erbium                                             * \n\
*                                                                             * \n\
* See https://github.com/meltwater/awsudo/issues/67 for details or to offer   * \n\
* feedback.                                                                   * \n\
******************************************************************************* \n\
" ${version} > /etc/motd
RUN echo 'cat /etc/motd' >> /root/.bashrc

# Wrap execution of awsudo with banner warning
ADD awsudo-banner-wrapper /usr/local/bin/awsudo

