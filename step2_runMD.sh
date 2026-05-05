#!/bin/bash
#run MD simulations

#!!!Before running the simulations, please generate the weak constrain files as follows

#First, divide the protein.gro into pro.gro and lig.gro manually

#Second, run the following commands
#gmx genrestr -f pro.gro -o posrebonepro.itp -fc 100 100 100 
#(choose the backbone group )

#gmx genrestr -f lig.gro -o posrebonelig.itp -fc 100 100 100 
#(choose the backbone group )

#Third, add the following sentences in the Topol Files
#ifdef POSRES100 
#include "posrebonepro.itp" or #include "posrebonelig.itp"
#endif


#########
#  EM  #
#########
echo "Starting constrained Energy Minimization."
gmx grompp -f em1.mdp -c ion.gro -r ion.gro -p topol.top -o em1.tpr
gmx mdrun -v -deffnm em1 

echo "Starting No-constrained Energy Minimization."

gmx grompp -f em.mdp -c em1.gro -p topol.top -o em.tpr
gmx mdrun -v -deffnm em 

#  NVT  #
#########
echo "Starting constant temperature equilibration..."
gmx grompp -f nvt.mdp -c em.gro -r em.gro -n index.ndx -p topol.top -o nvt.tpr
gmx mdrun -v -deffnm nvt 
echo "Constant temperature equilibration complete."

#  NPT  #
#########
echo "Starting constant pressure equilibration..."
gmx grompp -f npt.mdp -c nvt.gro -r nvt.gro -t nvt.cpt -n index.ndx -p topol.top -o npt.tpr
gmx mdrun -v -deffnm npt 
echo "Constant pressure equilibration complete."

########
#  MD  #
########
echo "Starting production MD simulation..."
gmx grompp -f md.mdp -c npt.gro -r npt.gro -t npt.cpt -n index.ndx -p topol.top -o md.tpr
gmx mdrun -v -deffnm md 
echo "Production MD complete."
rm \#*
