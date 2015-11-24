#!/bin/bash

LOOKUP="nslookup.exe"
NMAP='nmap -T5 -A -p- -v --script=auth,brute,default,discovery,exploit,malware,safe,version,vuln'
NMAP_SHORT='nmap -T5 -sV -O -p-'
TRACEROUTE="tracert.exe"
SSLSCAN="/cygdrive/h/Downloads/sslscan.exe --cipher-details"
TARGETS="targets.txt"

function scan() {
	mkdir -p "$1"
	scan_nslookup "$1" > "$i/nslookup.txt"
	scan_traceroute "$1" > "$i/traceroute.txt"
	scan_nmap "$1" > "$i/nmap.txt"
	scan_nmap_short "$1" > "$i/nmap_short.txt"
	scan_sslscan "$1"
}

function echorun() {
	echo -e "Running: $@" 1>&2
	echo -e "# $@"
	$@
}

function scan_nslookup() {
	echorun $LOOKUP "$1"
}

function scan_nmap() {
	echorun $NMAP "$1"
}

function scan_nmap_short() {
	echorun $NMAP_SHORT "$1"
}

function scan_traceroute() {
	echorun $TRACEROUTE "$1"
}

function scan_sslscan() {
	for port in `grep -P 'open\s+ssl' "$1/nmap.txt" | grep -oP '^\d+'`; do
		echorun $SSLSCAN "$1:$port" > "$1/sslscan-${port}.txt"
	done;
}


if [ "$1" != "" ]; then
	TARGETS=$1
fi

for i in `cat $TARGETS`; do
	scan "$i";
done
