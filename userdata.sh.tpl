#!/bin/bash
set -e

# Write kind installer
cat << 'EOF' > /root/kind_install.sh
${kind_install}
EOF
chmod +x /root/kind_install.sh

# Write kind config
cat << 'EOF' > /home/ubuntu/config.yaml
${kind_config}
EOF
chown ubuntu:ubuntu /home/ubuntu/config.yaml

# Install Docker, Kind, kubectl
bash /root/kind_install.sh

# Prepare kube directory
su - ubuntu -c "mkdir -p ~/.kube"

# Create kind cluster (ensure docker group is applied)
su - ubuntu -c "sg docker -c 'kind create cluster --name multi-node-cluster --config=/home/ubuntu/config.yaml'"

# Write kubeconfig explicitly
su - ubuntu -c "sg docker -c 'kind get kubeconfig --name multi-node-cluster > ~/.kube/config'"

# Fix ownership
chown -R ubuntu:ubuntu /home/ubuntu/.kube
