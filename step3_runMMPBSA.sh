#!/bin/bash
#running MM/PBSA calculation

echo "Starting standard MMPBSA calculation..."
bash gmx_mmpbsa-standard.bsh

#or
#echo "Starting screening MMPBSA calculation..."
#bash gmx_mmpbsa-debye.bsh
