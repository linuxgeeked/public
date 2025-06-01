#!/bin/bash
# Captures packets using tcpdump and saves them to a file

echo "📡 Capturing 50 packets..."
sudo tcpdump -i any -w capture.pcap -c 50

echo "✅ Capture complete: saved to capture.pcap"
