#!/bin/bash
set -e
set -o pipefail

echo "🚀 Starting installation of Docker, Kind, and kubectl..."

TARGET_USER="ubuntu"

# ----------------------------
# 1. Install Docker
# ----------------------------
if ! command -v docker &>/dev/null; then
  echo "📦 Installing Docker..."
  apt-get update -y
  apt-get install -y docker.io

  echo "👤 Adding ${TARGET_USER} to docker group..."
  usermod -aG docker ${TARGET_USER}

  systemctl enable docker
  systemctl start docker

  echo "✅ Docker installed."
else
  echo "✅ Docker is already installed."
fi

# ----------------------------
# 2. Install Kind
# ----------------------------
if ! command -v kind &>/dev/null; then
  echo "📦 Installing Kind..."

  ARCH=$(uname -m)
  if [ "$ARCH" = "x86_64" ]; then
    curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
  elif [ "$ARCH" = "aarch64" ]; then
    curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-arm64
  else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
  fi

  chmod +x /usr/local/bin/kind
  echo "✅ Kind installed."
else
  echo "✅ Kind is already installed."
fi

# ----------------------------
# 3. Install kubectl
# ----------------------------
if ! command -v kubectl &>/dev/null; then
  echo "📦 Installing kubectl..."

  ARCH=$(uname -m)
  VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)

  if [ "$ARCH" = "x86_64" ]; then
    curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl
  elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    curl -Lo /usr/local/bin/kubectl https://dl.k8s.io/release/${VERSION}/bin/linux/arm64/kubectl
  else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
  fi

  chmod +x /usr/local/bin/kubectl
  echo "✅ kubectl installed."
else
  echo "✅ kubectl is already installed."
fi

# ----------------------------
# 4. Versions
# ----------------------------
echo
echo "🔍 Installed Versions:"
docker --version
kind --version
kubectl version --client

echo
echo "🎉 Installation complete! Re-login required for docker group to apply."
