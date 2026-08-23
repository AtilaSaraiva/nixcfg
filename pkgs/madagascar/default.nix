{
  lib,
  stdenv,
  fetchFromGitHub,
  # build tools
  python3,
  scons,
  swig,
  # X11 / graphics
  libx11,
  libxaw,
  libxt,
  libxext,
  libxmu,
  libGL,
  libGLU,
  freeglut,
  # image / video codecs
  netpbm,
  libtiff,
  gd,
  libjpeg,
  cairo,
  ffmpeg,
  # numerics
  blas,
  lapack,
  fftw,
  fftwFloat,
  suitesparse,
  # misc
  libtirpc,
  libtool,
  plplot,
  # optional features
  withX11 ? true,
  withOpenGL ? true,
  withFfmpeg ? true,
  withPlplot ? true,
  withSuitesparse ? true,
  withMPI ? false,
  mpi,
}: let
  py = python3.withPackages (ps: with ps; [numpy setuptools]);

  # Madagascar's SCons "configure" only probes a hard-coded list of FHS
  # directories (/usr/include/netpbm, /usr/include/cairo, ...), so on NixOS
  # every optional dependency is reported missing. Every one of those probes
  # can be short-circuited by handing it the path directly as a SCons
  # variable, which is what this list does. Everything else (plain -I/-L for
  # the store paths) is already taken care of by the cc/ld wrappers.
  sconsFlags =
    [
      "RSFROOT=${placeholder "out"}"
      "API=c++,python"
      # librsf uses XDR for the "xdr" data format; glibc dropped Sun RPC, so
      # point the probe at libtirpc instead.
      "CPPPATH=${lib.getDev libtirpc}/include/tirpc"
      "LIBS=tirpc"
      "PPMPATH=${lib.getDev netpbm}/include/netpbm"
      "CAIROPATH=${lib.getDev cairo}/include/cairo"
    ]
    ++ lib.optionals withX11 [
      # The probe insists on finding X11/Xaw/Label.h under XINC and on XLIBPATH
      # being a real directory; the remaining X headers/libs come from the
      # wrappers.
      "XINC=${lib.getDev libxaw}/include"
      "XLIBPATH=${lib.getLib libxaw}/lib"
      "XLIBS=Xaw,Xt,X11"
    ]
    ++ lib.optionals withPlplot [
      "PLPLOTPATH=${lib.getDev plplot}/include/plplot"
      "PLPLOTLIBPATH=${lib.getLib plplot}/lib"
    ]
    ++ lib.optionals withFfmpeg [
      "FFMPEGPATH=${lib.getDev ffmpeg}/include/libavcodec"
    ]
    ++ lib.optionals withSuitesparse [
      "SPARSEPATH=${lib.getDev suitesparse}/include"
    ]
    ++ lib.optionals withMPI [
      # openmpi ships the compiler wrappers in its dev output and only the
      # launchers in out; getting this wrong makes the MPI probe fail quietly
      # and every sfmpi* program installs as a "not installed" stub.
      "MPICC=${lib.getDev mpi}/bin/mpicc"
      "MPICXX=${lib.getDev mpi}/bin/mpicxx"
      "MPIRUN=${lib.getBin mpi}/bin/mpirun"
    ];
