# Written fo Ubuntu 22.04

set -e

echo "Installing development tools..."

# ===== Docker according to official documentation =====
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  sudo apt update
  sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker $USER
  echo "Docker has been successfully installed!"
else
  echo "Docker is already installed"
fi

# ===== Docker Compose according to official documentation =====
if ! command -v docker-compose >/dev/null 2>&1; then
  echo "Installing Docker Compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "Docker Compose has been successfully installed!"
else
  echo "Docker Compose is already installed"
fi

# ==== Python ====
if ! command -v python3.11 &> /dev/null; then
  echo "Installing Python 3.11..."
  sudo apt install -y software-properties-common
  sudo add-apt-repository -y ppa:deadsnakes/ppa
  sudo apt update
  sudo apt install -y python3.11
  sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
  echo "Python 3.11 has been successfully installed!"
else
  echo "Python 3.11 is already installed"
fi

# ===== pip =====
if ! command -v pip3 >/dev/null 2>&1; then
  echo "  Installing pip..."
  sudo apt install -y python3-distutils
  wget https://bootstrap.pypa.io/get-pip.py
  sudo python3.11 get-pip.py
  echo "Pip has been successfully installed!"
else
  echo "Pip is already installed"
fi

# ===== Django =====
if ! python3 -m django --version >/dev/null 2>&1; then
  echo "Installing Django..."
  pip3 install django
  echo "Django has been successfully installed!"
else
  echo "Django is already installed"
fi

echo "All the tools are installed!"