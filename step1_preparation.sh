#!/bin/bash
#Building the simulation systems

echo "starting build systems......"
#choose the force field
gmx pdb2gmx -f 1r0r.pdb -o protein.gro  

gmx editconf -f protein.gro -o box.gro -c -d 1.5

gmx grompp -f em0.mdp -c box.gro -p topol.top -o em0.tpr -maxwarn 3

gmx mdrun -v -deffnm em0 

gmx solvate  -cp em0.gro -cs spc216.gro -o solv.gro -p topol.top

gmx grompp -f ion.mdp -c solv.gro -p topol.top -o ion.tpr -maxwarn 3

gmx genion -s ion.tpr -o ion.gro -p topol.top -pname NA -nname CL -conc 0.15 -neutral <<EOF
13
EOF

gmx make_ndx -f ion.gro -o index.ndx  <<EOF
splitch 1 
name 17 pro
name 18 lig
1
name 19 com
q
EOF
#(com=protein, pro=pro-R, lig=pro-L)
