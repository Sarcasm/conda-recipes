# Sarcasm's conda recipes

This repository contains my [conda](https://conda.io) recipes.

The built recipes can be found on my anaconda repository:
- https://anaconda.org/sarcasm

# Prerequisites

    conda install conda-build anaconda-client

# Build a package

    conda build <package>/<version>

# Upload a package

    anaconda upload $(conda build --output <package>/<version>)
