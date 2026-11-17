# End-to-End Pipeline Example

This walks through the full pipeline: scaffold generation (RFD3) → sequence design (LigandMPNN / CARBonAra) → structure prediction (AF3 / Chai / Boltz) → local parsing & ranking.

Replace `<gaspar>` with your EPFL username, `gXX` with your group number, and `<your_project>` with your chosen project directory name throughout.

> **Note:** The companion `analysis.ipynb` notebook contains the same parsing/ranking logic with richer visualizations (scatter plots, RMSD, ipSAE). It ships pre-loaded with **sample data** under `test_pipeline_results/` — update `SAMPLE_DIR` at the top of the notebook to point at your own rsynced results before running.

> **Local environment setup (Steps 7+ and `analysis.ipynb`):**
> The parsers and notebook require Python ≥ 3.9 with a few dependencies (`gemmi`, `numpy`, `pandas`, `seaborn`).
> The repo is managed with [**uv**](https://docs.astral.sh/uv/) — install it once, then:
> ```bash
> # Install uv (if you don't have it yet)
> curl -LsSf https://astral.sh/uv/install.sh | sh
>
> # Create the virtualenv and install all dependencies
> uv sync
>
> # Run the notebook
> uv run jupyter lab analysis.ipynb
> ```
> If you prefer pip, `pip install .` in the repo root will also work.

> **Reminder:** You can only run **one interactive GPU job at a time** (1x A100 per user). Always `runai delete job <name>` before submitting the next step.

---

## Step 1: Generate Scaffolds with RFD3

### Submit the job

```bash
runai submit rfd3-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/rfd3:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /mnt/scratch/<your_project>/rfd3

cat > /mnt/scratch/<your_project>/rfd3/demo.json << 'EOF'
{
  "uncond_monomer": {
    "dialect": 2,
    "length": "80-100"
  }
}
EOF

rfd3 design \
  out_dir=/mnt/scratch/<your_project>/rfd3/out \
  inputs=/mnt/scratch/<your_project>/rfd3/demo.json \
  ckpt_path=${CKPT_PATH} \
  n_batches=1 \
  diffusion_batch_size=2

# Verify outputs (expect .cif.gz and .json files)
ls /mnt/scratch/<your_project>/rfd3/out/

exit
```

### Clean up and rsync results locally

```bash
runai delete job rfd3-gXX

mkdir -p ./<your_project>_results/rfd3
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/rfd3/out/ \
  ./<your_project>_results/rfd3/
```

---

> **Important — Preparing inputs for Steps 2 & 3:**
> RFD3 outputs `.cif.gz` files, but LigandMPNN and CARBonAra expect `.pdb` files.
> Before running Steps 2 or 3 you must:
> 1. Gunzip the `.cif.gz` files from Step 1.
> 2. Convert the `.cif` files to `.pdb` (e.g. using `gemmi` — see `analysis.ipynb` for an example).
> 3. Upload the `.pdb` files to the appropriate `input/` directories on scratch
>    (e.g. `/mnt/scratch/<your_project>/ligandmpnn/input/` and `/mnt/scratch/<your_project>/carbonara/input/`).

## Step 2: Sequence Design with LigandMPNN

### Submit the job

```bash
runai submit mpnn-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/ligandmpnn:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
cd /opt/LigandMPNN
mkdir -p /mnt/scratch/<your_project>/ligandmpnn

# Design sequences for each RFD3 scaffold
for PDB in /mnt/scratch/<your_project>/ligandmpnn/input/*.pdb; do
  BASENAME=$(basename "$PDB" .pdb)
  python run.py \
    --model_type "protein_mpnn" \
    --checkpoint_protein_mpnn /opt/LigandMPNN/model_params/proteinmpnn_v_48_020.pt \
    --pdb_path "$PDB" \
    --out_folder /mnt/scratch/<your_project>/ligandmpnn/output/${BASENAME} \
    --number_of_batches 1 \
    --batch_size 8
done

# Verify outputs (expect .fa files)
ls /mnt/scratch/<your_project>/ligandmpnn/output/*/seqs/

exit
```

### Clean up and rsync results locally

```bash
runai delete job mpnn-gXX

mkdir -p ./<your_project>_results/ligandmpnn
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/ligandmpnn/output/ \
  ./<your_project>_results/ligandmpnn/
```

---

## Step 3: Sequence Design with CARBonAra

### Submit the job

```bash
runai submit carb-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/carbonara:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /mnt/scratch/<your_project>/carbonara

# CARBonAra expects PDB files — use the ones converted during the LigandMPNN step
mkdir -p /mnt/scratch/<your_project>/carbonara/output

for PDB in /mnt/scratch/<your_project>/carbonara/input/*.pdb; do
  carbonara "$PDB" /mnt/scratch/<your_project>/carbonara/output
done

# Verify outputs (expect <scaffold>_<N>.fasta files)
ls /mnt/scratch/<your_project>/carbonara/output/

exit
```

### Clean up and rsync results locally

```bash
runai delete job carb-gXX

mkdir -p ./<your_project>_results/carbonara
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/carbonara/output/ \
  ./<your_project>_results/carbonara/
```

---

## Step 4: Structure Prediction with AlphaFold 3

### Submit the job

```bash
runai submit af3-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/af3:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /mnt/scratch/<your_project>/af3

# Helper: create an AF3 input JSON for a given SEQ_ID and SEQ
make_af3_input() {
  local SEQ_ID="$1" SEQ="$2"
  mkdir -p /mnt/scratch/<your_project>/af3/${SEQ_ID}
  cat > /mnt/scratch/<your_project>/af3/${SEQ_ID}/input.json << JSONEOF
{
  "name": "${SEQ_ID}",
  "dialect": "alphafold3",
  "version": 2,
  "modelSeeds": [42],
  "sequences": [
    {
      "protein": {
        "id": ["A"],
        "sequence": "${SEQ}",
        "unpairedMsa": "",
        "pairedMsa": "",
        "templates": []
      }
    }
  ]
}
JSONEOF
}

# Create AF3 inputs from LigandMPNN sequences
for FA in /mnt/scratch/<your_project>/ligandmpnn/output/*/seqs/*.fa; do
  SCAFFOLD=$(basename "$FA" .fa)
  SAMPLE=0
  while IFS= read -r HEADER && IFS= read -r SEQ; do
    make_af3_input "${SCAFFOLD}_seq${SAMPLE}" "$SEQ"
    SAMPLE=$((SAMPLE + 1))
  done < <(grep -A1 "^>" "$FA" | grep -v "^--$")
done

# Create AF3 inputs from CARBonAra sequences
for FA in /mnt/scratch/<your_project>/carbonara/output/*.fasta; do
  SEQ_ID=$(basename "$FA" .fasta)
  SEQ=$(grep -v "^>" "$FA" | tr -d '\n')
  make_af3_input "${SEQ_ID}" "$SEQ"
done

# Fold each sequence
# AF3 generates 5 diffusion samples per seed (seed-42_sample-{0..4}).
# The result parser picks the best ranking_score per sequence.
for SEQ_DIR in /mnt/scratch/<your_project>/af3/*/; do
  [ -f "${SEQ_DIR}input.json" ] || continue
  python /opt/alphafold3/run_alphafold.py \
    --json_path "${SEQ_DIR}input.json" \
    --model_dir /mnt/scratch/af3_weights \
    --output_dir "${SEQ_DIR}output" \
    --jax_compilation_cache_dir /mnt/scratch/af3_jax_cache \
    --norun_data_pipeline
done

# Verify outputs (expect *_summary_confidences.json, *_confidences.json, *_model.cif)
ls /mnt/scratch/<your_project>/af3/*/output/*/seed-*/

exit
```

### Clean up and rsync results locally

```bash
runai delete job af3-gXX

mkdir -p ./<your_project>_results/af3
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/af3/ \
  ./<your_project>_results/af3/
```

---

## Step 5: Structure Prediction with Chai

### Submit the job

```bash
runai submit chai-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/chai:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /mnt/scratch/<your_project>/chai

# Helper: create a Chai FASTA input for a given SEQ_ID and SEQ
make_chai_input() {
  local SEQ_ID="$1" SEQ="$2"
  mkdir -p /mnt/scratch/<your_project>/chai/${SEQ_ID}
  echo -e ">protein|name=${SEQ_ID}\n${SEQ}" \
    > /mnt/scratch/<your_project>/chai/${SEQ_ID}/input.fasta
}

# Create Chai inputs from LigandMPNN sequences
for FA in /mnt/scratch/<your_project>/ligandmpnn/output/*/seqs/*.fa; do
  SCAFFOLD=$(basename "$FA" .fa)
  SAMPLE=0
  while IFS= read -r HEADER && IFS= read -r SEQ; do
    make_chai_input "${SCAFFOLD}_seq${SAMPLE}" "$SEQ"
    SAMPLE=$((SAMPLE + 1))
  done < <(grep -A1 "^>" "$FA" | grep -v "^--$")
done

# Create Chai inputs from CARBonAra sequences
for FA in /mnt/scratch/<your_project>/carbonara/output/*.fasta; do
  SEQ_ID=$(basename "$FA" .fasta)
  SEQ=$(grep -v "^>" "$FA" | tr -d '\n')
  make_chai_input "${SEQ_ID}" "$SEQ"
done

# Fold each sequence
for SEQ_DIR in /mnt/scratch/<your_project>/chai/*/; do
  [ -f "${SEQ_DIR}input.fasta" ] || continue
  python3 << PYEOF
from pathlib import Path
from chai_lab.chai1 import run_inference

candidates = run_inference(
    fasta_file=Path("${SEQ_DIR}input.fasta"),
    output_dir=Path("${SEQ_DIR}output"),
    num_trunk_recycles=3,
    num_diffn_timesteps=200,
    seed=42,
)
PYEOF
done

# Verify outputs (expect scores.model_idx_*.npz and pred.model_idx_*.cif)
ls /mnt/scratch/<your_project>/chai/*/output/

exit
```

### Clean up and rsync results locally

```bash
runai delete job chai-gXX

mkdir -p ./<your_project>_results/chai
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/chai/ \
  ./<your_project>_results/chai/
```

---

## Step 6 (Optional): Structure Prediction with Boltz

### Submit the job

```bash
runai submit boltz-gXX \
  --project hackathon-proteindesign-<gaspar> \
  -i registry.rcp.epfl.ch/proteindesign-containers/boltz:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=hackathon-proteindesign-scratch-gXX,path=/mnt/scratch \
  --existing-pvc claimname=hackathon-proteindesign-shared-ro,path=/mnt/shared-ro \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /mnt/scratch/<your_project>/boltz

# Helper: create a Boltz YAML input for a given SEQ_ID and SEQ
make_boltz_input() {
  local SEQ_ID="$1" SEQ="$2"
  mkdir -p /mnt/scratch/<your_project>/boltz/${SEQ_ID}
  cat > /mnt/scratch/<your_project>/boltz/${SEQ_ID}/input.yaml << YAMLEOF
version: 1
sequences:
- protein:
    id: A
    sequence: ${SEQ}
YAMLEOF
}

# Create Boltz inputs from LigandMPNN sequences
for FA in /mnt/scratch/<your_project>/ligandmpnn/output/*/seqs/*.fa; do
  SCAFFOLD=$(basename "$FA" .fa)
  SAMPLE=0
  while IFS= read -r HEADER && IFS= read -r SEQ; do
    make_boltz_input "${SCAFFOLD}_seq${SAMPLE}" "$SEQ"
    SAMPLE=$((SAMPLE + 1))
  done < <(grep -A1 "^>" "$FA" | grep -v "^--$")
done

# Create Boltz inputs from CARBonAra sequences
for FA in /mnt/scratch/<your_project>/carbonara/output/*.fasta; do
  SEQ_ID=$(basename "$FA" .fasta)
  SEQ=$(grep -v "^>" "$FA" | tr -d '\n')
  make_boltz_input "${SEQ_ID}" "$SEQ"
done

# Predict each
for SEQ_DIR in /mnt/scratch/<your_project>/boltz/*/; do
  [ -f "${SEQ_DIR}input.yaml" ] || continue
  cd "$SEQ_DIR"
  boltz predict input.yaml
done

# Verify outputs (expect confidence_*_model_*.json and *.cif files)
ls /mnt/scratch/<your_project>/boltz/*/boltz_results_*/predictions/*/

exit
```

### Clean up and rsync results locally

```bash
runai delete job boltz-gXX

mkdir -p ./<your_project>_results/boltz
rsync -avP \
  <gaspar>@jumphost.rcp.epfl.ch:/mnt/hackathon-proteindesign/hackathon-proteindesign-gXX/scratch-gXX/<your_project>/boltz/ \
  ./<your_project>_results/boltz/
```

---

> **Important — Local directory naming:**
> The rsync commands above download results into `./<your_project>_results/`.
> Make sure the paths you pass to the result parsers (below and in `analysis.ipynb`) match
> where you actually rsynced the data. The notebook ships with `SAMPLE_DIR = "test_pipeline_results"`
> pointing at bundled sample data — update it to your own results directory before running.

## Step 7: Parse & Rank Everything Locally

```bash
cd <your_local_clone>

python3 << 'EOF'
from utils.result_parsers import (
    parse_rfd3_results,
    parse_ligandmpnn_results,
    parse_carbonara_results,
    parse_af3_results,
    parse_chai_results,
    parse_boltz_results,
    merge_results,
)

rfd3  = parse_rfd3_results("<your_project>_results/rfd3")
mpnn  = parse_ligandmpnn_results("<your_project>_results/ligandmpnn")
carb  = parse_carbonara_results("<your_project>_results/carbonara")
af3   = parse_af3_results("<your_project>_results/af3")
chai  = parse_chai_results("<your_project>_results/chai")
boltz = parse_boltz_results("<your_project>_results/boltz")

# Each parser returns one row per sequence (best prediction only).
# AF3, Chai, and Boltz may produce multiple samples/models per sequence;
# the parsers automatically keep the best one (by ranking_score,
# aggregate_score, and confidence_score respectively).
for name, df in [("rfd3", rfd3), ("mpnn", mpnn), ("carbonara", carb),
                  ("af3", af3), ("chai", chai), ("boltz", boltz)]:
    print(f"{name}: {len(df)} records")
    if len(df):
        print(df.head(), "\n")

# Merge sequence designs with structure-prediction scores
merged = merge_results(mpnn, af3_df=af3, chai_df=chai, boltz_df=boltz)
print(f"\nMerged: {len(merged)} designs, {len(merged.columns)} columns")
print(merged.sort_values("af3_ranking_score", ascending=False).head())

merged.to_csv("ranked_designs.csv", index=False)
print("\nSaved to ranked_designs.csv")
EOF
```

---

## Quick Reference

| Step | Tool | Image | What it produces |
|------|------|-------|-----------------|
| 1 | RFD3 | `rfd3:2026.1` | Scaffold backbones (`.cif.gz` + `.json`) |
| 2 | LigandMPNN | `ligandmpnn:2026.1` | Designed sequences (`.fa` FASTA files) |
| 3 | CARBonAra | `carbonara:2026.1` | Designed sequences (`<scaffold>_<N>.fasta` files) |
| 4 | AlphaFold 3 | `af3:2026.1` | Structure predictions (`*_summary_confidences.json`) |
| 5 | Chai | `chai:2026.1` | Structure predictions (`scores.model_idx_*.npz`) |
| 6 | Boltz | `boltz:2026.1` | Structure predictions (`confidence_*_model_*.json`) |
| 7 | Local | — | `ranked_designs.csv` |

---

## Disclaimer

Licensed under the [MIT License](LICENSE).

---

*Developed by [Benedikt Singer](mailto:benedikt.singer@epfl.ch) with [Claude Opus 4.6](https://www.anthropic.com) (Anthropic).*
