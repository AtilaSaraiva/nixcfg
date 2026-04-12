{
  inputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # Or modules exported from other flakes (such as nix-colors):
    inputs.steamcmd-servers.nixosModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.steamcmd-servers.overlays.default
    ];
  };

  environment.systemPackages = [
    pkgs.steamcmd-ctl
  ];

  services.steamcmd-servers = {
    enable = true;
    openFirewall = true;

    servers = {
      pal = {
        enable = true;
        appId = "2394010";
        appIdName = "Palworld Dedicated Server";

        executable = "run-wrapper.sh";

        preStart = ''
          echo "Generating execution wrapper..."
          # We use a quoted 'EOF' so Nix doesn't evaluate the variables early
          cat << 'EOF' > run-wrapper.sh
          #!/bin/sh
          
          echo "Checking systemd credentials..."
          if [ -n "$CREDENTIALS_DIRECTORY" ]; then
            echo "Credentials directory found! Reading secrets..."
            SERVER_PWD=$(cat "$CREDENTIALS_DIRECTORY/server_pwd")
            ADMIN_PWD=$(cat "$CREDENTIALS_DIRECTORY/admin_pwd")

            echo "Ensuring Palworld configuration directory exists..."
            mkdir -p Pal/Saved/Config/LinuxServer/

            echo "Generating PalWorldSettings.ini..."
            # EOF_CONFIG is unquoted here so bash injects the passwords securely
            cat << EOF_CONFIG > Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
[/Script/Pal.PalGameWorldSettings]
OptionSettings=(Difficulty=None,RandomizerType=None,RandomizerSeed="",bIsRandomizerPalLevelRandom=False,DayTimeSpeedRate=1.000000,NightTimeSpeedRate=1.000000,ExpRate=1.000000,PalCaptureRate=1.000000,PalSpawnNumRate=1.000000,PalDamageRateAttack=1.000000,PalDamageRateDefense=1.000000,PlayerDamageRateAttack=1.000000,PlayerDamageRateDefense=1.000000,PlayerStomachDecreaceRate=1.000000,PlayerStaminaDecreaceRate=1.000000,PlayerAutoHPRegeneRate=1.000000,PlayerAutoHpRegeneRateInSleep=1.000000,PalStomachDecreaceRate=1.000000,PalStaminaDecreaceRate=1.000000,PalAutoHPRegeneRate=1.000000,PalAutoHpRegeneRateInSleep=1.000000,BuildObjectHpRate=1.000000,BuildObjectDamageRate=1.000000,BuildObjectDeteriorationDamageRate=1.000000,CollectionDropRate=1.000000,CollectionObjectHpRate=1.000000,CollectionObjectRespawnSpeedRate=1.000000,EnemyDropItemRate=1.000000,DeathPenalty=All,bEnablePlayerToPlayerDamage=False,bEnableFriendlyFire=False,bEnableInvaderEnemy=True,bActiveUNKO=False,bEnableAimAssistPad=True,bEnableAimAssistKeyboard=False,DropItemMaxNum=3000,DropItemMaxNum_UNKO=100,BaseCampMaxNum=128,BaseCampWorkerMaxNum=15,DropItemAliveMaxHours=1.000000,bAutoResetGuildNoOnlinePlayers=False,AutoResetGuildTimeNoOnlinePlayers=72.000000,GuildPlayerMaxNum=20,BaseCampMaxNumInGuild=8,PalEggDefaultHatchingTime=72.000000,WorkSpeedRate=1.000000,AutoSaveSpan=30.000000,bIsMultiplay=True,bIsPvP=False,bHardcore=False,bPalLost=False,bCharacterRecreateInHardcore=False,bCanPickupOtherGuildDeathPenaltyDrop=False,bEnableNonLoginPenalty=True,bEnableFastTravel=True,bEnableFastTravelOnlyBaseCamp=False,bIsStartLocationSelectByMap=True,bExistPlayerAfterLogout=False,bEnableDefenseOtherGuildPlayer=False,bInvisibleOtherGuildBaseCampAreaFX=False,bBuildAreaLimit=False,ItemWeightRate=1.000000,CoopPlayerMaxNum=4,ServerPlayerMaxNum=20,ServerName="Pal-o-Alto",ServerDescription="Vanilla, just a chill server",AdminPassword="''${ADMIN_PWD}",ServerPassword="''${SERVER_PWD}",bAllowClientMod=True,PublicPort=8211,PublicIP="",RCONEnabled=False,RCONPort=25575,Region="",bUseAuth=True,BanListURL="https://b.palworldgame.com/api/banlist.txt",RESTAPIEnabled=False,RESTAPIPort=8212,bShowPlayerList=False,ChatPostLimitPerMinute=30,CrossplayPlatforms=(Steam,Xbox,PS5,Mac),bIsUseBackupSaveData=True,LogFormatType=Text,bIsShowJoinLeftMessage=True,SupplyDropSpan=180,EnablePredatorBossPal=True,MaxBuildingLimitNum=0,ServerReplicatePawnCullDistance=15000.000000,bAllowGlobalPalboxExport=True,bAllowGlobalPalboxImport=True,EquipmentDurabilityDamageRate=1.000000,ItemContainerForceMarkDirtyInterval=1.000000,ItemCorruptionMultiplier=1.000000,DenyTechnologyList=,GuildRejoinCooldownMinutes=0,BlockRespawnTime=5.000000,RespawnPenaltyDurationThreshold=0.000000,RespawnPenaltyTimeScale=2.000000,bDisplayPvPItemNumOnWorldMap_BaseCamp=False,bDisplayPvPItemNumOnWorldMap_Player=False,AdditionalDropItemWhenPlayerKillingInPvPMode="PlayerDropItem",AdditionalDropItemNumWhenPlayerKillingInPvPMode=1,bAdditionalDropItemWhenPlayerKillingInPvPMode=False,bAllowEnhanceStat_Health=True,bAllowEnhanceStat_Attack=True,bAllowEnhanceStat_Stamina=True,bAllowEnhanceStat_Weight=True,bAllowEnhanceStat_WorkSpeed=True)
EOF_CONFIG
          else
            echo "ERROR: CREDENTIALS_DIRECTORY is empty! Did you add LoadCredential to the systemd service?"
          fi

          echo "Starting Palworld via steam-run..."
          exec ${pkgs.steam-run}/bin/steam-run ./PalServer.sh "$@"
          EOF
          
          chmod +x run-wrapper.sh
        '';

        executableArgs = [
          "-publiclobby"
          "-useperfthreads"
          "-NoAsyncLoadingThread"
          "-UseMultithreadForDS"
          "EpicApp=Pau"
        ];
        ports = {
          game = 8211;
          query = 27015;
        };
        environment = {
          LD_LIBRARY_PATH = "./linux64";
        };
        resources.memoryLimit = "16G";
        resources.cpuQuota = "800%";
      };
    };
  };

  # 2. Inject the secrets directly into the generated systemd service!
  systemd.services."steamcmd-server-pal".serviceConfig = {
    # Syntax is "CredentialID:PathToSecret"
    LoadCredential = [
      "server_pwd:/secrets/palworld1.txt"
      "admin_pwd:/secrets/palworld2.txt"
    ];
  };
}
