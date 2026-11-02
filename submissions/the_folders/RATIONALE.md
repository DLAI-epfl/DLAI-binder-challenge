<!-- Which face of microcystin we target, and why.
     To be decided the week of October 20. Options:
     (a) conserved face: Adda + D-Glu + ring backbone
         → broad detection of microcystins, likely cross-reactivity with nodularin
         → consistent with the WHO guideline value written as "total microcystin-LR"
     (b) variable positions (the 2 L residues)
         → congener-level resolution, but we miss blooms from other producers
     DECISION: 
     Option (a) — Target the conserved face of MC-LR, primarily focusing on Adda, with complementary interactions involving 
     D-Glu and the cyclic peptide backbone.
     
     DATE:November 2, 2026
     
     JUSTIFICATION: 
We chose to target the conserved region of MC-LR, primarily focusing on the Adda residue and the adjacent D-Glu residue.
We selected Adda as the main recognition site because of its extended hydrophobic and aromatic structure, which offers opportunities for favorable van der Waals interactions, hydrophobic packing, and shape complementarity within the protein binding pocket. Moreover, Adda is conserved across many microcystin congeners, making it a relevant structural feature for molecular recognition.

D-Glu was selected as a complementary recognition site because its negatively charged carboxylate group could establish favorable electrostatic interactions and hydrogen bonds with appropriately positioned residues in the binder. Additional contacts with the cyclic peptide backbone could further contribute to molecular recognition, thus increasing binding specificity for MC-LR.

We did not prioritize the variable amino acid positions (2 and 4), as targeting them could favor congener-specific recognition and potentially limit the detection of other microcystins. Furthermore, given the relatively small size of our binder, we favored a localized binding interface rather than attempting to recognize multiple potentially distant regions of the ligand.

This strategy aims to achieve favorable binding to MC-LR while potentially allowing broader recognition of microcystin congeners. However, cross-reactivity with other microcystin congeners (such as MC-RR and MC-YR) and related toxins (ex: nodularins which have an Adda group) remains possible, and binding specificity will require experimental validation.

## Approach
<!-- Chosen pipeline and why:
     Include what we tried that did NOT work.

     Backbones are generated with RFdiffusion3, an all-atom method that models the ligand explicitly. MC-LR is placed in the conformation seen in the PP1-bound structure (PDB 1FJM), because the toxin is flexible and its bound shape differs from the solution one. Diffusion is conditioned to bury the Adda tail and to position at least one polar contact near the D-Glu carboxylate, following our decision to target the conserved face. 
    pseudocycle scaffolds docked around MC-LR (An et al. 2024), run at smaller scale / not pursued because it needs scaffold generation and a resampling round we cannot test within one design round.
    Sequences are designed with LigandMPNN with cysteine excluded globally, which prevents any Michael addition to Mdha (position 7 in the cyclic structure of Microcystin) and any disulfide, 
    and with biases toward aromatic/aliphatic residues around Adda and Arg/Tyr/Ser near the carboxylates, mirroring the PP1 contacts. 
    Every design is co-folded with and without the ligand using Boltz; designs passing the first filters are re-predicted with AlphaFold 3, so two independent predictors must agree. 
    Survivors undergo one round of sequence redesign or partial diffusion and are revalidated with the same filters.
     LOGBOOK (to be filled in at each session):
     - 2026-10-__ : -->

## Filtering
<!-- THRESHOLDS WRITTEN BEFORE SEEING THE RESULTS — this is the graded point.
     Metric | Threshold | Date set | Reason for the threshold
     Cysteine count|0|-----|Mdha is electrophilic; no disulfides allowed
     pLDDT / Model Confidence|-----|-----|-----
     ipTM / pTM|-----|-----|-----
     Adda burial|-----|-----|-----
     D-Glu / Masp carboxylate contacts|-----|-----|-----
     Length|-----|-----|-----



## The three
<!-- The three designs, ranked 1-2-3, with a STRUCTURAL argument for each.
     Not "best ipTM" — but "this pocket completely buries Adda,
     and these residues contact the D-Glu". -->

## What would prove us wrong
<!-- Which experimental result would show that our reasoning was wrong.
     To be written BEFORE we have any data. -->

---
## Hard constraints from the brief — final check
- [ ] Buried pocket, shape complementarity and buried SASA reported
- [ ] No cysteine near the ligand (electrophilic Mdha → no covalent trap)
- [ ] Stable and soluble in E. coli, no disulfide bonds
- [ ] One free site for the signal output / split
- [ ] Sequences with no tag, no X, no non-standard residue
- [ ] 500–800 words in the final version
