FROM argocd-test-tools:latest as base

RUN ./install.sh codegen-tools
RUN ./install.sh codegen-go-tools
RUN ./install.sh lint-tools

RUN mkdir -p /home/user && chmod 777 /home/user

RUN git config --system user.name "ArgoCD Test User"
RUN git config --system user.email "noreply@example.com"

RUN mkdir -p /go/pkg && chmod 777 /go/pkg

RUN mkdir -p /home/user/.cache && chmod 777 /home/user/.cache

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*