in
  stdenv.mkDerivation {
    pname = "madagascar";
    version = "4.3-unstable-2026-06-19";

    src = fetchFromGitHub {
      owner = "ahay";
      repo = "src";
      rev = "b38dcc180f25b061e54a19e6a0d135e9103245b2";
      hash = "sha256-2s81mleWgqTTXG8iS9e3xX7SUvF8j8pXJMz5ZWu/5gQ=";
    };

    strictDeps = true;

    # A lot of the contributed programs under user/ are pre-C99 sloppy about
    # types; GCC 14 turned those diagnostics into errors by default.
    env.NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=implicit-int"
      "-Wno-error=int-conversion"
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=return-mismatch"
      "-Wno-error=declaration-missing-parameter-type"
    ];

    nativeBuildInputs = [
      py
      scons
      swig
      python3.pkgs.wrapPython
    ];

    buildInputs =
      [
        py
        libtirpc
        libtiff
        gd
        libjpeg
        cairo
        netpbm
        blas
        lapack
        fftw
        fftwFloat
      ]
      ++ lib.optionals withX11 [
        libx11
        libxaw
        libxt
        libxext
        libxmu
      ]
      ++ lib.optionals withOpenGL [libGL libGLU freeglut]
      ++ lib.optionals withFfmpeg [ffmpeg]
      ++ lib.optionals withPlplot [plplot libtool]
      ++ lib.optionals withSuitesparse [suitesparse]
      ++ lib.optionals withMPI [mpi];

    postPatch = ''
      # SCons starts subprocesses with a scrubbed environment whose PATH is the
      # FHS default, so neither the compiler nor NIX_CFLAGS_COMPILE/NIX_LDFLAGS
      # reach the toolchain.  Inherit the real environment, but only the
      # variables the toolchain needs: SConstruct saves env['ENV'] verbatim into
      # the config.py it installs, and any value containing a '$' -- every nix
      # phase script, for one -- makes SCons' variable substitution blow up.
      substituteInPlace SConstruct \
        --replace-fail "env = Environment()" \
                       "env = Environment(ENV=dict((k,v) for k,v in os.environ.items() if k.startswith('NIX_') or k in ('PATH','HOME','TMPDIR','TMP','TEMP','TEMPDIR','TERM','LANG','LC_ALL','LD_LIBRARY_PATH','PYTHONPATH','PYTHONHASHSEED','SOURCE_DATE_EPOCH')))"

      # rsf.proj hands user projects the ENV that was baked into config.py at
      # build time, which on nix means not a single sf* program is on PATH.
      # Take the caller's PATH instead.
      substituteInPlace framework/rsf/proj.py \
        --replace-fail "        self.hostname = socket.gethostname()" \
                       "        self['ENV']['PATH'] = os.environ.get('PATH') or self['ENV'].get('PATH') or '/bin'; self.hostname = socket.gethostname()"

      # distutils is gone as of Python 3.12.
      substituteInPlace api/python/SConstruct \
        --replace-fail "import distutils.sysconfig" "import sysconfig" \
        --replace-fail "distutils.sysconfig.get_python_inc()" "sysconfig.get_paths()['include']"

      # Let SPARSEPATH= be honoured instead of only the FHS candidates.
      substituteInPlace framework/configure.py \
        --replace-fail "    for sparsepath in ['/usr/include/suitesparse'," \
                       "    for sparsepath in [context.env.get('SPARSEPATH') or '/usr/include/suitesparse',"

      patchShebangs framework/setenv.py
    '';

    configurePhase = ''
      runHook preConfigure

      export HOME="$TMPDIR"
      export RSFROOT="$out"
      scons config ${lib.escapeShellArgs sconsFlags}

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      scons -j''${NIX_BUILD_CORES:-1}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      scons -j''${NIX_BUILD_CORES:-1} install

      runHook postInstall
    '';

    postInstall = ''
      # config.py is re-read by every user project through rsf.conf.set_options,
      # so strip the build sandbox (TMPDIR, HOME, the wrapper's NIX_* flags) out
      # of the environment it carries.
      sed -i "s|^ENV = .*|ENV = {'PATH': '$out/bin'}|" \
        $out/share/madagascar/etc/config.py

      # sfdoc is the one script whose shebang SConstruct bakes in from
      # sys.executable, i.e. the interpreter SCons happens to run under.
      sed -i "1s|^#!.*|#!${py.interpreter}|" $out/bin/sfdoc
    '';

    # Most of $out/bin is C, but the RSF Python package (rsf.*) backs sfdoc,
    # sftour, scons2jupyter and every user-written SConstruct.  pscons shells
    # out to scons, so keep one on PATH.
    makeWrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [scons])];

    postFixup = ''
      wrapPythonPrograms

      # The build only drops legacy py2-style "foo.pyc" next to "foo.py", which
      # python3 ignores; without a real __pycache__ every sfdoc/vpconvert run
      # re-parses a few hundred generated modules (spewing their SyntaxWarnings)
      # since it cannot write bytecode back into the store.  This has to run
      # after fixupPhase, whose patchShebangs rewrites the sources in place, and
      # needs checked-hash because fixupPhase also resets every mtime.
      ${py.interpreter} -m compileall -q -f --invalidation-mode checked-hash \
        $out/${python3.sitePackages} > /dev/null || true
    '';

    meta = {
      description = "Multidimensional data analysis and reproducible computational experiments";
      longDescription = ''
        Madagascar is an open-source software package for geophysical (and
        general multidimensional) data processing.  It provides several hundred
        "sf*" programs operating on the self-describing RSF data format, a
        C/C++/Fortran/Python API, and an SCons-based framework for reproducible
        numerical experiments.
      '';
      homepage = "https://www.ahay.org/";
      license = lib.licenses.gpl2Plus;
      platforms = lib.platforms.linux;
      mainProgram = "sfdoc";
    };
  }
