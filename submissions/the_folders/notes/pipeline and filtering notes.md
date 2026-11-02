# Ideas to think with the team on the pipeline and filtering

Backbone scaffolds can be generated around the MC-LR ligand by two routes in parallel:
 RFdiffusion3, which builds a protein around the ligand and is filtered afterwards for the Adda pocket apparently it is easier to do and i found a bunch of youtube tutorials for this.We need to make sure our settings and the ligand face we chose are good cause each design takes like a minute and we need thousands :/
 
 <https://www.youtube.com/watch?v=6imf4vFmtbo> //RFDiffusion tuto
 RFD3:(Preparing the PDB file to use as input to RFD3 -> Creating a configuration file (JSON or YAML) to guide the diffusion process -> Choosing command line arguments to run RFD3)

Example of json file contents for RF3:

```{
    "test": {
    "input": "./pdl1_cropped.pdb",
    "contig": "55-88,/0,B1-114",
    "redesign_motif_sidechains": false,
    "infer_ori_strategy": "hotspots",
    "is_non_loopy": true,
    "select_hotspots":
            {"B37":  "CB,CD1,CG1",
            "B39": "CD1,CD2,CE1,CE2,CG,CZ,OH",
            "B51": "CG1,CG2,CB",
            "B52": "CE1,CD2,ND1,NE2,CB,CG",
            "B98": "CB,CE,CG,SD",
            "B100": "OG,CB"},
    "select_hbond_donor":
            {"B39": "OH",
            "B52": "ND1,NE2"}
 }
}```

RFD3 is also capable of designing proteins that bind small molecules. Here are some inputs that could be useful:

    input: a PDB or CIF file that contains the small molecule

    ligand: the 3 letter code in the file that is the ligand to be bound

    length: how long the generated protein should be (can be a range)

    select_fixed_atoms: selecting which atoms in the ligand should be fixed to the coordinates in the PDB

    select_exposed: selecting which atoms in the ligand should not be buried in the designed protein (exposed to solvent)

    select_buried: selecting which atoms in the ligand should be buried in the designed protein


```rfd3 design \
out_dir="./pdl1_binder_outputs" \
inputs="./pdl1.yaml" \
n_batches=1 \
diffusion_batch_size=8 \
dump_trajectories=True``` example of running RF3 from the command line

rfd3 design: This is the main command that actually runs RFD3

out_dir: This is a required argument that specifies the relative path to where you want your outputs stored. If the directory does not already exist, RFD3 will create it. In this example our outputs will be saved in a directory called pdl1_binder_outputs that will be created in your current working directory.

inputs: This is the relative path and file name for your input YAML or JSON file. The command above assumes that the YAML file we created for the PDL1 example is in your current working directory.

n_batches: RFD3 will run your designs in batches. The higher the number of batches, the more diversity your designs will have. Note that all designs in a single batch will have the same length.

diffusion_batch_size: The number of designs in each batch. Larger batch sizes are more efficient, but your results will be less diverse than generating the same total number of designs with smaller batches.

dump_trajectories: If True, then the trajectories created during the RFD3 design process are saved. These are not necessary for the assessment of your designs, but can be useful for visualization purposes. In general, we recommend leaving this set to the default value of False because the trajectory file sizes can be large.

and we can maybe do shape-complementary pseudocycles in parallel, where the ligand is docked into pre-formed pockets, but it seems to be a lot more work since we need AF2 to hallucinate scaffolds then redesign those to make them soluble and its a lot of unusable scaffolds. They put a paper on it so its interesting to look into it more. But yeah RFDiffusion is pretty solid imo.

Both routes should output the same file format (PDB) tho and pass through one shared downstream pipeline: geometric filtering of the pocket we can check Hbonds and salt bridges etc using Pymol.  And we need to choose the filtering options, and use LigandMPNN sequence design with cysteine excluded (cause of the covalent bonds i think its best to not have any) and also other exclusions and inclusions based on the biochemistry and interactionss, and we should structure prediction of each sequence with and without ligand using at least two independent predictors. Surviving designs has to be reefined by sequence redesign or partial diffusion and then revalidated. Theres a lot of program choices that i will go through and create pros and cons lists of.
