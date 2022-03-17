# Codemeta Harvester

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

This is a harvester for software metadata. It actively attempts to detect and
convert software metadata in source code repositories and converts this to a
unified [codemeta](https://codemeta.github.io) representation.

The tool is implemented as a simple POSIX shell script that in turn invokes a number of tools to
do the actual work:

* [codemetapy](https://github.com/proycon/codemetapy) - Conversion to codemeta from various other metadata formats
* [cffconvert](https://github.com/citation-file-format/cff-converter-python) - Conversion from CITATION.cff to codemeta
* [Software Metadata Extraction Framework (SOMEF)](https://github.com/KnowledgeCaptureAndDiscovery/somef) - Analyzes and extracts metadata from README.md and some other sources (optional dependency)

A few simple additional metadata extractions methods, as simple shell scripts, have been implemented alongside the main script.

This harvester can be used for two purposes:

1. to harvest a possibly large number of software projects, for instance to make them available in some kind of search portal.
2. as a means to produce a `codemeta.json` file for your own project

## Installation

A docker container can be build as follows:

``docker build -t proycon/codemeta-harvester .``

A pre-built container image can also be pulled from Docker Hub once the software is released:

``docker pull proycon/codemeta-harvester``

Alternatively if you prefer not to use containers, you can also install the
software as follows:

* Run ``make env`` to build a Python virtual environment in the `env` directory with the needed dependencies. This assumes you have a Python installation on your system.
* Activate the environment with `. env/bin/activate` whenever you want to use it.
* You will need to also ensure to install the following dependencies using your system's package manager
    * git
    * curl
    * [dasel](https://github.com/TomWright/dasel)
    * coreutils or busybox

## Usage



