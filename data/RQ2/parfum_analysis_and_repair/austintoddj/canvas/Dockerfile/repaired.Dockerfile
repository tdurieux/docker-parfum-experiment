FROM gitpod/workspace-mysql

RUN echo "composer-link() {\n    composer config repositories.local '{\"type\": \"path\", \"url\": \"'\$1'\"}' --file composer.json \n}" >> ~/.bash_profile