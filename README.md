# collectd-cuda

The project contains [collectd](https://collectd.org/) 
[exec](https://collectd.org/documentation/manpages/collectd-exec.5.shtml)
plugin for collecting nVidia GPU metrics. The plugin works well
with single and multi-GPU machines.

## Motivation

Recently, I have started to work as a system administrator in
a scientific research at the University of Warsaw. Apart from
monitoring the research servers, I also wanted to collect metrics
from nVidia cards. I discovered that currently there is no
modern working solution for `collectd` and `InfluxDB`, so I decided to write
this plugin with `InfluxDB` as the storage for collected metrics.

## Installation

First, make sure that the `collectd` `exec` plugin is loaded. Uncomment
or add this line in your `collectd.conf`:
```
LoadPlugin exec
```
Then add the path to `collectd_cuda.sh` in `exec` configuration:
```
<Plugin exec>                                                                   
    Exec some_user "/path/to/collectd_cuda.sh"                       
</Plugin>
```

## Sample output

Depending on metrics selection the plugin will return `PUTVAL` Plain Text
Protocol messages. Below is the sample output from server with four *TitanX*
cards.
```
PUTVAL server.fqdn/cuda-0000:02:00.0/percent-fan_speed interval=10 N:23
PUTVAL server.fqdn/cuda-0000:02:00.0/memory-memory_free interval=10 N:11172
PUTVAL server.fqdn/cuda-0000:02:00.0/temperature-temperature_gpu interval=10 N:32
PUTVAL server.fqdn/cuda-0000:02:00.0/power-power_draw interval=10 N:16.87
PUTVAL server.fqdn/cuda-0000:02:00.0/memory-memory_used interval=10 N:0
PUTVAL server.fqdn/cuda-0000:03:00.0/percent-fan_speed interval=10 N:23
PUTVAL server.fqdn/cuda-0000:03:00.0/memory-memory_free interval=10 N:11172
PUTVAL server.fqdn/cuda-0000:03:00.0/temperature-temperature_gpu interval=10 N:36
PUTVAL server.fqdn/cuda-0000:03:00.0/power-power_draw interval=10 N:17.08
PUTVAL server.fqdn/cuda-0000:03:00.0/memory-memory_used interval=10 N:0
PUTVAL server.fqdn/cuda-0000:83:00.0/percent-fan_speed interval=10 N:23
PUTVAL server.fqdn/cuda-0000:83:00.0/memory-memory_free interval=10 N:11172
PUTVAL server.fqdn/cuda-0000:83:00.0/temperature-temperature_gpu interval=10 N:35
PUTVAL server.fqdn/cuda-0000:83:00.0/power-power_draw interval=10 N:16.88
PUTVAL server.fqdn/cuda-0000:83:00.0/memory-memory_used interval=10 N:0
PUTVAL server.fqdn/cuda-0000:84:00.0/percent-fan_speed interval=10 N:23
PUTVAL server.fqdn/cuda-0000:84:00.0/memory-memory_free interval=10 N:11172
PUTVAL server.fqdn/cuda-0000:84:00.0/temperature-temperature_gpu interval=10 N:42
PUTVAL server.fqdn/cuda-0000:84:00.0/power-power_draw interval=10 N:17.37
PUTVAL server.fqdn/cuda-0000:84:00.0/memory-memory_used interval=10 N:0
```

## Customization

Metrics can be added or removed from the `config` array.
```shell
declare -A config=(                                                             
    ["temperature_gpu"]=temperature                                             
    ["fan_speed"]=percent                                                       
    #["pstate"]=absolute                                                        
    ["memory_used"]=memory                                                      
    ["memory_free"]=memory                                                      
    ["utilization_gpu"]=percent                                                 
    ["utilization_memory"]=percent                                              
    ["power_draw"]=power                                                        
)
```
Each entry must be in the specific format:
```
["metric_name"]=value_type
```
Where `metric_name` can be any query string from `nvidia-smi` with
underscores `_` instead of dots `.`.

The full list of query options can be obtained by running:
```shell
nvidia-smi --help-query-gpu
```
