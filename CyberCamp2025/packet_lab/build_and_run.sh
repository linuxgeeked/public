#!/bin/bash
# Compiles and runs the student's packet analysis program

if [ ! -f packet_counter.c ]; then
    echo "❌ Error: 'packet_counter.c' not found. Please write your C program first."
    exit 1
fi

echo "🧹 Cleaning previous build..."
rm -f packet_counter

echo "🛠️ Compiling..."
gcc packet_counter.c -o packet_counter -lpcap

if [ $? -eq 0 ]; then
    echo "🚀 Running packet_counter:"
    ./packet_counter
else
    echo "❌ Compilation failed."
fi
