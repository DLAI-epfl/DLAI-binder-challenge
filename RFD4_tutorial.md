## Generate Scaffolds with RFD3

This step runs RFD4 on the PD-L1 example input to confirm the container, weights, and storage mounts all work.

### Submit the job

```bash
runai submit --name JOB_NAME\
  -i registry.rcp.epfl.ch/dlai-rfd4/rfd4:modif \
  --interactive \
  -g 1 \
  --node-pools a100-40g \
  --existing-pvc claimname=make-dlai-scratch-g{gorup number},path=/scratch \
  --existing-pvc claimname=make-dlai-shared-ro,path=/shared \
  --command -- sleep infinity

```
> Be careful not to overload the a100s: if a group has 0 a100s and other groups have 3 in use, one of the 3 will get cancelled. We have 35 a100s for ~20 groups.


### Inside the container

```bash
rfd4-generate \
  inputs=/shared/examples/rfd4-examples/pdl1.yaml \
  hf_ckpt_path=/shared/weights/hub/models--nvidia--RFD4-Proteina/snapshots/5ec66c399bf0b48727ab24e6b298dcf33864fa07 \
  num_replicates=1 \
  out_dir=/scratch/path/to/output/ \
  compile_lengths=null

exit
```
> Modify the num_replicates as you wish, 1 is given for the test. For bigger num_replicates delete the compile_lengths argument.
> The input file `pdl1.yaml` defines the PD-L1 binder design task.
> To try an unconditional design instead, point `inputs=` to your own YAML

>RFD4 will output cif files, you can refold and check using af3 server. The RFD4 refolding is not setup in the cluster.

> Check the wiki for more details https://github.com/RosettaCommons/RFD4-Proteina.
