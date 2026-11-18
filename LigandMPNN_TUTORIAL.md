This tutorial is for LigandMPNN.

Replace `<gaspar>` with your EPFL username, `gXX` with your group number, `FOLDER_NAME` with the name of the folder that you want to have the outputs in and `<your_project>` with your chosen project directory name throughout 

## Generate Amino Acid sequence with ligandMpnn 

This step runs LigandMPNN on the PD-L1 example input to confirm the container, weights, and storage mounts all work. This guide will use a python script to convert all cif.gz/.cif outputs of rfd3 inside this container, you can use that code anywhere. 

### Submit the job

```bash
runai submit mpnn-testin \
  -i registry.rcp.epfl.ch/proteindesign-containers/ligandmpnn:2026.1 \
  --interactive --attach --node-pools default -g 1 \
  --existing-pvc claimname=make-dlai-scratch-g02,path=/scratch \
  --existing-pvc claimname=make-dlai-shared-ro,path=/shared \
--command -- /bin/bash 
```

### Inside the container

Convert .cif/.cif.gz files to pdb format.

```bash
python /shared/usefull_code/transformer.py /scratch/path/to/rfd3/outputs /scratch/pdb/output/path #rfd3 output file should be the file that contains the .cif/.cif.gz files.

#example usage
python /shared/usefull_code/transformer.py /scratch/rfd3-examples/out /scratch/pdb_for_mpnn
```

Run the ligandMPNN:
This code will run ligandMPNN on all .pdb files on the give directory.

```bash
for PDB in /scratch/path/to/converted/pdb*.pdb; do #path to file that contains the pdbs
  BASENAME=$(basename "$PDB" .pdb)
  python /opt/LigandMPNN/run.py \
    --model_type "protein_mpnn" \
    --checkpoint_protein_mpnn /opt/LigandMPNN/model_params/proteinmpnn_v_48_020.pt \
    --pdb_path "$PDB" \
    --out_folder /scratch/ligandmpnn/output/${BASENAME} \ #output folder path
    --number_of_batches 1 \
    --batch_size 8
done
```

> More guides and details about LigandMPNN can be found online, if you want to use something other than protein_mpnn make your changes according to https://github.com/dauparas/LigandMPNN.

> After this step you have to valide your amino acid sequences by AlphaFold or your tool of choise. A guide on these will come soon.
> For the moment you can use https://alphafoldserver.com/ to valide your designs. It is always good to valide the designs one by one while you are still experimenting with the tools to better understand them.

Adapted from: [Protein Design Week – RCP Example](https://github.com/ghassanabboud/protein-design-week/blob/main/RCP/EXAMPLE.md)

*Developed by [Benedikt Singer](mailto:benedikt.singer@epfl.ch) with [Claude Opus 4.6](https://www.anthropic.com) (Anthropic).*