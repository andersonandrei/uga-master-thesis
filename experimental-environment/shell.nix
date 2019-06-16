{
  useClang ? true,
  kapack ? import
    (builtins.fetchTarball {
      url = "https://github.com/oar-team/kapack/archive/master.tar.gz";
    }) {}
}:
let
    simgrid = kapack.simgrid_temperature.overrideAttrs (oldAttrs: {
      src = fetchGit {
        url = https://framagit.org/simgrid/simgrid.git;
        rev = "52fa9e20e056119074cd759141021286786655c5";
        ref = "master";
      };
      doCheck = false;
    });

    batsim = (kapack.batsim300.override (
      { inherit simgrid; } //
      kapack.pkgs.stdenv.lib.optionalAttrs useClang { stdenv = kapack.pkgs.clangStdenv; }
    )).overrideAttrs (oldAttrs: {
      src = fetchGit {
        url = https://gitlab.inria.fr/batsim/batsim.git;
        rev = "b663214ab70011c78ef25732e63cf984f01921e9";
        ref = "temperature";
      };
      doCheck = false;
    });

    pybatsim = kapack.pybatsim_dev.overrideAttrs (oldAttrs: {
      src = fetchGit {
        url = https://gitlab.inria.fr/batsim/pybatsim.git;
        rev = "c61b630d7a12f3ef175029f41c97bd794ba872e4";
        ref = "temperature";
      };
      #meta = oldAttrs.meta;
    });

in
kapack.pkgs.mkShell
{
  buildInputs = [
    batsim
    pybatsim
    kapack.batexpe
  ];
}
