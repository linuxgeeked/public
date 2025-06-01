#!/bin/bash
# Captures packets using tcpdump and saves them to a file

echo "📡 Capturing network packets for 10 seconds..."
mkdir -p ~/packet_lab
cd ~/packet_lab
sudo tcpdump -i any -w capture.pcap -c 50

echo "✅ Capture complete: saved to ~/packet_lab/capture.pcap"