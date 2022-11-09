#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FASTQC } from './modules/nf-core/fastqc/main'
include { MULTIQC } from './modules/nf-core/multiqc/main'

Channel.fromPath(params.reads, checkIfExists: true)
    .map{ row -> tuple([id:row.baseName, single_end:true], row) }
    .set{ ch_reads }

workflow {
    FASTQC (ch_reads)

    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]})
    MULTIQC (
        ch_multiqc_files.collect(),
        Channel.empty().toList(),
        Channel.empty().toList(),
        Channel.empty().toList(),
    )
}
