# Binder Challenge 2026 — Microcystin-LR

**Design a protein that catches a cyanotoxin.**

Partner: **GenoRobotics**, in collaboration with the **Dal Peraro Lab** (EPFL)
Target: **microcystin-LR**, the dominant cyanotoxin in Lake Geneva blooms
Status: in progress

---

## The problem

Cyanobacterial blooms in Lake Geneva are becoming more frequent as the lake warms. The dominant bloom-former, *Planktothrix rubescens*, produces microcystins — hepatotoxic cyclic peptides that are a genuine public-health problem for a lake several hundred thousand people drink from and swim in.

Finding out whether the water is safe currently requires a boat, a bottle, a courier and a laboratory. GenoRobotics is building a portable lab-on-a-chip that measures toxin concentration in the field, with a camera as the detector.

That device needs a recognition element. Today that would be an antibody: expensive, batch-variable, and unenthusiastic about sitting in a warm boat. **This challenge is to design the alternative.**

---

## The target

**Microcystin-LR** — a cyclic heptapeptide, ~995 Da.

| Feature | Why it matters for design |
|---|---|
| **Adda** | A C20 β-amino acid with a phenyl ring and conjugated diene. A long hydrophobic tail — your best binding handle. |
| **D-Glu α-carboxyl** | Contacts the catalytic metals in PP1 via bridging waters. Essential for toxicity. |
| **D-MeAsp carboxyl** | Salt-bridge / H-bond handle. Contacts Arg96 and Tyr134 in PP1. |
| **Mdha** | Electrophilic — forms a covalent adduct with Cys273 in PP1. **Do not design a cysteine anywhere near it.** |
| **Positions 2 and 4** | Variable across 250+ congeners. Your specificity decision lives here. |

### Nature's blueprint

