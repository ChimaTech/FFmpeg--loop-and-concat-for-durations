#!/bin/bash

string=$1

echo "${string}" > temp.txt

string=$(sed 's/\r$//' "temp.txt")

rm -f temp.txt

echo "${string}"