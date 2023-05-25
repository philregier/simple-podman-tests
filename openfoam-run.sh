#!/bin/bash

cd /contents/src
eval $(/contents/src/spack/bin/spack load --sh openfoam@2012 %aocc@3.2.0)
wget http://openfoamwiki.net/images/6/62/Motorbike_bench_template.tar.gz

tar -xzvf Motorbike_bench_template.tar.gz
cd $PWD/bench_template
sed -i '/#include "streamLines"/c\ ' basecase/system/controlDict
sed -i '/#include "wallBoundedStreamLines"/c\ ' basecase/system/controlDict
sed -i '34s/40 16 16/80 32 32/' basecase/system/blockMeshDict

unset FOAM_SIGFPE
export FOAM_SIGFPE=false
# Prepare cases
which snappyHexMesh
for i in 48 96 192 384; do
  d=run_$i
  echo "Prepare case ${d}..."
  cp -r basecase $d
   cd $d
  pwd
  if [ $i -eq 1 ]
  then
  mv Allmesh_serial Allmesh
  elif [ $i -gt 128 ]
  then
  sed -i "s|runParallel snappyHexMesh -overwrite|mpirun -np ${i} -mca btl    vader,self  --map-by hwthread -use-hwthread-cpus  snappyHexMesh -parallel    -overwrite > log.snappyHexMesh|" Allmesh
  fi
  sed -i "s/method.*/method scotch;/" system/decomposeParDict
  sed -i "s/numberOfSubdomains.*/numberOfSubdomains           ${i};/" system/decomposeParDict
 ./Allmesh
 cd ..
done
# Run cases
for i in 48 96 192 384; do
 echo "Run for ${i}..."
 cd run_$i
 if [ $i -eq 1 ]
 then
 simpleFoam > log.simpleFoam 2>&1
 elif [ $i -gt 128 ]
 then
 mpirun -np ${i} --map-by hwthread -use-hwthread-cpus simpleFoam -parallel |& tee log.simpleFoam
sed -i "s|mpirun -np ${i} --map-by hwthread -use-hwthread-cpus  snappyHexMesh -parallel -overwrite > log.snappyHexMesh|runParallel snappyHexMesh -overwrite|" Allmesh
 else
 mpirun -np ${i} --map-by core  simpleFoam -parallel > log.simpleFoam 2>&1
 fi
 cd ..
done
echo "# cores   Wall time (s):"
echo "------------------------"
for i in 64 128 256; do
 echo $i `grep Execution run_${i}/log.simpleFoam | tail -n 1 | cut -d " " -f 3`
done