Protein phosphatase 1 was crystallised with microcystin-LR bound at 2.1 Å — **[PDB 1FJM](https://www.rcsb.org/structure/1FJM)**. Read it before you design anything. It shows three independent recognition elements engaging one small molecule, and it is the closest thing you have to a worked solution.

You want PP1's recognition, not its fate. PP1 dies binding this molecule.

---

## The specification

WHO's provisional guideline value for drinking water is **1 µg/L total microcystin-LR** (free plus cell-bound).

At ~995 Da, that is roughly **1 nM**. Every design decision gets judged against that number.

Two consequences you cannot design around:

- A competitive detection format needs affinity in the same range as the target concentration — single-digit nM or better.
- "Total" includes cell-bound toxin, so the device needs a lysis step. That's GenoRobotics' problem, but both teams have to agree on it early.

---

## Be warned: this is a hard target

Everything in Protein Design 101 was tuned on protein–protein interfaces — hundreds of interface atoms, and a lot of training data. A small molecule gives you a handful of atoms to work with, so high affinity demands a pocket with very high shape complementarity. There is no room for a sloppy interface.

The published record is sobering. Earlier small-molecule binder design successes concentrated on rigid hydrophobic targets and typically needed substantial experimental optimisation to climb from micromolar towards high nanomolar. Deep-learning successes have clustered on large, bulky, rigid, nonpolar ligands.

Microcystin-LR is at the friendly end of cyanotoxins — large, with a real hydrophobic handle — but it is still a frontier problem. **Most designs will fail. That is expected and it is not what you are graded on.**

Required reading before you open a model: An *et al.*, *Science* **385**:276–282 (2024).

---

## The brief

> Design a de novo protein that binds microcystin-LR in a buried, shape-complementary pocket targeting the conserved Adda face — and that is built to become a sensor.

### Hard constraints

- Buried, shape-complementary pocket. Report computed shape complementarity and buried surface area.
- **No cysteine near the ligand.** Mdha is electrophilic; a covalent binder is irreversible and useless in a reusable sensor.
- Stable and soluble in *E. coli*, no disulfides.
- Leave a terminus and a surface free where signal output can later be attached or the protein split. Retrofitting this is much harder than planning for it.

### The specificity decision

Microcystins vary at two positions; Adda, D-Glu and the ring backbone are conserved.

- **Target the conserved face** → broad microcystin detection, probably cross-reacting with nodularin. Matches how the guideline value is written.
- **Target the variable positions** → congener resolution, but you miss the toxin when the bloom switches producer.

Either is defensible. State which you chose and why. An accident of which pocket your model liked is not a decision.

---

## Deliverable

Three designs per team, in `submissions/<team-name>/`:

```
03_submissions/<team-name>/
├── designs.csv          # design_id, sequence, rank, method
├── structures/          # <design_id>.pdb — complex with the ligand modelled
├── metrics.csv          # every metric you scored on
└── RATIONALE.md         # why these three, in this order, plus your specificity intent
```

---

## Pipeline

**All-atom methods only.** Protein-binder pipelines built around protein targets will not help you here.

```
research → brainstorm → model choice → design → score → repeat
```

| Stage | Tools |
|---|---|
| Backbone | RFdiffusion3, RoseTTAFold All-Atom, pseudocycle scaffolds |
| Sequence / pocket | LigandMPNN, CARBonAra |
| Structure | AlphaFold 3 (with ligand), Boltz |
| Full pipeline | BoltzGen (ligand affinity module) |
| Interface analysis | PeSTo |

Expect to spend most of your time in the score → repeat loop, and to need far more sampling than a protein target would require.

Reference pipelines: `root/pipelines/`

---

## Validation

Binding is not sensing, and at 995 Da there is no sandwich assay available — there is no room for two proteins to hold the target at once. **Detection has to be competitive.**

1. **nanoDSF ± ligand** — cheapest first evidence of binding. Triage tool, not a verdict.
2. **MST** — affinity. Tolerates a scarce, expensive, hazardous ligand better than ITC or SPR.
3. **Competitive displacement** — a fluorescent toxin analogue sits in your pocket; real toxin displaces it and the signal falls. Gives an IC50.
4. **Lake water** — congener panel, matrix panel, spike-and-recovery, benchmark against a commercial ELISA.

Full protocol, controls and pitfalls in the Part 2 lecture deck (`see shared google drive`).

**Note the inverted signal.** Signal goes *down* as toxin goes up. Teams misread their first plate roughly every time.

---

## ⚠️ Safety

**These are real toxins. Read this before ordering anything.**

Microcystin-LR is a potent hepatotoxin and is regarded as possibly carcinogenic. Anatoxin-a, if any team works on it, is a fast-acting neurotoxin.

Before any reagent is ordered:

- A **written risk assessment**, approved by the institutional chemical-safety officer, naming compound, quantities, handling steps and waste route
- **Direct supervision** for anyone handling stock solutions
- Work only with dilute certified standards in solution. **No weighing of dry toxin by students.**
- Gloves, coat, eye protection, fume hood, no aerosols, dedicated pipettes, defined decontamination and waste procedure

**The workflow is deliberately designed to minimise exposure.** Expression, QC, thermal-shift triage and tracer validation need little or no toxin. One trained person under supervision prepares every dilution for the whole cohort; teams receive working dilutions or ready-made plates.

---

## Key references

1. WHO. *Cyanobacterial toxins: microcystin-LR in drinking-water* — background document for the WHO Guidelines for Drinking-water Quality. Provisional guideline value 1 µg/L total MC-LR.
2. Chorus I, Welch J (eds). *Toxic Cyanobacteria in Water*, 2nd ed. WHO / CRC Press (2021). Alert Level Framework.
3. Goldberg J, Huang HB, Kwon YG, Greengard P, Nairn AC, Kuriyan J. Three-dimensional structure of the catalytic subunit of protein serine/threonine phosphatase-1. *Nature* **376**:745–753 (1995). — PDB 1FJM.
4. *Crystal structures of protein phosphatase-1 bound to motuporin and dihydromicrocystin-LA.* J Mol Biol (2006). — Adda in the hydrophobic groove.
5. Pereira SR, *et al.* Computational study of the covalent bonding of microcystins to cysteine residues. *FEBS J* (2013). — Mdha7 to Cys273.
6. An L, *et al.* Binding and sensing diverse small molecules using shape-complementary pseudocycles. *Science* **385**:276–282 (2024). doi:10.1126/science.adn3780
7. Quijano-Rubio A, *et al.* De novo design of modular and tunable protein biosensors. *Nature* **591**:482–487 (2021). — binder → sensor.
8. Krishna R, *et al.* Generalized biomolecular modeling and design with RoseTTAFold All-Atom. *Science* **384**:eadl2528 (2024).

Full reference lists are on the final slides of both lecture decks in `the shared google drive`.

---

## Timeline

<!-- TODO: fix dates before publishing -->

| | |
|---|---|
| Kickoff lecture I | `29.09.2026` |
| Kickoff lecture II | `01.10.2026` |
| Kickoff lecture III | `06.10.2026` |
| Computational phase | `10-2026  -->  30-01-2027` |
| Submission deadline | `30-01-2027` |
| Wet-lab week | `TBD` |
| Results and write-up | `TBD, 05-2027` |

---

## Contact

<!-- TODO: fill in before publishing -->
- Projects coordinator: `Tolga Semiz (tolga.semiz@epfl.ch)`
- Dry Lab coach: `Tuna Karasu (tuna.karasu@epfl.ch)`
- Challenge coordinator & protein design coach: `Emma Castelli (emma@captuee.ch)` `--> disponible usually only once a week max, use her contact as last resource :((`

---

*Part of the [DLAI Binder Challenge](../../README.md). Run by DLAI at EPFL.*

*Made with love by Emma*
