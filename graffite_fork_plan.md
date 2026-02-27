# GraffiTE Fork Plan

## Goal
Fork cgroza/GraffiTE and add a pre-filtering step to handle sequence-unresolved SVs
from the Minda union VCF before the repeat masking step.

## Background
The Minda union VCF (`SHAH_H003458_T01_01_WG01_somatic_minda_union.vcf`) contains:
- ~1117 sequence-resolved variants (actual bases in ALT) ← GraffiTE can use these
- ~2656 symbolic alleles (`<INS>`, `<DEL>`) ← filtered out by repeatmask_VCF, causing empty output
- ~1337 BND variants (bracket notation e.g. `]chr1:1099904]A`) ← also filtered out

GraffiTE's `repeatmask_VCF` step silently drops symbolic/BND variants because there
is no sequence to BLAST against the TE library.

## Plan

### 1. Fork the repo
Fork https://github.com/cgroza/GraffiTE

### 2. Install nf-core modules
```bash
nf-core modules install bcftools/view
nf-core modules install bcftools/norm
```

### 3. Add filter_seqres step
Wire in before `split_repeatmask`:
- `BCFTOOLS_VIEW`: filter to sequence-resolved variants only
  - filter expression: `'ALT !~ "^<" && ALT !~ "\[" && ALT !~ "\]"'`
- `BCFTOOLS_NORM`: split multiallelic sites
  - flag: `-m-`

### 4. Map params.vcf channel flow
- Check how `params.vcf` enters the workflow (channel vs direct path)
- Insert new modules between VCF input and existing `split_repeatmask` process

## Test VCF
`/data1/shahs3/isabl_data_lake/analyses/00/77/50077/results/minda/SHAH_H003458_T01_01_WG01_somatic_minda_union.vcf`

## Cluster Config (iris)
See `nextflow.config` in this directory for the iris profile and process publishDir settings.
The HPC submission script is at:
`/data1/shahs3/users/preskaa/SarcAtlas/hpc_submission/APS052_TCDO-SAR-032_graffiTE.sh`

Key settings:
- `NXF_SINGULARITY_TMPDIR=${outdir}/tmp`
- `-profile cluster,iris`
- `-with-singularity` pointing to local SIF
