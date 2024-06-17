{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    conda
    podman-compose
    texliveFull
    mani
    latexit
  ];

  home.file."${config.folders.projects}/mani.yaml".text = ''
    projects:
      simg:
        path: julia/SeismicImagingTools.jl
        url: git@github.com:AtilaSaraiva/SeismicImagingTools.jl.git
        desc: Seismic inversion framework
        tags: [ julia, seismic ]

      seqcomp:
        path: julia/SequentialCompression.jl
        url: git@github.com:AtilaSaraiva/SequentialCompression.jl.git
        tags: [ julia, compression ]

      pinnlab:
        path: julia/PinnLab.jl
        url: git@github.com:AtilaSaraiva/PinnLab.jl.git
        desc: PINN modeling/inversion framework
        tags: [ julia, pinn ]

      seismakie:
        path: julia/SeisMakie.jl
        url: git@github.com:AtilaSaraiva/SeisMakie.jl.git
        tags: [ julia, plotting ]

      seisprocessing:
        path: julia/SeisProcessing.jl
        url: git@github.com:AtilaSaraiva/SeisProcessing.jl.git
        tags: [ julia, seismic ]

      seismain:
        path: julia/SeisMain.jl
        url: git@github.com:AtilaSaraiva/SeisMain.jl.git
        tags: [ julia, seismic ]

      seisreconstruction:
        path: julia/SeisReconstruction.jl
        url: git@github.com:AtilaSaraiva/SeisReconstruction.jl.git
        tags: [ julia, seismic ]

    specs:
      custom:
        output: table
        parallel: true

    targets:
      all:
        all: true

    themes:
      custom:
        table:
          options:
            draw_border: true
            separate_columns: true
            separate_header: true
            separate_rows: true

    tasks:
      st:
        desc: show working tree status
        spec: custom
        target: all
        theme: custom
        cmd: git status -s

      last-commit-msg:
        desc: show last commit
        cmd: git log -1 --pretty=%B

      last-commit-date:
        desc: show last commit date
        cmd: |
          git log -1 --format="%cd (%cr)" -n 1 --date=format:"%d  %b %y" \
          | sed 's/ //'

      branch:
        desc: show current git branch
        cmd: git rev-parse --abbrev-ref HEAD

      overview:
        desc: show branch, local and remote diffs, last commit and date
        spec: custom
        target: all
        theme: custom
        commands:
          - task: branch
          - task: last-commit-msg
          - task: last-commit-date
  '';
}
