<#
  setup-docs.ps1 - creates the Troubleshooter document folders and shows which files are still missing.

  Put this script next to troubleshooter.html and run it:
      powershell -ExecutionPolicy Bypass -File .\setup-docs.ps1
  It creates the empty folders (Maker\Family\Model\Manuals | Schematics), then lists every document
  that is not in place yet. Run it again whenever you have placed some files to see what is left.
  It never moves, deletes or overwrites anything.

  Optional:  -SearchIn "C:\Users\me\OneDrive"   (one or more folders, comma-separated)
  looks for the missing files by their exact file name in those folders and COPIES the ones it finds
  into the right place. Files found more than once are not copied; the report lists them.
  Results also go to setup-docs-report.txt.  Generated from DOCS in troubleshooter.html.
#>
param([string[]]$SearchIn)

$root = $PSScriptRoot

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

$docs = @(
  'Rico\TINY\TINY PC (old)\Manuals\TINY_PC Bedienungsanleitung - EN - V1.2.pdf',
  'Rico\TINY\Shared\Manuals\Montageanleitung  TINY8 Schiebekabel_8,4.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\TINYPC Gesamtverdrahtungsplan Spannungen und Signale.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\TINYPC Gesamtverdrahtungsplan Steuerkasten.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Verdrahtungsplan Steuerkasten.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Steuerkasten.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Top TinyPC CTRL.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Bottomlayer TinyPC ctrl.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Schaltplan.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Layout TOP.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Platine PowerSwitch Layout bottom.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Schiebekabel Verdrahtungsplan.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Schiebekabel Zusammenbauzeichung.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Verbindungskabel TINY PC mit Winkelstecker.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Haspbellgestell.pdf',
  'Rico\TINY\TINY PC2\Manuals\Instruction Manual TINYPC.2 EN V 2.2.pdf',
  'Rico\TINY\TINY PC2\Manuals\PC-Einstellungen_TINY-PC-2.pdf',
  'Rico\TINY\TINY PC2\Manuals\Reinstall metercounter Tiny PC 2 ENG.pdf',
  'Rico\TINY\TINY PC2\Manuals\Wiederherstellen Meterzähler Tiny PC 2.pdf',
  'Rico\TINY\Shared\Manuals\Rico PC2 Camlab settings.txt',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 CTRL-Platine Layout und Schaltplan.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 TinySR50-Steuerungsplatine Schaltplan und Layout.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Schaltplan.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Layout Top.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Platine Power Switch Layout Bottom.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schleifring Verdrahtungsplan.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schiebekabel Verdrahtungsplan.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Schiebekabel Zusammenbauzeichnung.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Steuerkasten mechanische Zeichnung.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Frontplatte vormontiert.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Frontplatte vormontiert Stückliste.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2 Baumstückliste.pdf',
  'Rico\TINY\TINY PC2\Schematics\9520.018190 Einbausatz PC.pdf',
  'Rico\TINY\TINY PC2\Schematics\Haspel TINY PC2 9520.018211.pdf',
  'Rico\TINY\TINY PC2\Schematics\Koffer kpl. TINY PC2 9520.018122.pdf',
  'Rico\TINY\TINY PC2\Schematics\TinyPC2- Koffer kpl. mit Halterung.pdf',
  'Rico\TINY\TINY PC (old)\Schematics\Gestell TINY PC 9520.017293.pdf',
  'Rico\TINY\TINY PLUS\Schematics\PRCC-1 9800.020604.PDF',
  'Rico\TINY\TINY 3\Manuals\Instruction Manual TINYPC3_V1.2 EN.pdf',
  'Rico\TINY\TINY 3\Manuals\TINY PC.3 DUC-1 Programmieranleitung.pdf',
  'Rico\TINY\TINY 3\Manuals\TINY PC3 PRCC-2 Programmieranleitung.pdf',
  'Rico\TINY\TINY 3\Manuals\Tiny PC Control Stecker prüfen.jpg',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Verdrahtung 9520.021342.pdf',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Verdrahtung 3520.021342 Ansicht Rückseite.pdf',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Steuereinheit Mechanik.pdf',
  'Rico\TINY\TINY 3\Schematics\Lagereinheit 9520.021754.pdf',
  'Rico\TINY\TINY 3\Schematics\Verdrahtung Lagereinheit mit ED 9520.021754.pdf',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Aufbau.pdf',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Gestell.pdf',
  'Rico\TINY\TINY 3\Schematics\TINY PC3 Stückliste.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Instruction Manual CROSS TOUCH 300 V 2.3 EN.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Quickstart Manual V1.0 - 07_2014 CrossTouch en.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Fehlersuche und Behebung CROSSTOUCH.docx',
  'Rico\CrossTouch\CT300 control unit\Manuals\CrossTouch Inbetriebnahme.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Instructions-cover_180705.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Neuer Monitotr in Steuereinheit OFF-009693.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\FB Control Umbau.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Touchscreen kabel überprüfen.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\inclination reset.png',
  'Rico\CrossTouch\CT300 control unit\Manuals\Cross Touch Grabber  Change.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Manual_Fix_VTG-Driver_WinCanVX-Change.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\VTG3056Anleitung.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Windows8.1 Wiederherstellen.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\201709 Demodulator Crosstouch Service-Instruction.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Demodulator Abgleich.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Demodulator cable length adjustment.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Anleitung_neue Firmware_von HT-Tech.docx',
  'Rico\CrossTouch\CT300 control unit\Manuals\EUG-008-eGalaxWorks_User_Guide_EXC31XX-151110-1_Holystone.pdf',
  'Rico\CrossTouch\CT300 control unit\Manuals\Q7730_USB-BT400.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\CrossTouch Steuereinheit 9750.016093.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\P9750.016093 CrossTouch control unit.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\Frontplatte unten komplett 9750.017781.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\Messpunkte Demodulator.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\9750.016123_S_Cross_Verbindungskabel_15m.pdf',
  'Rico\CrossTouch\CT300 control unit\Schematics\Verbindungskabel 3522.00003.pdf',
  'Rico\CrossTouch\Cross Remote\Manuals\Kurzanleitung CROSSREMOTE EN V 1.1.pdf',
  'Rico\CrossTouch\Cross Remote\Manuals\Kurzanleitung CROSSREMOTE DE V 1.1.pdf',
  'Rico\CrossTouch\Cross Remote\Manuals\Cross Remote pairing EN.txt',
  'Rico\CrossTouch\Shared\Schematics\9106.016090 CrossTouch drum.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.016092 KTR300.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.016092 KTR300 Partslist.pdf',
  'Rico\CrossTouch\Shared\Schematics\CrossTouch Verdrahtung KTR300.pdf',
  'Rico\CrossTouch\Shared\Schematics\CrossTouch connection cable.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR300 Einlaufgehäuse vormontiert 9106.017924.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR300 Einlaufgehäuse vormontiert Stückliste 9106.017924.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\Flanschdose 3245.000026.jpg',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.013790 Meterzähler Drehgeber komplett Stückliste.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR-300 Wetercounter wiring.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR-300 Metercounter wiring.JPG',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\meterzähler.jpg',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\encoder old KMT.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Manuals\Cross Touch Power Supply Upgrade for FW150SAT.1.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Manuals\Nachrüstung KTR Netzteil 9106.020797.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\KTR PSU upgrade wiring diagram 9106.020797.pdf',
  'Rico\CrossTouch\KTR300 cable drum\Schematics\9106.020797 Nachrüstung KTR-FW Netzteil Kabel.pdf',
  'Rico\TINY\Shared\Schematics\Schiebekabel 60m Verdrahtungsplan 9520.021489.pdf',
  'Rico\TINY\Shared\Schematics\Schiebekabel Mechanik.pdf',
  'Cosmic\C120\Manuals\22596_C120 manual.pdf',
  'Rico\TINY\Shared\Schematics\Mechanikeinheit TINY PC-PLUS 9520.017287.pdf'
)

