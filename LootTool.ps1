Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===== Settings (luu duong dan game) =====
$settingsDir = Join-Path $env:LOCALAPPDATA "PalworldLootTool"
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Force $settingsDir | Out-Null }
$settingsPath = Join-Path $settingsDir "gamepath.txt"
$defaultRoot  = "D:\Steam\steamapps\common\Palworld"

$script:gameRoot = $defaultRoot
if (Test-Path $settingsPath) {
    $saved = ([System.IO.File]::ReadAllText($settingsPath)).Trim()
    if ($saved) { $script:gameRoot = $saved }
}

function Get-ModDir($root) { return (Join-Path $root "Pal\Binaries\Win64\ue4ss\Mods\CustomizableLootDrops") }

$script:allItems   = New-Object System.Collections.ArrayList
$script:names      = @{}
$script:configPath = ""
$script:ready      = $false

function Load-Data($root) {
    $modDir = Get-ModDir $root
    $validPath = Join-Path $modDir "Scripts\GeneratedItemIDs.lua"
    $namesPath = Join-Path $modDir "ItemIDs.txt"
    $script:configPath = Join-Path $modDir "config.jsonc"
    $script:allItems.Clear(); $script:names = @{}
    if (-not (Test-Path $validPath)) { $script:ready = $false; return $false }
    $valid = @{}
    foreach ($line in [System.IO.File]::ReadAllLines($validPath)) {
        if ($line -match '\["([^"]+)"\]\s*=\s*true') { $valid[$matches[1]] = $true }
    }
    if (Test-Path $namesPath) {
        foreach ($line in [System.IO.File]::ReadAllLines($namesPath)) {
            if ($line -match '^([A-Za-z0-9_]+)\s*=\s*(.+?)\s*$') { $script:names[$matches[1]] = $matches[2] }
        }
    }
    foreach ($id in ($valid.Keys | Sort-Object)) {
        $nm = ""
        if ($script:names.ContainsKey($id) -and $script:names[$id] -ne "Unknown") { $nm = $script:names[$id] }
        $disp = if ($nm) { "$nm  [$id]" } else { $id }
        [void]$script:allItems.Add([PSCustomObject]@{ Id=$id; Name=$nm; Display=$disp })
    }
    $script:ready = $true; return $true
}

# ===== Form =====
$form = New-Object System.Windows.Forms.Form
$form.Text = "Palworld Loot Tool - by Claude"
$form.Size = New-Object System.Drawing.Size(900,660)
$form.StartPosition = "CenterScreen"
$form.Font = New-Object System.Drawing.Font("Segoe UI",9)

$lblPath = New-Object System.Windows.Forms.Label
$lblPath.Text="Duong dan game (thu muc chua Palworld.exe):"; $lblPath.Location='12,12'; $lblPath.AutoSize=$true
$txtPath = New-Object System.Windows.Forms.TextBox
$txtPath.Location='12,32'; $txtPath.Size='640,24'; $txtPath.Text=$script:gameRoot
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text="..."; $btnBrowse.Location='658,31'; $btnBrowse.Size='34,26'
$btnApplyPath = New-Object System.Windows.Forms.Button
$btnApplyPath.Text="Ap dung"; $btnApplyPath.Location='700,31'; $btnApplyPath.Size='90,26'
$lblPathStat = New-Object System.Windows.Forms.Label
$lblPathStat.Location='12,58'; $lblPathStat.Size='790,18'

# --- Toggle ON/OFF ---
$chkOn = New-Object System.Windows.Forms.CheckBox
$chkOn.Text="BAT MOD (ON)   -   bo chon = OFF (game farm binh thuong)"
$chkOn.Location='12,80'; $chkOn.AutoSize=$true; $chkOn.Checked=$true
$chkOn.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$chkOn.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67)

$lblSearch = New-Object System.Windows.Forms.Label
$lblSearch.Text="Tim item:"; $lblSearch.Location='12,116'; $lblSearch.AutoSize=$true
$txtSearch = New-Object System.Windows.Forms.TextBox
$txtSearch.Location='80,113'; $txtSearch.Size='360,24'
$lblHint = New-Object System.Windows.Forms.Label
$lblHint.Text="(go ten hoac ma item)"; $lblHint.Location='450,116'; $lblHint.AutoSize=$true; $lblHint.ForeColor='Gray'

$lst = New-Object System.Windows.Forms.ListBox
$lst.Location='12,144'; $lst.Size='440,400'

$btnAdd = New-Object System.Windows.Forms.Button
$btnAdd.Text="Them ->"; $btnAdd.Location='462,230'; $btnAdd.Size='90,34'
$btnRem = New-Object System.Windows.Forms.Button
$btnRem.Text="<- Xoa"; $btnRem.Location='462,272'; $btnRem.Size='90,34'

