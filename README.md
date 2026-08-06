# Bouteloua Assembly and Annotation

Code and scripts used for PacBio HiFi genome assembly, QC, gene and repeat annotation, phylogeny/polyploidy inference, and orthogroup analysis for the paper *High-Quality Draft Genome Assemblies and Comparative Genomics of Three Bouteloua Species (Poaceae: Chloridoideae)* (Ganesan et al.).

Note: scripts were run on Cornell BioHPC and contain cluster-specific paths (e.g. `/programs/...`, `/workdir/...`). Adjust paths for your own environment before running.

Contents
- `src/assembly/` - hifiasm assembly, contig extraction, seqkit stats (N50/L50), BUSCO. See `src/assembly/readme.md`.
- `src/annotation/` - Helixer gene prediction, CDS/peptide extraction, gene count summaries, and TE annotation (panEDTA, LAI) in `src/annotation/te/`. See `src/annotation/readme.md`.
- `src/orthology/` - Orthogroup inference across thirteen PACMAD proteomes with OrthoFinder, and identification of orthogroups lost in Bouteloua. See `src/orthology/readme.md`.
- `src/phylogeny/` - Syntenic region extraction (AnchorWave), gene tree estimation (MAFFT, raxml-ng), species tree (ASTRAL-PRO3), and polyploidy placement (GRAMPA). See `src/phylogeny/readme.md`.

Data Availability
Genome assemblies and annotations are deposited on Figshare:
- B. curtipendula: https://doi.org/10.6084/m9.figshare.30311320
- B. eriopoda: https://doi.org/10.6084/m9.figshare.30311338
- B. gracilis: https://doi.org/10.6084/m9.figshare.30311368

Raw PacBio HiFi sequencing reads: [BioProject accession pending]

---

## License
Released under the MIT License. See `LICENSE` for details.
