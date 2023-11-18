#!/bin/bash

aws account list-regions --query "Regions[?RegionOptStatus != 'DISABLED'].RegionName"