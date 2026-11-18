This tutorial is for RFD3.

Replace `<gaspar>` with your EPFL username, `gXX` with your group number, `FOLDER_NAME` with the name of the folder that you want to have the outputs in and `<your_project>` with your chosen project directory name throughout.

A pipeline with rfd3 can be rfd3->proteinmpnn->alphafold validation. After rfd3 step you can continue with ligandmpnn.

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
> Modify the diffusion_batch_size as you wish, 1 is given for the test run 8 is the default.
> The input file `pdl1_test.json` defines the PD-L1 binder design task.
> To try an unconditional design instead, point `inputs=` to your own JSON
> (e.g. `{"uncond_monomer": {"dialect": 2, "length": "80-100"}}`).
> You can find excellent tutorials for RFD3 on the internet.

> RFD3 outputs `.cif.gz` files, but LigandMPNN and CARBonAra expect `.pdb` files.
> More details on how to do the conversion is on the LigandMPNN_tutorial. 

Adapted from: [Protein Design Week – RCP Example](https://github.com/ghassanabboud/protein-design-week/blob/main/RCP/EXAMPLE.md)

*Developed by [Benedikt Singer](mailto:benedikt.singer@epfl.ch) with [Claude Opus 4.6](https://www.anthropic.com) (Anthropic).*
