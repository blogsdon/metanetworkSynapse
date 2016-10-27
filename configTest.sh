#!/bin/bash

#output path for temporary result file prior to pushing to s3/synapse
outputpath="/shared/testNetwork/"

#id of folder on Synapse that network files will go to
parentId="syn7383984"

#path to error output
errorOutput="$outputpath/errorLogs"

#path to out output
outOutput="$outputpath/outLogs"
