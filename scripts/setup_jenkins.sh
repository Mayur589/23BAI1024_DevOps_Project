#!/bin/bash

# Script to set up Jenkins LTS on the host macOS system using Homebrew

echo "=== Jenkins LTS Installer & Configurator ==="

# Check if brew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed! Please install Homebrew first."
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "Java is not installed. Installing OpenJDK 17 via Homebrew..."
    brew install openjdk@17
    sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
fi

# Check if Jenkins is already installed
if brew list jenkins-lts &>/dev/null; then
    echo "Jenkins LTS is already installed."
else
    echo "Installing Jenkins LTS..."
    brew install jenkins-lts
fi

# Check if service is running, start if not
echo "Starting Jenkins service..."
brew services start jenkins-lts

# Wait for Jenkins to initialize and create the admin password file
echo "Waiting for Jenkins to startup and generate credentials..."
PASSWORD_FILE="/Users/mayur/.jenkins/secrets/initialAdminPassword"

for i in {1..30}; do
    if [ -f "$PASSWORD_FILE" ]; then
        break
    fi
    sleep 2
done

if [ -f "$PASSWORD_FILE" ]; then
    echo ""
    echo "=========================================================="
    echo " Jenkins is successfully running at http://localhost:8080 "
    echo "=========================================================="
    echo "Initial Admin Password:"
    cat "$PASSWORD_FILE"
    echo "=========================================================="
else
    echo "Jenkins is starting up, but password file not found yet."
    echo "You can check it later at: /Users/mayur/.jenkins/secrets/initialAdminPassword"
fi
