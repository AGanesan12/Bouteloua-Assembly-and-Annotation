




 wget https://github.com/chaoszhang/ASTER/archive/refs/heads/Linux.zip

## now use astral-pro3 to root and get proportions of topologies
../ASTER-Linux/bin/astral-pro3 --root thomaeum -t 8 -u 3 -w 10 -o anchors_aster.2025-10-06.ASTRALPRO3OUT.u3.tre anchors_aster.2025-10-06.tre  

conda activate anchorwave_new
grampa -s anchors_aster.2025-10-06.ASTRALPRO3OUT.u3.tre -g anchors_forgrampa.2025-10-06.tre -o grampa_out -f all