foreach ($f in $folders) {
  $p = Join-Path $root $f
  if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p | Out-Null }
}
Write-Host "Folders ready ($($folders.Count))."

$byName = @{}
if ($SearchIn) {
  foreach ($s in $SearchIn) {
    $s = $s.Trim('"')
    if (-not (Test-Path -LiteralPath $s -PathType Container)) { Write-Host "Not found, skipped: $s" -ForegroundColor Yellow; continue }
    Write-Host "Searching $s ..."
    Get-ChildItem -LiteralPath $s -Recurse -File -ErrorAction SilentlyContinue |
      Where-Object { -not $_.FullName.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) } | ForEach-Object {
        $k = $_.Name.ToLowerInvariant()
        if (-not $byName.ContainsKey($k)) { $byName[$k] = New-Object System.Collections.ArrayList }
        [void]$byName[$k].Add($_.FullName)
      }
  }
}

$have = 0; $copied = 0
$missing = New-Object System.Collections.ArrayList
$unsure  = New-Object System.Collections.ArrayList
foreach ($d in $docs) {
  $dest = Join-Path $root $d
  if (Test-Path -LiteralPath $dest) { $have++; continue }
  $hits = $byName[(Split-Path $d -Leaf).ToLowerInvariant()]
  if ($hits -and $hits.Count -eq 1) { Copy-Item -LiteralPath $hits[0] -Destination $dest; $copied++ }
  elseif ($hits) { [void]$unsure.Add("$d  <-  found $($hits.Count) times: " + ($hits -join ' | ')) }
  else { [void]$missing.Add($d) }
}

Write-Host ""
Write-Host "Documents: $($docs.Count) in the app"
Write-Host "  in place:  $have"
if ($SearchIn) { Write-Host "  copied now: $copied" }
if ($unsure.Count) { Write-Host "  found several times, not copied: $($unsure.Count)" -ForegroundColor Yellow }
Write-Host "  missing:   $($missing.Count)" -ForegroundColor $(if ($missing.Count) { 'Yellow' } else { 'Green' })
if ($missing.Count) { Write-Host ""; Write-Host "Still missing:" -ForegroundColor Yellow; $missing | ForEach-Object { Write-Host "  $_" } }

$report = Join-Path $root 'setup-docs-report.txt'
$lines = @("setup-docs report  $(Get-Date -Format 'yyyy-MM-dd HH:mm')", "",
  "MISSING ($($missing.Count)):") + ($missing | ForEach-Object { "  $_" }) +
  @("", "FOUND SEVERAL TIMES, NOT COPIED ($($unsure.Count)) - pick the right one by hand:") + ($unsure | ForEach-Object { "  $_" })
Set-Content -LiteralPath $report -Value $lines -Encoding UTF8
Write-Host ""
Write-Host "Report: $report"
Read-Host "Press Enter to close"
