
For now you'll find a nix recipe to create an environment with everything you need to run easily an experiment with Batsim (simply execute `nix-shell shell.nix`, it may take some time to download/build everything).
Created also a little script to generate yaml files to describe an experiment (execute `python3 create-yaml.py -i 1day_26April_two_months -s qarnotNodeSched`, don't forget to update the paths of the sample-data and the path to this repo, + you'll need the jinja2 python module for that).

To run the previous steps and the experiments automatically:

chmod +x run-experiments.sh
nix-shell shell.nix
./run-experiments.sh
