# DLAI Binder Challenge

**One target. One semester. Three designs per team. Every result published.**

An annual open design competition run by [DLAI — Designing Life with AI](https://designinglifewithai.ch) at EPFL. Each edition picks a single binding target, proposed together with a partner lab. Student teams design proteins against it computationally, the surviving designs go to the bench, and everything — hits and misses — ends up in this repository.

---

## Why this exists

Plenty of students have run RFdiffusion. Very few have held a tube containing something they designed.

The gap between those two things is where the real learning sits: choosing a target you can actually attack, deciding which face of it to bind, justifying a scoring threshold, and then finding out you were wrong.

The Binder Challenge, founded in 2026, exists to close that loop once a year, with a real target, a real partner lab, and real experimental validation. The objective is to create bioengineers that are fluent in both ML and molecular biology and not just preferentially one of the two.

It is not a hackathon. It runs across a whole year, and it ends with a winning team, and the chance to present their design at the annual Rosettacon.

---

## The format

These do not change between editions:

| | |
|---|---|
| **Target** | One per year, set with a partner lab. Always a real problem someone actually wants solved. |
| **Teams** | Small, mixed-experience. No prior protein design required. |
| **Deliverable** | Top three designs per team, ranked, each with a written justification. Top designs are then tested with a competition binder assay in the lab, and the best ones determine the winners.|
| **Rationale** | Your reasoning is submitted *before* any experimental data exists. |
| **Validation** | Computational filtering, then wet-lab testing of the designs that survive. |
| **Publication** | Every design is published and presented at demoday — including the ones that failed. |

### Three designs, not three hundred

You will generate thousands. Picking three and defending the choice is the exercise. A team that submits three designs with a clear, falsifiable argument has done the assignment. A team that submits three designs chosen by sorting a metric column has not.

### How teams are judged

**Not by hit rate.** De novo binder design fails most of the time, and small-molecule targets fail more than that. Ranking teams by experimental success would mostly rank them by luck.

Teams are judged on:

1. **Target reasoning** — did you understand the molecule before you designed against it?
2. **Method justification** — why this pipeline, these models, these parameters, this scaffold class?
3. **Filtering logic** — what did you cut, and on what evidence?
4. **Calibration** — did your stated confidence match what happened?

A well-argued failure beats a lucky success nobody can explain.

---

## Editions

| Year | Target | Partner | Status |
|------|--------|---------|--------|
| 2026 | Microcystin-LR (cyanotoxin) | GenoRobotics × Dal Peraro Lab | In progress |
| 2027 | TBA | TBA | Planned |
| 2028 | TBA | TBA | Planned |
| 2029 | TBA | TBA | Planned |

Each edition lives in `~/<year>-<target>/` with its own README, brief, docs, and results.

---

## Repository layout

```
DLAI-binder-challenge/
├── README.md                  # you are here
├── 00_useful-documents         # survival guides etc. 
├── year-target/      # brief, submissions, results for one edition
│       ├── README-2026.md
│       ├── 00_useful-reads/             # reading list
        ├── 01_workshop-series/         # workshop resources --> for full lectures checkout the drive
        ├── 02_structures/          # pdb files of target and examples
│       ├── 03_submissions/       # one folder per team
│       └── results/           # experimental data, once it exists
├── 01_starter/                   # shared pipeline scaffolding and notebooks
│   ├── env/                   # environment specs
│   ├── pipelines/             # reference design + scoring pipelines
|   ├── helper codes/          # useful code for your design campaign
│   └── scoring/               # metric extraction, filtering helpers
├── 02_docs/
│   ├── submission-format.md
│   └── judging.md
└── 
```

---

## Taking part

You do **not** need prior protein design experience. You do need to turn up consistently for a semester.

1. Watch for the edition announcement (start of the academic year)
2. Join or form a team
3. Work through the edition brief and the background lecture
4. Run the pipeline, iterate, and pick your three
5. Submit before the deadline
6. Come to the wet-lab week

Attendance to the three workshops at the beginning of the year is mandatory to be a DLAI member. Missing the wet-lab week is the one thing that makes this not work. Everything else is flexible.

---

## Submission format

One folder per team under the edition's `submissions/`:

```
submissions/<team-name>/
├── designs.csv          # design_id, sequence, rank, method
├── structures/          # <design_id>.pdb — predicted complex with the target
├── metrics.csv          # every metric you scored on, per design
└── RATIONALE.md         # why these three, and why in this order
```

`RATIONALE.md` is the part that gets read most carefully. Two or three paragraphs. What you targeted, why, what you rejected, and what would have to be true for your ranking to be correct. Min - 500 words, Max - 800 words

Full field definitions: `docs/submission-format.md`.

---

## Tooling

Editions differ, but the toolchain is broadly stable:

**Backbone** — RFdiffusion, RFdiffusion3, RoseTTAFold All-Atom
**Sequence** — ProteinMPNN, LigandMPNN, CARBonAra
**Structure** — AlphaFold 3, Boltz
**Full pipeline** — BindCraft, BoltzGen
**Interfaces** — PeSTo
**RNA scaffolds** — RISoTTo

Reference pipelines live in `starter/pipelines/`. You are not required to use them, but if you deviate, say so in your rationale.

---

## Data and licensing

Designed sequences, structures and experimental results are released openly so the dataset compounds across editions. A few years of published hits *and* misses on well-characterised targets is more useful to the field than any single winning design.

- Code: MIT
- Designs, data and documentation: property of MAKE EPFL

If you use the data, cite the edition.

---

## Safety

Every edition is reviewed for safety before launch, and some targets bring real handling requirements. Where an edition involves hazardous material, the edition README states it explicitly, and the safety case must be approved before any reagent is ordered. Do not skip that section because it looks like boilerplate.

---

## Contact

<!-- TODO: fill in before publishing -->
- Challenge coordination: `tolga.semiz@epfl.ch`
- Website: https://designinglifewithai.ch
- Questions about a specific edition: see that edition's README

---

*Made, with love, by Emma*
