{ pkgs, config, ... }:

let
  # here I need to convert 5.10 to 51000
  versionInCorrectFormat = builtins.toString (builtins.floor ( (builtins.fromJSON pkgs.homebank.version) * 10000 ));
in
{
  home.packages = with pkgs; [
    homebank
    finances
  ];

  xdg.configFile = {
    "homebank/preferences".text = ''
[General]
Version=${versionInCorrectFormat}
Language=en_CA
BarStyle=4
GtkOverride=false
GtkFontSize=10
GtkDarkTheme=false
IconTheme=Default
IconSymbolic=false
CustomColors=true
CustomBgFuture=true
ColorUsePalette=true
ColorExp=#ce5c00
ColorInc=#4e9a36
ColorWarn=#a40000
ColorBgFuture=#204a87
GridLines=0
WalletPath=${config.home.homeDirectory}/${config.folders.annex}/important documents/finances/homebank
BackupPath=${config.home.homeDirectory}/${config.folders.annex}/important documents/finances/homebank/backups
ImportPath=${config.home.homeDirectory}/${config.folders.annex}/important documents/finances/homebank
ExportPath=${config.home.homeDirectory}/${config.folders.annex}/important documents/finances/homebank
BakIsAutomatic=true
BakMaxNumCopies=5
ShowSplash=true
ShowWelcome=true
LoadLast=true
AppendScheduled=false
UpdateCurrency=false
HeritDate=false
ShowConfirm=false
ShowTemplate=false
HideReconciled=false
SameDaySort=0
ShowRemind=true
ShowVoid=false
IncludeRemind=false
LockReconciled=true
SafePendRecon=true
SafePendPast=true
SafePendPastDays=90
TxnMemoAcp=true
TxnMemoAcpDays=365
TxnXferShowDialog=true
TxnXferDayGap=2
TxnXferSyncDate=false
TxnXferSyncStatus=false
ColumnsOpe=1;-13;15;2;3;4;9;10;12;-6;7;8;11;5;0;0;
ColumnsOpeWidth=47;87;115;71;288;-1;88;81;166;63;85;49;-1;-1;60;-1;
OpeSortId=2
OpeSortOrder=0
ColumnsDet=1;2;-3;4;9;-10;12;6;-7;-8;-11;5;13;14;15;0;
ColumnsDetWidth=-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;
FiscYearDay=1
FiscYearMonth=1
Payment=1;2;3;4;6;7;8;9;10;11;12;

[Windows]
Wal=0;0;848;1415;0;
Acc=0;0;847;1415;0;
Sta=0;0;800;494;0;
Tme=0;0;800;494;0;
Ove=0;0;800;494;0;
Bud=0;0;800;494;0;
Car=0;0;800;494;0;
Txn=0;0;564;-1;0;
DBud=0;0;0;0;0;
WalVPaned=283
WalHPaned=330
WalToolbar=true
WalTotalChart=true
WalTimeChart=true
WalUpcoming=true

[Panels]
AccColAccW=118
AccShowBy=0
AccColumns=0;1;2;3;4;5;
HubTotView=1
HubTotViewRange=43
HubTotRaw=0
HubTimView=1
HubTimViewRange=29
HubTimRaw=0
ColumnsSch=10;11;12;13;14;15;16;17;18;
UpcColPayV=1
UpcColCatV=1
UpcColMemV=1
UpcColPayW=-1
UpcColCatW=-1
UpcColMemW=-1
UpcRange=6
PnlLstTab=sched

[Format]
DateFmt=%x
UnitIsMile=false
UnitIsGal=false

[Filter]
DateRangeTxn=2
DateFutureNbDays=0
DateRangeRep=2

[API]
APIRateUrl=https://api.frankfurter.app/latest
APIRateKey=

[Euro]
Active=false

[Report]
StatByAmount=false
StatDetail=false
StatRate=false
StatIncXfer=false
BudgDetail=false
BudgUnExclSub=false
ColorScheme=0
SmallFont=false
MaxSpendItems=10
Forecast=true
ForecastNbMonth=6

[Exchange]
DoIntro=true
UcFirst=false
DateFmt=0
DayGap=0
OfxName=1
OfxMemo=2
QifMemo=true
QifSwap=false
CsvSep=2
DoDefPayee=false
DoAutoAssign=false
    '';
  };
}
