#!/bin/bash
# Install tools needed to write, compile, and run C packet analysis

echo "🔧 Installing required packages..."
sudo apt update
sudo apt install -y gcc libpcap-dev tcpdump

