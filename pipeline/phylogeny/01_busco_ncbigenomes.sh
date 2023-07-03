#!/bin/bash -l
#SBATCH -p short -c 8 -n 1 -N 1 --mem 16gb --out logs/busco.%a.log -a 1-118


module load busco
# need a writeable folder for BUSCO augustus training
export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)
IN=genomes
OUT=BUSCO
DB=fungi_odb10
AUGUSTUSSPECIES=ustilago


CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

export NUMEXPR_MAX_THREADS=$CPU

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
  N=$1
  if [ -z $N ]; then
    echo "need to provide a number by --array or cmdline"
    exit
  fi
fi

if [ ! -d $OUT ]; then
  mkdir -p $OUT
fi


INFILE=$(ls $IN/*_genomic.fna | sed -n ${N}p)
BASE=$(basename $INFILE _genomic.fna)

FILE=short_summary.specific.$DB.$BASE.json
echo "Looking for $OUT/$BASE/$FILE"

if [ ! -d $OUT/$BASE ]; then
    busco -m genome -l $DB -c $CPU -o $BASE --out_path $OUT --offline \
	  --augustus_species $AUGUSTUSSPECIES --in $INFILE --download_path $BUSCO_LINEAGES
elif [ ! -f $OUT/$BASE/$FILE ]; then
    busco -m genome -l $DB -c $CPU -o $BASE --out_path $OUT --offline \
	  --augustus_species $AUGUSTUSSPECIES --in $INFILE --download_path $BUSCO_LINEAGES --restart
fi

module unload busco
if [ ! -s $IN/$BASE.stats.txt ]; then
    module load AAFTF
    AAFTF assess -i $INFILE -r $IN/$BASE.stats.txt
fi
