#!/bin/bash
#SBATCH --partition=componc_cpu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mem=8GB
#SBATCH --job-name=graffite_test
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=preskaa@mskcc.org
#SBATCH --output=slurm%j_graffite_test.out

## activate nf-core conda environment
source /home/preskaa/miniforge3/bin/activate nf-core

module load java/20.0.1
## specify params
sif=/data1/shahs3/users/preskaa/singularity/graffite_latest.sif
outdir=/data1/shahs3/users/preskaa/SarcAtlas/data/APS052_graffite_test
samplesheet=${outdir}/samplesheet.csv
config=${outdir}/nextflow.config
vcf=/data1/shahs3/isabl_data_lake/analyses/00/77/50077/results/minda/SHAH_H003458_T01_01_WG01_somatic_minda_union.vcf
TE_library=/data1/shahs3/reference/ref-sarcoma/graffite/Homo_sapiens_DFAM3.9_051525.fa
ref_genome=/data1/shahs3/isabl_data_lake/assemblies/GRCh38-P14/GRCh38.primary_assembly.genome.fa
tmpdir=${outdir}/tmp
mkdir -p ${outdir} ${tmpdir}
export NXF_SINGULARITY_TMPDIR=${tmpdir}
cd ${outdir}

nextflow run $HOME/GraffiTE/main.nf \
  -profile iris \
  --out ${outdir} \
  --vcf ${vcf} \
  --TE_library ${TE_library} \
  --reference ${ref_genome} \
  --reads ${samplesheet} \
  --mammal \
  -with-trace \
  -with-report \
  --normalize_vcf \
  -resume