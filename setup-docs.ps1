<#
  setup-docs.ps1 - builds the Troubleshooter document folders and copies your manuals into them.

  Put this script next to troubleshooter.html and run it:
      powershell -ExecutionPolicy Bypass -File .\setup-docs.ps1 -Source "D:\old copies"
  Without -Source it asks for the folder.

  -Source is the folder that holds your OLD copies (old Rico\, Cosmic\ ... folders, or just a heap of files).
  For each document the script looks first at its old path, then for a file with the same name anywhere
  under -Source. It only COPIES. It never moves, deletes or overwrites anything, so it is safe to run again.
  At the end it writes setup-docs-report.txt with what is missing and which of your files the app does not use.
  Layout:  <Maker>\<Family>\<Model>\Manuals | Schematics.  Generated from DOCS in troubleshooter.html.
#>
param([string]$Source)

$root = $PSScriptRoot
if (-not $Source) { $Source = Read-Host "Folder with your old copies" }
$Source = $Source.Trim('"')
if (-not (Test-Path -LiteralPath $Source -PathType Container)) { Write-Host "Folder not found: $Source" -ForegroundColor Red; Read-Host "Press Enter to close"; exit 1 }
$Source = (Resolve-Path -LiteralPath $Source).ProviderPath.TrimEnd('\')
if ($Source -eq $root.TrimEnd('\')) {
  Write-Host "-Source must be a different folder from the one this script is in." -ForegroundColor Red
  Write-Host "Copy your old folders somewhere else first, e.g. into a folder called 'old copies'."
  Read-Host "Press Enter to close"; exit 1
}

$folders = @(
  'Cosmic',
  'Cosmic\C120',
  'Cosmic\C120\Manuals',
  'Cosmic\C120\Schematics',
  'Dancutter',
  'IMS',
  'Rico',
  'Rico\CrossTouch',
  'Rico\CrossTouch\CT300 control unit',
  'Rico\CrossTouch\CT300 control unit\Manuals',
  'Rico\CrossTouch\CT300 control unit\Schematics',
  'Rico\CrossTouch\Cross Remote',
  'Rico\CrossTouch\Cross Remote\Manuals',
  'Rico\CrossTouch\Cross Remote\Schematics',
  'Rico\CrossTouch\KTR300 cable drum',
  'Rico\CrossTouch\KTR300 cable drum\Manuals',
  'Rico\CrossTouch\KTR300 cable drum\Schematics',
  'Rico\CrossTouch\Shared',
  'Rico\CrossTouch\Shared\Manuals',
  'Rico\CrossTouch\Shared\Schematics',
  'Rico\TINY',
  'Rico\TINY\Shared',
  'Rico\TINY\Shared\Manuals',
  'Rico\TINY\Shared\Schematics',
  'Rico\TINY\TINY 3',
  'Rico\TINY\TINY 3\Manuals',
  'Rico\TINY\TINY 3\Schematics',
  'Rico\TINY\TINY PC (old)',
  'Rico\TINY\TINY PC (old)\Manuals',
  'Rico\TINY\TINY PC (old)\Schematics',
  'Rico\TINY\TINY PC2',
  'Rico\TINY\TINY PC2\Manuals',
  'Rico\TINY\TINY PC2\Schematics',
  'Rico\TINY\TINY PLUS',
  'Rico\TINY\TINY PLUS\Manuals',
  'Rico\TINY\TINY PLUS\Schematics'
)

# old path (under -Source)  ->  new path (next to this script)
$docs = @(
  ,@('Rico\TINY\Tiny PC\TINY_PC Bedienungsanleitung - EN - V1.2.pdf', 'Rico\TINY\TINY PC (old)\Manuals\TINY_PC Bedienungsanleitung - EN - V1.2.pdf')
  ,@('Rico\TINY\Montageanleitung  TINY8 Schiebekabel_8,4.pdf', 'Rico\TINY\Shared\Manuals\Montageanleitung  TINY8 Schiebekabel_8,4.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\TINYPC Gesamtverdrahtungsplan Spannungen und Signale.pdf', 'Rico\TINY\TINY PC (old)\Schematics\TINYPC Gesamtverdrahtungsplan Spannungen und Signale.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\TINYPC Gesamtverdrahtungsplan Steuerkasten.pdf', 'Rico\TINY\TINY PC (old)\Schematics\TINYPC Gesamtverdrahtungsplan Steuerkasten.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Verdrahtungsplan Steuerkasten.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Verdrahtungsplan Steuerkasten.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Steuerkasten.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Steuerkasten.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Top TinyPC CTRL.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Top TinyPC CTRL.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Bottomlayer TinyPC ctrl.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Bottomlayer TinyPC ctrl.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Platine PowerSwitch Schaltplan.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Schaltplan.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Platine PowerSwitch Layout TOP.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Layout TOP.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Platine PowerSwitch Layout bottom.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Layout bottom.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Schiebekabel Verdrahtungsplan.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Schiebekabel Verdrahtungsplan.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Schiebekabel Zusammenbauzeichung.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Schiebekabel Zusammenbauzeichung.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Verbindungskabel TINY PC mit Winkelstecker.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Verbindungskabel TINY PC mit Winkelstecker.pdf')
  ,@('Rico\TINY\Tiny PC\Pläne\Haspbellgestell.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Haspbellgestell.pdf')
  ,@('Rico\TINY\Tiny PC2\Instruction Manual TINYPC.2 EN V 2.2.pdf', 'Rico\TINY\TINY PC2\Manuals\Instruction Manual TINYPC.2 EN V 2.2.pdf')
  ,@('Rico\TINY\Tiny PC2\PC-Einstellungen_TINY-PC-2.pdf', 'Rico\TINY\TINY PC2\Manuals\PC-Einstellungen_TINY-PC-2.pdf')
  ,@('Rico\TINY\Tiny PC2\Software MZ Set 60-100m\Reinstall metercounter Tiny PC 2 ENG.pdf', 'Rico\TINY\TINY PC2\Manuals\Reinstall metercounter Tiny PC 2 ENG.pdf')
  ,@('Rico\TINY\Tiny PC2\Software MZ Set 60-100m\Wiederherstellen Meterzähler Tiny PC 2.pdf', 'Rico\TINY\TINY PC2\Manuals\Wiederherstellen Meterzähler Tiny PC 2.pdf')
  ,@('Rico\TINY\Rico PC2 Camlab settings.txt', 'Rico\TINY\Shared\Manuals\Rico PC2 Camlab settings.txt')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 CTRL-Platine Layout und Schaltplan.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 CTRL-Platine Layout und Schaltplan.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 TinySR50-Steuerungsplatine Schaltplan und Layout.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 TinySR50-Steuerungsplatine Schaltplan und Layout.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Platine Power Switch Schaltplan.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Schaltplan.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Platine Power Switch Layout Top.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Layout Top.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Platine Power Switch Layout Bottom.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Layout Bottom.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Schleifring Verdrahtungsplan.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schleifring Verdrahtungsplan.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Schiebekabel Verdrahtungsplan.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schiebekabel Verdrahtungsplan.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Schiebekabel Zusammenbauzeichnung.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schiebekabel Zusammenbauzeichnung.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Steuerkasten mechanische Zeichnung.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Steuerkasten mechanische Zeichnung.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Frontplatte vormontiert.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Frontplatte vormontiert.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Frontplatte vormontiert Stückliste.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Frontplatte vormontiert Stückliste.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2 Baumstückliste.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2 Baumstückliste.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\9520.018190 Einbausatz PC.pdf', 'Rico\TINY\TINY PC2\Schematics\9520.018190 Einbausatz PC.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\Haspel TINY PC2 9520.018211.pdf', 'Rico\TINY\TINY PC2\Schematics\Haspel TINY PC2 9520.018211.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\Koffer kpl. TINY PC2 9520.018122.pdf', 'Rico\TINY\TINY PC2\Schematics\Koffer kpl. TINY PC2 9520.018122.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\TinyPC2- Koffer kpl. mit Halterung.pdf', 'Rico\TINY\TINY PC2\Schematics\TinyPC2- Koffer kpl. mit Halterung.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\Gestell TINY PC 9520.017293.pdf', 'Rico\TINY\TINY PC (old)\Schematics\Gestell TINY PC 9520.017293.pdf')
  ,@('Rico\TINY\Tiny PLUS\PRCC-1 9800.020604.PDF', 'Rico\TINY\TINY PLUS\Schematics\PRCC-1 9800.020604.PDF')
  ,@('Rico\TINY\Tiny PC3\Instruction Manual TINYPC3_V1.2 EN.pdf', 'Rico\TINY\TINY 3\Manuals\Instruction Manual TINYPC3_V1.2 EN.pdf')
  ,@('Rico\TINY\Tiny PC3\Software TINY PC3\TINY PC.3 DUC-1 Programmieranleitung.pdf', 'Rico\TINY\TINY 3\Manuals\TINY PC.3 DUC-1 Programmieranleitung.pdf')
  ,@('Rico\TINY\Tiny PC3\Software TINY PC3\TINY PC3 PRCC-2 Programmieranleitung.pdf', 'Rico\TINY\TINY 3\Manuals\TINY PC3 PRCC-2 Programmieranleitung.pdf')
  ,@('Rico\TINY\Tiny PC3\Tiny PC Control Stecker prüfen.jpg', 'Rico\TINY\TINY 3\Manuals\Tiny PC Control Stecker prüfen.jpg')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Steuereinheit Verdrahtung 9520.021342.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Verdrahtung 9520.021342.pdf')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Steuereinheit Verdrahtung 3520.021342 Ansicht Rückseite.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Verdrahtung 3520.021342 Ansicht Rückseite.pdf')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Steuereinheit Mechanik.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Mechanik.pdf')
  ,@('Rico\TINY\Tiny PC3\Lagereinheit 9520.021754.pdf', 'Rico\TINY\TINY 3\Schematics\Lagereinheit 9520.021754.pdf')
  ,@('Rico\TINY\Tiny PC3\Verdrahtung Lagereinheit mit ED 9520.021754.pdf', 'Rico\TINY\TINY 3\Schematics\Verdrahtung Lagereinheit mit ED 9520.021754.pdf')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Aufbau.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Aufbau.pdf')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Gestell.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Gestell.pdf')
  ,@('Rico\TINY\Tiny PC3\TINY PC3 Stückliste.pdf', 'Rico\TINY\TINY 3\Schematics\TINY PC3 Stückliste.pdf')
  ,@('Rico\CrossTouch\Instruction Manual CROSS TOUCH 300 V 2.3 EN.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Instruction Manual CROSS TOUCH 300 V 2.3 EN.pdf')
  ,@('Rico\CrossTouch\Quickstart Manual V1.0 - 07_2014 CrossTouch en.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Quickstart Manual V1.0 - 07_2014 CrossTouch en.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Fehlersuche und Behebung CROSSTOUCH.docx', 'Rico\CrossTouch\CT300 control unit\Manuals\Fehlersuche und Behebung CROSSTOUCH.docx')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\CrossTouch Inbetriebnahme.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\CrossTouch Inbetriebnahme.pdf')
  ,@('Rico\CrossTouch\Instructions-cover_180705.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Instructions-cover_180705.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Neuer Monitotr in Steuereinheit OFF-009693.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Neuer Monitotr in Steuereinheit OFF-009693.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\FB Control Umbau.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\FB Control Umbau.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Touchscreen kabel überprüfen.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Touchscreen kabel überprüfen.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\inclination reset.png', 'Rico\CrossTouch\CT300 control unit\Manuals\inclination reset.png')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Grabber change\Cross Touch Grabber  Change.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Cross Touch Grabber  Change.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Manual_Fix_VTG-Driver_WinCanVX-Change.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Manual_Fix_VTG-Driver_WinCanVX-Change.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\VTG3056Anleitung.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\VTG3056Anleitung.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Windows8.1 Wiederherstellen.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Windows8.1 Wiederherstellen.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Demodulator\201709 Demodulator Crosstouch Service-Instruction.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\201709 Demodulator Crosstouch Service-Instruction.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Demodulator\Demodulator Abgleich.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Demodulator Abgleich.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Demodulator\Demodulator cable length adjustment.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Demodulator cable length adjustment.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Drivers and Software\eGalax_Touch_HT-Tech_v2\Anleitung_neue Firmware_von HT-Tech.docx', 'Rico\CrossTouch\CT300 control unit\Manuals\Anleitung_neue Firmware_von HT-Tech.docx')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Drivers and Software\eGalax_Touch_HT-Tech_v2\EUG-008-eGalaxWorks_User_Guide_EXC31XX-151110-1_Holystone.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\EUG-008-eGalaxWorks_User_Guide_EXC31XX-151110-1_Holystone.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Drivers and Software\Asus Bluetooth\Manual\Q7730_USB-BT400.pdf', 'Rico\CrossTouch\CT300 control unit\Manuals\Q7730_USB-BT400.pdf')
  ,@('Rico\CrossTouch\Control Unit\CrossTouch Steuereinheit 9750.016093.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\CrossTouch Steuereinheit 9750.016093.pdf')
  ,@('Rico\CrossTouch\Control Unit\P9750.016093 CrossTouch control unit.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\P9750.016093 CrossTouch control unit.pdf')
  ,@('Rico\CrossTouch\Control Unit\Frontplatte unten komplett 9750.017781.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\Frontplatte unten komplett 9750.017781.pdf')
  ,@('Rico\CrossTouch\Control Unit\Manuals and drivers\Manuals\Demodulator\Messpunkte Demodulator.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\Messpunkte Demodulator.pdf')
  ,@('Rico\CrossTouch\Red link cable\9750.016123_S_Cross_Verbindungskabel_15m.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\9750.016123_S_Cross_Verbindungskabel_15m.pdf')
  ,@('Rico\CrossTouch\Red link cable\Verbindungskabel 3522.00003.pdf', 'Rico\CrossTouch\CT300 control unit\Schematics\Verbindungskabel 3522.00003.pdf')
  ,@('Rico\CrossTouch\Cross Remote\Kurzanleitung CROSSREMOTE EN V 1.1.pdf', 'Rico\CrossTouch\Cross Remote\Manuals\Kurzanleitung CROSSREMOTE EN V 1.1.pdf')
  ,@('Rico\CrossTouch\Cross Remote\Kurzanleitung CROSSREMOTE DE V 1.1.pdf', 'Rico\CrossTouch\Cross Remote\Manuals\Kurzanleitung CROSSREMOTE DE V 1.1.pdf')
  ,@('Rico\CrossTouch\Cross Remote\Cross Remote pairing EN.txt', 'Rico\CrossTouch\Cross Remote\Manuals\Cross Remote pairing EN.txt')
  ,@('Rico\CrossTouch\Cabledrum KTR300\9106.016090 CrossTouch drum.pdf', 'Rico\CrossTouch\Shared\Schematics\9106.016090 CrossTouch drum.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\9106.016092 KTR300.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.016092 KTR300.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\9106.016092 KTR300 Partslist.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.016092 KTR300 Partslist.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\CrossTouch Verdrahtung KTR300.pdf', 'Rico\CrossTouch\Shared\Schematics\CrossTouch Verdrahtung KTR300.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\CrossTouch connection cable.pdf', 'Rico\CrossTouch\Shared\Schematics\CrossTouch connection cable.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\KTR300 Einlaufgehäuse vormontiert 9106.017924.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR300 Einlaufgehäuse vormontiert 9106.017924.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\KTR300 Einlaufgehäuse vormontiert Stückliste 9106.017924.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR300 Einlaufgehäuse vormontiert Stückliste 9106.017924.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Flanschdose 3245.000026.jpg', 'Rico\CrossTouch\KTR300 cable drum\Schematics\Flanschdose 3245.000026.jpg')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Metercounter encoder\9106.013790 Meterzähler Drehgeber komplett Stückliste.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.013790 Meterzähler Drehgeber komplett Stückliste.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Metercounter encoder\KTR-300 Wetercounter wiring.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR-300 Wetercounter wiring.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Metercounter encoder\KTR-300 Metercounter wiring.JPG', 'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR-300 Metercounter wiring.JPG')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Metercounter encoder\meterzähler.jpg', 'Rico\CrossTouch\KTR300 cable drum\Schematics\meterzähler.jpg')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Metercounter encoder\encoder old KMT.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\encoder old KMT.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Switch mode powersupply upgrade\Cross Touch Power Supply Upgrade for FW150SAT.1.pdf', 'Rico\CrossTouch\KTR300 cable drum\Manuals\Cross Touch Power Supply Upgrade for FW150SAT.1.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Switch mode powersupply upgrade\Nachrüstung KTR Netzteil 9106.020797.pdf', 'Rico\CrossTouch\KTR300 cable drum\Manuals\Nachrüstung KTR Netzteil 9106.020797.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Switch mode powersupply upgrade\KTR PSU upgrade wiring diagram 9106.020797.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR PSU upgrade wiring diagram 9106.020797.pdf')
  ,@('Rico\CrossTouch\Cabledrum KTR300\Switch mode powersupply upgrade\9106.020797 Nachrüstung KTR-FW Netzteil Kabel.pdf', 'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.020797 Nachrüstung KTR-FW Netzteil Kabel.pdf')
  ,@('Rico\TINY\Schiebekabel 60m Verdrahtungsplan 9520.021489.pdf', 'Rico\TINY\Shared\Schematics\Schiebekabel 60m Verdrahtungsplan 9520.021489.pdf')
  ,@('Rico\TINY\Schiebekabel Mechanik.pdf', 'Rico\TINY\Shared\Schematics\Schiebekabel Mechanik.pdf')
  ,@('Cosmic\22596_C120 manual.pdf', 'Cosmic\C120\Manuals\22596_C120 manual.pdf')
  ,@('Rico\TINY\Tiny PC2\Pläne\Mechanikeinheit TINY PC-PLUS 9520.017287.pdf', 'Rico\TINY\Shared\Schematics\Mechanikeinheit TINY PC-PLUS 9520.017287.pdf')
)

