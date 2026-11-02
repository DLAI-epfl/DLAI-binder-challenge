# Ideas to think with the team on the pipeline and filtering

Backbone scaffolds can be generated around the MC-LR ligand by two routes in parallel:
 RFdiffusion, which builds a protein around the ligand and is filtered afterwards for the Adda pocket apparently it is easier to do and i found a bunch of youtube tutorials for this.We need to make sure our settings and the ligand face we chose are good cause each design takes like a minute and we need thousands :/
 <https://www.youtube.com/watch?v=6imf4vFmtbo> //RFDiffusion tuto

and we can maybe do shape-complementary pseudocycles in parallel, where the ligand is docked into pre-formed pockets, but it seems to be a lot more work since we need AF2 to hallucinate scaffolds then redesign those to make them soluble and its a lot of unusable scaffolds. They put a paper on it so its interesting to look into it more. But yeah RFDiffusion is pretty solid imo.

Both routes should output the same file format (PDB) tho and pass through one shared downstream pipeline: geometric filtering of the pocket we can check Hbonds and salt bridges etc using Pymol.  And we need to choose the filtering options, and use LigandMPNN sequence design with cysteine excluded (cause of the covalent bonds i think its best to not have any) and also other exclusions and inclusions based on the biochemistry and interactionss, and we should structure prediction of each sequence with and without ligand using at least two independent predictors. Surviving designs has to be reefined by sequence redesign or partial diffusion and then revalidated. Theres a lot of program choices that i will go through and create pros and cons lists of.
