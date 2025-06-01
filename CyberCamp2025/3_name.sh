#!/bin/bash
echo "What is your name?"
read name
echo "Hi $name, welcome to BASH!"

if [ "$name" == "Alice" ]; then
	echo "Welcome back, $name!"
fi

for i in {1..10}; do
	echo "Loop number $i"
done