foreach ($f in $folders) {
  $p = Join-Path $root $f
  if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p | Out-Null }
}
Write-Host "Folders ready ($($folders.Count))."

Write-Host "Indexing $Source ..."
$byName = @{}
Get-ChildItem -LiteralPath $Source -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
  $k = $_.Name.ToLowerInvariant()
  if (-not $byName.ContainsKey($k)) { $byName[$k] = New-Object System.Collections.ArrayList }
  [void]$byName[$k].Add($_.FullName)
}

$copied = 0; $already = 0; $used = @{}
$missing = New-Object System.Collections.ArrayList
$unsure  = New-Object System.Collections.ArrayList
foreach ($d in $docs) {
  $dest = Join-Path $root $d[1]
  $name = Split-Path $d[1] -Leaf
  $src  = Join-Path $Source $d[0]
  if (Test-Path -LiteralPath $src -PathType Leaf) { $used[(Resolve-Path -LiteralPath $src).ProviderPath] = 1 }
  else {
    $src = $null
    $hits = $byName[$name.ToLowerInvariant()]
    if ($hits) { foreach ($x in $hits) { $used[$x] = 1 } }
    if ($hits -and $hits.Count -eq 1) { $src = $hits[0] }
    elseif ($hits -and $hits.Count -gt 1) { [void]$unsure.Add("$($d[1])  <-  $($hits.Count) files with this name: " + ($hits -join ' | ')) }
  }
  if (Test-Path -LiteralPath $dest) { $already++; continue }
  if ($src) { Copy-Item -LiteralPath $src -Destination $dest; $copied++ }
  elseif (-not ($hits -and $hits.Count -gt 1)) { [void]$missing.Add($d[1]) }
}

