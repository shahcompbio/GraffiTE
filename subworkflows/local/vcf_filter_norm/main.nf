// filter for sequence-resolved SVs and normalize minda vcfs for use with graffiTE
include { BCFTOOLS_VIEW } from '../../../modules/nf-core/bcftools/view/main'
include { BCFTOOLS_NORM } from '../../../modules/nf-core/bcftools/norm/main'

workflow VCF_FILTER_NORM {
    take:
    ch_vcf // channel: [ val(meta), [ vcf ], [ index ]]
    ref_fasta

    main:
    // filter for sequence-resolved SVs
    BCFTOOLS_VIEW(ch_vcf, [], [], [])
    // normalize vcf
    BCFTOOLS_NORM(
        BCFTOOLS_VIEW.out.vcf.map { meta, vcf -> [meta, vcf, []] },
        [[id: "ref"], ref_fasta],
    )

    emit:
    norm_vcf = BCFTOOLS_NORM.out.vcf
}
