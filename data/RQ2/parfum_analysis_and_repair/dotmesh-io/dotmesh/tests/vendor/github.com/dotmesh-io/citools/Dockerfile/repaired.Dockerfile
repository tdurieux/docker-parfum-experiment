FROM mirantis/kubeadm-dind-cluster:v1.10
RUN apt update && apt install --no-install-recommends -y docker-ce=18.06.0~ce~3-0~debian && rm -rf /var/lib/apt/lists/*;
