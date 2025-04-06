#!/bin/bash
# Explore the effect of an increasing energy cutoff
# nguyen@flex.phys.tohoku.ac.jp
#############

for vdw in pbe vdw-df vdw-df2 vdw-df3-opt1 \
           vdw-df3-opt2 vdw-df-C6 rvv10; do

cat > vc-relax.$vdw.in << EOF
&CONTROL
calculation   = 'vc-relax'
pseudo_dir    = '../pseudo/'
outdir        = '../tmp/'
prefix        = 'gr'
etot_conv_thr = 1.0D-5
forc_conv_thr = 1.0D-4
/
&SYSTEM
ibrav         = 4
a             = 2.4639055825
c             = 20.0
nat           = 4
ntyp          = 1
occupations   = 'smearing'
smearing      = 'mv'
degauss       = 0.02
ecutwfc       = 60
input_dft     = '$vdw'
/
&ELECTRONS
mixing_beta   = 0.7
conv_thr      = 1.0D-9
/
&IONS
ion_dynamics  = 'bfgs'
/
&CELL
cell_dynamics = 'bfgs'
press_conv_thr= 0.05
cell_dofree   = '2Dxy'
/
ATOMIC_SPECIES
C 12.0107 C.pbe-n-rrkjus_psl.0.1.UPF
ATOMIC_POSITIONS (crystal)
C  0.000000000  0.000000000  0.412500000
C  0.333333333  0.666666666  0.412500000
C  0.000000000  0.000000000  0.587500000
C  0.666666666  0.333333333  0.587500000
K_POINTS (automatic)
8 8 1 0 0 0
EOF

mpirun -np 4 pw.x <vc-relax.$vdw.in>vc-relax.$vdw.out

done
