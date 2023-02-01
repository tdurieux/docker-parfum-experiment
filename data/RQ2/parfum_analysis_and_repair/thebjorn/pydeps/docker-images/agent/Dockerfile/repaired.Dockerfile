FROM ubuntu:20.04

# argument required by tzdata installation from software-properties-common
ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION
ARG IS_CI

RUN set -x; \
	apt update; \
	apt install --no-install-recommends -y git \
		curl \
		wget; rm -rf /var/lib/apt/lists/*; \
	if [ "${PYTHON_VERSION}" != "2.7" ]; then \
		apt install --no-install-recommends -y build-essential \
			zlib1g-dev \
			libncurses5-dev \
			libgdbm-dev \
			libnss3-dev \
			libssl-dev \
			libreadline-dev \
			libffi-dev \
			libsqlite3-dev \
			libbz2-dev; \

		case "${PYTHON_VERSION}" in \
			"3.6") \
			PYTHON_TGZ_TAG="3.6.9" \
			;; \
			"3.7") \
			PYTHON_TGZ_TAG="3.7.9" \
			;; \
			"3.8") \
			PYTHON_TGZ_TAG="3.8.12" \
			;; \
			"3.9") \
			PYTHON_TGZ_TAG="3.9.7" \
			;; \
		esac; \
		wget https://www.python.org/ftp/python/$PYTHON_TGZ_TAG/Python-$PYTHON_TGZ_TAG.tgz; \
		tar -xf Python-$PYTHON_TGZ_TAG.tgz; \
		( cd Python-$PYTHON_TGZ_TAG || exit; \
			./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations; \
			make -j 12; \
			make altinstall;) \

		rm -rf Python-$PYTHON_TGZ_TAG.tgz Python-$PYTHON_TGZ_TAG; \

		curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
		python${PYTHON_VERSION} get-pip.py; \
		rm -rf get-pip.py; \
	fi; \
	if [ "${IS_CI}" = "true" ]; then \
		apt install --no-install-recommends -y graphviz; \

		case "${PYTHON_VERSION}" in \
			"2.7" \

				apt install --no-install-recommends -y python2-minimal; \
				curl -f https://bootstrap.pypa.io/pip/2.7/get-pip.py -k --output get-pip.py; \
				python2 get-pip.py; \
			;; \
			"3.9" \

				apt install --no-install-recommends -y jq; \

				pip install --no-cache-dir flake8 \
					packaging; \
			;; \
	esac; \
	else \

		GH_CLI_VERSION=$( curl -f "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-) ; \
		wget https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_amd64.tar.gz; \
		tar xvf gh_${GH_CLI_VERSION}_linux_amd64.tar.gz; \
		cp gh_${GH_CLI_VERSION}_linux_amd64/bin/gh /usr/local/bin/; \
		rm -rf gh_${GH_CLI_VERSION}_linux_amd64 gh_${GH_CLI_VERSION}_linux_amd64.tar.gz; \

		pip install --no-cache-dir twine; \
	fi;

# Built with ❤ by [Pipeline Foundation](https://pipeline.foundation)