$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location='562,144'; $grid.Size='320,360'
$grid.AllowUserToAddRows=$false; $grid.RowHeadersVisible=$false
$grid.SelectionMode='FullRowSelect'; $grid.AutoSizeColumnsMode='None'
$colName=New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colName.HeaderText="Ten"; $colName.ReadOnly=$true; $colName.Width=185
$colQty=New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colQty.HeaderText="So luong"; $colQty.Width=95
$colId=New-Object System.Windows.Forms.DataGridViewTextBoxColumn
$colId.HeaderText="Id"; $colId.Visible=$false
$grid.Columns.AddRange($colName,$colQty,$colId)

$lblSel=New-Object System.Windows.Forms.Label
$lblSel.Text="Da chon: 0/7"; $lblSel.Location='562,510'; $lblSel.AutoSize=$true
$lblSel.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)

$btnSave=New-Object System.Windows.Forms.Button
$btnSave.Text="LUU & AP DUNG"; $btnSave.Location='562,534'; $btnSave.Size='320,42'
$btnSave.BackColor=[System.Drawing.Color]::FromArgb(46,160,67); $btnSave.ForeColor='White'
$btnSave.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)

$lblStatus=New-Object System.Windows.Forms.Label
$lblStatus.Location='12,548'; $lblStatus.Size='540,60'
$lblStatus.Text="Bat ON de chon item, hoac bo chon (OFF) roi LUU de tro ve farm binh thuong. Sau khi luu, RESTART Palworld."
$lblStatus.ForeColor=[System.Drawing.Color]::DimGray

$form.Controls.AddRange(@($lblPath,$txtPath,$btnBrowse,$btnApplyPath,$lblPathStat,$chkOn,$lblSearch,$txtSearch,$lblHint,$lst,$btnAdd,$btnRem,$grid,$lblSel,$btnSave,$lblStatus))

