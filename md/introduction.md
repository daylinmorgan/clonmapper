# Introduction

Insight into the clonal composition of a population of cells during key events
such as development, infection, tumor progression, or treatment response,
is critical to understanding the nature of the interaction between cells
and the selective forces shaping them.
While advances in genomics and transcriptomics and the advent
of single-cell RNA sequencing (scRNA-seq) have vastly increased
the resolution at which we can understand cellular processes,
they lack the ability to directly assign clonal relationships.
To meet this need, lineage tracing technologies, such as DNA barcoding,
have been developed to label and track individual cells and their progeny [@blundell2014;@kebschull2018].
In DNA barcoding, each individual cell in a population is labeled
with a unique random string of nucleotides that is integrated
into the genome and heritable by its daughter cells.
The ensemble of all DNA barcodes in the cell population can be quantified
by next-generation sequencing (NGS) to determine
how clonal abundance changes over time.

While highly informative, DNA barcoding and other lineage tracing techniques
are still limited in that interesting lineages/clones of cells cannot be easily
isolated from the bulk population for clonally pure analysis.
Here, we describe a detailed protocol for **ClonMapper**,
a workflow that enables precise identification and isolation
of populations of interest from heterogeneous mammalian cells [@alkhafaji2018].
ClonMapper is a functionalized variant of DNA barcoding in which the DNA barcode
is a CRISPR-Cas9 compatible single-guide RNA (sgRNA).
The sgRNA-barcode has multiple functionalities: (1) It is an integrated DNA barcode,
(2) It is transcribed and captured in scRNA-seq workflows, and
(3) It can be used to actuate lineage-specific genes of interest using
an activator variant of Cas9 [@chavez2015].
This protocol describes the use of ClonMapper
for lineage-specific activation of Green Fluorescent Protein,
enabling isolation of clonal cells from a heterogeneous population.

The sgRNA barcode is engineered using the CROPseq method [@datlinger2017] such
that the sgRNA barcode is transcribed by both RNA polymerase III and
RNA polymerase II, creating a functional sgRNA barcode transcript and a
polyadenylated transcript containing the barcode, respectively.

Cells are first transduced with lentivirus containing
a ClonMapper sgRNA barcode vector at a low multiplicity of infection (MOI)
to minimize the integration of multiple barcodes per cell.
The sgRNA barcode is co-expressed with blue fluorescent protein (BFP)
for easy identification and collection of barcoded cells via flow cytometry
and fluorescence-activated cell sorting (FACS).
Once established, the barcoded cell population is available for experimental manipulation.
Clonal dynamics may be measured by NGS analysis and gene expression signatures
of clonal populations may be resolved by scRNA-seq. Once a barcode of interest
is identified from NGS or scRNA-seq, the barcode identifier can be exploited
for isolation of the clone.
This is achieved by transfecting the cell population with a plasmid containing
an activator variant of Cas9, dCas9-VPR, and a second plasmid containing the
Cas9-homing PAM sites adjacent to the identified barcode upstream of a super-folding green
fluorescent protein (sfGFP) reporter.
Expression of sfGFP will occur only in cells that are producing the matching
sgRNA barcode, allowing precise identification and FACS isolation of cells
from lineages of interest.

This protocol was originally developed by Aziz Al'Khafaji in the Brock Lab at the University of Texas at Austin.
It was written and published in [Methods in Molecular Biology](https://doi.org/10.1007/978-1-0716-1811-0_8) by Andrea Gardner and Daylin Morgan.
This version has been updated with the Brock Lab's current best practices.
