#!/bin/bash

# Author: Kamil Wilczek
# E-mail: kamil.van.wilczek@gmail.com
#
# This script is a collectd plugin that gathers metrics
# from nVidia cards.

HOSTNAME="${COLLECTD_HOSTNAME:-$(hostname --fqdn)}"                              
INTERVAL="${COLLECTD_INTERVAL:-10}"         

# Reading the config file.
config_file="plugins_config.sh"
if [[ ! -f "$config_file" ]]
then
	echo "Missing config file!"
	exit 1
else
	source "$config_file"
fi

# This parameter will always be present. This is a way to
# uniquely identify a GPU card (very useful in multiGPU
# machines). nvidia-smi also accepts this ID as a parameter
# in many queries. Alternatively one can use 'uuid'.
query_string="pci.bus_id,"

# Building the nvidia-smi --query-gpu string.
# The last comma is removed during variable expansion
# in the query.
for parameter in "${!config[@]}"
do
	query_string+="${parameter//_/.},"
done

# Current state of all GPUs.
gpus_state=$(nvidia-smi --query-gpu="${query_string%,}" --format=csv,noheader,nounits)

# Output for collectd.
# Here bash variable indirection is used.
# For example, variable name 'power_draw" is used as a parameter in
# collectd protocol and it also has value assigned to that name.
# while IFS=',' read -r gpu_id $(echo "${!config[*]}" )
while IFS=',' read -r gpu_id "${!config[@]}"
do
	for parameter in "${!config[@]}"
	do
		# GPU power state, 'pstate', is returned in as a number with
		# 'P' prefix. The easiest way to remove the 'P' without 
		# additional loops and conditions is to simply expand the
		# 'parameter' variable with '//P'.
		echo "PUTVAL ${HOSTNAME}/cuda-${gpu_id}/${config[$parameter]}-${parameter} interval=$INTERVAL N:${!parameter//P}"
	done
done <<< "${gpus_state// }"