# ===== Logic =====
function Refresh-Pool {
    $q=$txtSearch.Text.Trim().ToLower(); $lst.BeginUpdate(); $lst.Items.Clear()
    foreach ($it in $script:allItems) { if ($q -eq "" -or $it.Display.ToLower().Contains($q)) { [void]$lst.Items.Add($it.Display) } }
    $lst.EndUpdate()
}
function Update-Count {
    $lblSel.Text="Da chon: $($grid.Rows.Count)/7"
    $btnAdd.Enabled=($chkOn.Checked -and $script:ready -and $grid.Rows.Count -lt 7)
}
function Set-ItemEnabled {
    $on=$chkOn.Checked -and $script:ready
    $txtSearch.Enabled=$on; $lst.Enabled=$on; $btnRem.Enabled=$on; $grid.Enabled=$on
    if ($chkOn.Checked) { $chkOn.Text="BAT MOD (ON)   -   dang cho chon item"; $chkOn.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67) }
    else { $chkOn.Text="MOD DANG OFF   -   tich vao de BAT (ON)"; $chkOn.ForeColor=[System.Drawing.Color]::Firebrick }
    Update-Count
}
function Find-ItemByDisplay($disp){ foreach($it in $script:allItems){ if($it.Display -eq $disp){return $it} }; return $null }
function Load-Current {
    $grid.Rows.Clear()
    if (-not (Test-Path $script:configPath)) { $chkOn.Checked=$true; return }
    try {
        $raw=[System.IO.File]::ReadAllText($script:configPath)
        $clean=($raw -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
        $obj=$clean | ConvertFrom-Json
        $cnt=0
        foreach ($d in $obj.Drops) {
            $nm=""; if ($script:names.ContainsKey($d.ItemId) -and $script:names[$d.ItemId] -ne "Unknown"){$nm=$script:names[$d.ItemId]}
            $dispName=if($nm){$nm}else{$d.ItemId}
            [void]$grid.Rows.Add($dispName,$d.MinAmount,$d.ItemId); $cnt++
        }
        $chkOn.Checked = ($cnt -gt 0)   # co drop = ON, rong = OFF
    } catch { $chkOn.Checked=$true }
}
function Write-Config($dropsBody) {
    $json="{`r`n  // Tao boi Palworld Loot Tool. RESTART game de ap dung.`r`n  `"Scope`": `"AllPals`",`r`n  `"IncludeBosses`": true,`r`n  `"IncludeHumans`": false,`r`n  `"IncludeOilRig`": false,`r`n  `"SpecificPals`": [ `"SheepBall`" ],`r`n  `"Drops`": [`r`n" + $dropsBody + "`r`n  ]`r`n}`r`n"
    [System.IO.File]::WriteAllText($script:configPath,$json,(New-Object System.Text.UTF8Encoding($false)))
}
function Apply-Path {
    $root=$txtPath.Text.Trim().TrimEnd('\')
    if ($root -eq "") {
        $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="Duong dan dang TRONG - hay dan duong dan thu muc game."
        [System.Windows.Forms.MessageBox]::Show("Ban chua nhap duong dan game!","Thieu duong dan",0,48)|Out-Null
        $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled; return
    }
    if (Load-Data $root) {
        $script:gameRoot=$root
        try { [System.IO.File]::WriteAllText($settingsPath,$root,(New-Object System.Text.UTF8Encoding($false))) } catch {}
        $lblPathStat.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblPathStat.Text="OK - da nhan dien mod ($($script:allItems.Count) item). Da luu duong dan."
        Refresh-Pool; Load-Current; Set-ItemEnabled
    } else {
        $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="SAI duong dan - khong thay mod CustomizableLootDrops o day."
        [System.Windows.Forms.MessageBox]::Show("Duong dan khong dung!`nKhong tim thay mod CustomizableLootDrops trong:`n$root`n`nHay chon dung thu muc goc Palworld (chua Palworld.exe).","Sai duong dan",0,48)|Out-Null
        $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled
    }
}

$btnBrowse.Add_Click({
    $fb=New-Object System.Windows.Forms.FolderBrowserDialog; $fb.Description="Chon thu muc Palworld (chua Palworld.exe)"
    if (Test-Path $txtPath.Text) { $fb.SelectedPath=$txtPath.Text }
    if ($fb.ShowDialog() -eq 'OK') { $txtPath.Text=$fb.SelectedPath; Apply-Path }
})
$btnApplyPath.Add_Click({ Apply-Path })
$chkOn.Add_CheckedChanged({ Set-ItemEnabled })
$txtSearch.Add_TextChanged({ Refresh-Pool })
$lst.Add_DoubleClick({ $btnAdd.PerformClick() })
$btnAdd.Add_Click({
    if ($null -eq $lst.SelectedItem) { return }
    if ($grid.Rows.Count -ge 7) { [System.Windows.Forms.MessageBox]::Show("Toi da 7 item thoi!","",0,48)|Out-Null; return }
    $it=Find-ItemByDisplay $lst.SelectedItem; if ($null -eq $it) { return }
    foreach ($r in $grid.Rows) { if ($r.Cells[2].Value -eq $it.Id) { return } }
    $dispName=if($it.Name){$it.Name}else{$it.Id}
    [void]$grid.Rows.Add($dispName,9999,$it.Id); Update-Count
})
$btnRem.Add_Click({ if ($grid.SelectedRows.Count -gt 0) { $grid.Rows.Remove($grid.SelectedRows[0]); Update-Count } })

$btnSave.Add_Click({
    if (-not $script:ready) {
        [System.Windows.Forms.MessageBox]::Show("Chua chon dung duong dan game (hoac de trong)!`nHay dan/duyet duong dan game va bam 'Ap dung' truoc.","Thieu duong dan",0,48)|Out-Null; return
    }
    if ($chkOn.Checked) {
        $grid.EndEdit()
        if ($grid.Rows.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show("Mod dang ON nhung chua chon item nao.`nChon item hoac bo chon ON de tat mod.","Chua chon item",0,48)|Out-Null; return }
        $drops=@()
        foreach ($r in $grid.Rows) {
            $id=[string]$r.Cells[2].Value; $qtyRaw=[string]$r.Cells[1].Value; $qty=0
            if (-not [int]::TryParse($qtyRaw,[ref]$qty) -or $qty -lt 1) { [System.Windows.Forms.MessageBox]::Show("So luong khong hop le o dong: $($r.Cells[0].Value)","Loi",0,48)|Out-Null; return }
            if ($qty -gt 99999) { $qty=99999 }
            $drops+=('    { "ItemId": "'+$id+'", "Chance": 100.0, "MinAmount": '+$qty+', "MaxAmount": '+$qty+' }')
        }
        try {
            Write-Config ($drops -join ",`r`n")
            $lblStatus.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblStatus.Text="MOD ON - da luu ($($grid.Rows.Count) item). RESTART Palworld la co."
            [System.Windows.Forms.MessageBox]::Show("Mod ON - da luu $($grid.Rows.Count) item!`n`nRESTART Palworld (thoat han + mo lai).","Xong",0,64)|Out-Null
        } catch { [System.Windows.Forms.MessageBox]::Show("Loi khi luu: $($_.Exception.Message)","Loi",0,16)|Out-Null }
    } else {
        try {
            Write-Config ""   # Drops rong = mod khong them gi = farm binh thuong
            $lblStatus.ForeColor=[System.Drawing.Color]::Firebrick; $lblStatus.Text="MOD OFF - game farm binh thuong. RESTART Palworld la ap dung."
            [System.Windows.Forms.MessageBox]::Show("Mod OFF - game se farm BINH THUONG (khong drop them).`n`nRESTART Palworld de ap dung.","Da tat mod",0,64)|Out-Null
        } catch { [System.Windows.Forms.MessageBox]::Show("Loi khi luu: $($_.Exception.Message)","Loi",0,16)|Out-Null }
    }
})

# ===== Khoi tao =====
if (Load-Data $script:gameRoot) {
    $lblPathStat.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblPathStat.Text="OK - da nhan dien mod ($($script:allItems.Count) item)."
    Refresh-Pool; Load-Current
} else {
    $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="Chua thay mod o duong dan mac dinh. Dan duong dan game roi bam 'Ap dung'."
}
Set-ItemEnabled
[void]$form.ShowDialog()
