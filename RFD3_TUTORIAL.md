This tutorial is for RFD3.

Replace `<gaspar>` with your EPFL username, `gXX` with your group number, and `<your_project>` with your chosen project directory name throughout.

## Generate Scaffolds with RFD3

This step runs RFD3 on the PD-L1 example input to confirm the container, weights, and storage mounts all work.

### Submit the job

```bash
runai submit --name JOB_NAME \
  -i registry.rcp.epfl.ch/proteindesign-containers/rfd3:2026.1 \
  --interactive --attach \
  --node-pools default \
  -g 1 \
  --existing-pvc claimname=make-dlai-scratch-gXX,path=/scratch \
  --existing-pvc claimname=make-dlai-shared-ro,path=/shared \
  --command -- /bin/bash
```

### Inside the container

```bash
mkdir -p /scratch/make-dlai-scratch-gXX/rfd3

rfd3 design \
  out_dir=/scratch/FOLDER_NAME \
  inputs=/shared/examples/rfd3-examples/pdl1_test.json \
  ckpt_path=/shared/weights/rfd3-weights/rfd3_latest.ckpt \
  n_batches=1 \
  diffusion_batch_size=1

# Verify outputs (expect .cif.gz and .json files)
ls /scratch/FOLDER_NAME

exit
```

> The input file `pdl1_test.json` defines the PD-L1 binder design task.
> To try an unconditional design instead, point `inputs=` to your own JSON
> (e.g. `{"uncond_monomer": {"dialect": 2, "length": "80-100"}}`).
> You can find excellent tutorials for RFD3 on the internet.

---

> **Important — Preparing inputs for sequence optimization**
> RFD3 outputs `.cif.gz` files, but LigandMPNN and CARBonAra expect `.pdb` files.
> Before running Steps 2 or 3 you must:
> 1. Unzip the `.cif.gz` files from Step 1.
> 2. Convert the `.cif` files to `.pdb` (e.g. using `gemmi`).
> 3. Upload the `.pdb` files to the appropriate `input/` directories on scratch
>    (e.g. `/mnt/scratch/<your_project>/ligandmpnn/input/` and `/mnt/scratch/<your_project>/carbonara/input/`).

Adapted from: [Protein Design Week – RCP Example](https://github.com/ghassanabboud/protein-design-week/blob/main/RCP/EXAMPLE.md)

*Developed by [Benedikt Singer](mailto:benedikt.singer@epfl.ch) with [Claude Opus 4.6](https://www.anthropic.com) (Anthropic).*