$unused = @($byName.Values | ForEach-Object { $_ } | Where-Object { -not $used.ContainsKey($_) } | Sort-Object)

Write-Host ""
Write-Host "Documents: $($docs.Count) in the app"
Write-Host "  copied now:            $copied"
Write-Host "  already in place:      $already"
Write-Host "  missing:               $($missing.Count)" -ForegroundColor $(if ($missing.Count) { 'Yellow' } else { 'Green' })
Write-Host "  several matches, skipped: $($unsure.Count)" -ForegroundColor $(if ($unsure.Count) { 'Yellow' } else { 'Green' })
Write-Host "Your files the app does not use: $($unused.Count)"

$report = Join-Path $root 'setup-docs-report.txt'
$lines = @("setup-docs report  $(Get-Date -Format 'yyyy-MM-dd HH:mm')", "Source: $Source", "",
  "MISSING ($($missing.Count)) - not found under Source:") + ($missing | ForEach-Object { "  $_" }) +
  @("", "SEVERAL MATCHES ($($unsure.Count)) - copy the right one by hand:") + ($unsure | ForEach-Object { "  $_" }) +
  @("", "NOT USED BY THE APP ($($unused.Count)) - candidates to add to DOCS:") + ($unused | ForEach-Object { "  $_" })
Set-Content -LiteralPath $report -Value $lines -Encoding UTF8
Write-Host ""
Write-Host "Details: $report"
Read-Host "Press Enter to close"
