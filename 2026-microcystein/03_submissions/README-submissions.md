# Submissions

Everything your team hands in goes here, in **one folder per team**.

Read the whole page before you start assembling. Most rejected submissions fail on naming or a missing rationale, not on science.

### Each team needs to have a team leader. That person is the person of contact for the DLAI team manager.

---

## Deadlines

<!-- TODO: fill in before the edition opens -->

| Milestone | Date |
|---|---|
| Team registration (folder created, `team.yml` filled) | `6-10-2026` |
| Intent to submit — target face + method declared | `TODO` |
| **Design submission deadline** | `30-01-2027` |
| Late window (flagged, still reviewed, not eligible for bench) | `10-02-2027` |
| Selection announced — which designs go to the bench | `15-02-2027` |
| Wet-lab week | `TBD` |
| Final write-up due | `05-2027` |

> The design deadline is the one that matters. Designs arriving after it can still be reviewed, but the gene order goes out on that date and anything late misses the bench entirely.

---

## Folder structure

```
submissions/
└── <team-name>/
    ├── team.yml
    ├── designs.csv
    ├── metrics.csv
    ├── structures/
    │   ├── <design_id>.pdb
    │   ├── <design_id>.pdb
    │   └── <design_id>.pdb
    └── RATIONALE.md
```

`<team-name>` — lowercase, hyphens, no spaces or accents. Example: `team-adda`.

**Three designs.**

---

## `team.yml`

```yaml
team: team-name
team-leader: Full Name
members:
  - name: Full Name
    email: name@epfl.ch
  - name: Full Name
    email: name@epfl.ch
contact: name@epfl.ch     # team leader
```

---

## `designs.csv`

One row per design. Header exactly as below.

```csv
design_id,rank,sequence,length,method,target_face,notes
```

| Column | Spec |
|---|---|
| `design_id` | `<team-name>_d1`, `_d2`, `_d3`. Nothing else. This string is the key to everything else. |
| `rank` | `1`, `2`, `3`. Your own ordering — 1 is the one you most believe in. No ties. |
| `sequence` | Single-letter amino acids, uppercase, no spaces, no tags. The construct-ready sequence. |
| `length` | Integer. Must match `sequence`. |
| `method` | Free text, one line. e.g. `RFdiffusion3 + LigandMPNN + AF3` |
| `target_face` | Which part of the target you aimed at. e.g. `Adda + conserved ring` |
| `notes` | Optional, one line. |

Do not include purification tags in `sequence` — we add those consistently across all submissions.

---

## `metrics.csv`

Long format, so teams using different tools can still be compared.

```csv
design_id,metric,value,tool
team-name_d1,shape_complementarity,0.71,rosetta
team-name_d1,buried_sasa,612,freesasa
team-name_d1,iptm,0.84,af3
team-name_d1,ligand_rmsd,1.2,af3
```

Report **every metric you actually used to filter**, including ones that made a design look bad. A metrics file containing only flattering numbers is worse than no metrics file — it tells us your filtering was post-hoc.

---

## `structures/`

One `.pdb` per design, named `<design_id>.pdb` — exactly matching `designs.csv`.

Each file must contain **the complex**: your designed protein *and* the target, in the predicted bound pose. A binder alone is not a submission.

- Chain A — your design
- Chain B / HETATM — the target

If you have a higher-confidence model from a second method, add it as `<design_id>_alt.pdb` and say which is primary in `RATIONALE.md`.

---

## `RATIONALE.md`

The part that gets read most carefully. Aim for one page.

Required sections:

```markdown
## Target face
Which part of the target you went for, and why.

## Approach
Pipeline and the reasoning behind choosing it. What you tried that didn't work.

## Filtering
What you generated, what you cut, on what evidence, and where you set thresholds.

## The three
Why each one, and why in this rank order.

## What would prove us wrong
What result would tell you your reasoning was mistaken.
```

That last section is not optional and not a formality. It is written before you have any data, and it is the main thing separating a team that reasoned from a team that sorted a column.

---

## Before you open the pull request

- [ ] Exactly three designs
- [ ] `design_id` identical across `designs.csv`, `metrics.csv` and `structures/`
- [ ] `length` matches `sequence` for every row
- [ ] No tags, no `X`, no non-standard residues in `sequence`
- [ ] Every `.pdb` contains both the design and the target
- [ ] Constraints from the edition brief respected — check them one by one
- [ ] `RATIONALE.md` has all five sections filled
- [ ] `team.yml` has a contact who reads their email

---

## How to submit

1. Fork the repository
2. Create `submissions/<team-name>/`
3. Open a pull request titled `Submission: <team-name>`
4. Fix anything the automated checks flag

**If you do not manage to fork the repository, you can directly submit your submission folder "team-name" via email @ dlai@epfl.ch**

just keep in mind that if you fork the repository early it's easier for us to access your work and coach you throughout the design proces before submission.

Automated checks run on every pull request and verify structure, naming and internal consistency only. **They do not check whether your designs are any good, and passing them is not a review.**

Edits are allowed up to the deadline. After it, the branch is frozen.

---

## Questions

Ask in the challenge channel rather than by email — if you are confused about the format, three other teams are too.

<!-- TODO: channel link -->
