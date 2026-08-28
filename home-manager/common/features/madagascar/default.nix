{pkgs, ...}: {
  home = {
    packages = [pkgs.madagascar];

    # The Julia API (m8r.jl) finds librsf and RSFROOT on its own -- both are
    # baked into the store path at build time -- so the only thing that still
    # has to reach julia itself is the module search path.  The trailing colon
    # is an empty entry, which julia expands to its own defaults.
    #
    # DATAPATH is deliberately NOT set here.  RSF splits every dataset into a
    # text header and a binary blob, and DATAPATH decides where the blob goes;
    # the right value is per project, not per machine.  Set it in a devShell,
    # or drop a .datapath file in the project directory -- rsf.proj reads that
    # and it supports per-host entries:
    #
    #     juroscomposto datapath=/data/seismic/proj1/
    #     igris         datapath=/scratch/proj1/
    sessionVariables.JULIA_LOAD_PATH = "${pkgs.madagascar}/lib:";
  };
}
