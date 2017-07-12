# collect-cuda

The project contains `collectd` `exec` plugin for collecting nVidia GPU
metrics. The plugin works well with single and multi-GPU machines.

## Motivation

Recently, I have started to work as a system administrator in
a scientific research at the University of Warsaw. Apart from
monitoring the research servers, I also wanted to collect metrics
from nVidia cards. I discovered that currently there is no
modern working solution for `collectd`, so I decided to write
this plugin.

## Installation

First, make sure that the `collectd` `exec` plugin is loaded. Uncomment
or add this line in your `collectd.conf`:

