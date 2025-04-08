#!/usr/bin/env nextflow

nextflow.enable.dsl=2
merge_script = file("$baseDir/scripts/sample_aggregator.py")

process fastqcount {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    cpus 2
    memory '4 GB'
    input:
    file(fastq)

    output:
    path("output/*_count.txt"), emit: count
    file("output/*_stat.txt")    

    """

    ~/fastqcount -i ${fastq} -o output/ -n ${fastq.simpleName}
    """
}

process merge_table {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '2 GB'
    cpus 1
    input:
    file(merge_script)
    file(sample_counts)

    output:
    file("count_table.csv")

    """
    python ${merge_script} 
    """
}

workflow {
    fastq_file = Channel.fromPath(params.fastq_source_folder+'/*.fq.gz', type: 'file')
    fastqcount(fastq_file)
    merge_table(merge_script, fastqcount.out.count.collect())

}
