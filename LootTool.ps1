Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ===== Settings =====
$settingsDir = Join-Path $env:LOCALAPPDATA "PalworldLootTool"
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Force $settingsDir | Out-Null }
$settingsPath = Join-Path $settingsDir "gamepath.txt"
$defaultRoot  = "D:\Steam\steamapps\common\Palworld"
$script:gameRoot = $defaultRoot
if (Test-Path $settingsPath) { $s=([System.IO.File]::ReadAllText($settingsPath)).Trim(); if ($s){$script:gameRoot=$s} }

function Get-ModDir($root) { return (Join-Path $root "Pal\Binaries\Win64\ue4ss\Mods\CustomizableLootDrops") }

# ===== Tên tiếng Việt có sẵn =====
$script:override = @{
 "StainlessSteel"="Hexolite"; "NightStone"="Cát Sao Đêm"; "Chromium"="Quặng Chromite"
 "WorldTreeHolyWater"="Nước Thánh Cây Thế Giới"; "Wood_WorldTree"="Mythical Wood (Gỗ Thần Thoại)"
 "Wood_Fine"="Hardwood (Gỗ Cứng)"; "Wood_Ancient"="Ancient Bark (Vỏ Cây Cổ)"; "Wood"="Gỗ"
 "AncientParts2"="Ancient Civilization Core (Lõi Văn Minh Cổ)"; "AncientParts3"="Ancient Pal Manuscript (Bản Thảo Pal Cổ)"
 "PalCrystal_Ex"="Ancient Civilization Parts (Mảnh Văn Minh Cổ)"
 "WorldTreeRelic_01"="Di Vật World Tree bậc 1"; "WorldTreeRelic_02"="Di Vật World Tree bậc 2"; "WorldTreeRelic_03"="Di Vật World Tree bậc 3"; "WorldTreeRelic_04"="Di Vật World Tree bậc 4"; "WorldTreeRelic_05"="Glistening Ancient Relic (Di Vật Lấp Lánh)"
 "PalUpgradeStone"="Hồn Pal Nhỏ"; "PalUpgradeStone2"="Hồn Pal Vừa"; "PalUpgradeStone3"="Hồn Pal Lớn"; "PalUpgradeStone4"="Hồn Pal Khổng Lồ"
 "Rankup_1"="Starfruit ☆1"; "Rankup_2"="Starfruit ☆2"; "Rankup_3"="Starfruit ☆3"; "Rankup_4"="Starfruit ☆4"; "Rankup_Arbitrary"="Ripe Starfruit (nâng bất kỳ +1)"
 "Fruit_hp_01"="Life Fruit (tăng Máu)"; "Fruit_attack_01"="Attack Fruit (tăng Tấn công)"; "Fruit__defense_01"="Defense Fruit (tăng Phòng thủ)"; "AffectionFruit_01"="Affection Fruit (thân thiết)"; "AffectionFruit_02"="Affection Fruit II"
 "IronIngot"="Thỏi Sắt"; "CopperIngot"="Thỏi Đồng"; "ManganeseIngot"="Thỏi Mangan"; "StealIngot"="Thỏi Thép"; "SkyislandIngot"="Thỏi Đảo Trời"; "WorldTreeIngot"="Thỏi Cây Thế Giới"
 "IronOre"="Quặng Sắt"; "CopperOre"="Quặng Đồng"; "ManganeseOre"="Quặng Mangan"; "SkyIslandOre"="Quặng Đảo Trời"; "WorldTreeOre"="Quặng Cây Thế Giới"
 "Coal"="Than"; "Sulfur"="Lưu Huỳnh"; "Quartz"="Thạch Anh"; "CarbonFiber"="Sợi Carbon"; "Cement"="Xi Măng"; "Charcoal"="Than Củi"
 "Gunpowder2"="Thuốc Súng (đen)"; "Gunpowder"="Thuốc Súng (loại thấp)"
 "Bio_Battery"="Bio Battery (Pin Sinh Học)"; "Corrosive_Solvent"="Corrosive Solvent (Dung Môi Ăn Mòn)"; "Bio_Coolant"="Cryogenic Coolant (Chất Làm Mát)"
 "Thermal_Core"="Thermal Core (Lõi Nhiệt)"; "AIcore"="AI Core"; "Computer"="Computer (Máy Tính)"
 "ElectricOrgan"="Electric Organ (Cơ Quan Điện)"; "FireOrgan"="Flame Organ (Cơ Quan Lửa)"; "IceOrgan"="Ice Organ (Cơ Quan Băng)"
 "UniqueMaterial_Mothman"="Explosion-Resistant Fiber (từ Silvance)"; "UniqueMaterial_FlowerPrince"="Toxin Filtering Membrane (từ Dandilord)"
 "Venom"="Venom Gland (Tuyến Độc)"; "PalDarkParts"="Dark Fragment (Mảnh Bóng Tối)"; "MeteorDrop"="Meteorite Fragment (Mảnh Thiên Thạch)"
 "CrudeOil"="Crude Oil (Dầu Thô)"; "Bone"="Bone (Xương)"; "Leather"="Leather (Da)"; "AnimalSkin"="Da Thú"
 "PalItem_ToSell_04"="Precious Claw (Móng Vuốt Quý)"; "PalItem_ToSell_05"="Precious Plume (Lông Vũ Quý)"
 "PalGenderReverse"="Pal Reverser (đổi giới tính)"; "WingGlider_Fuel"="Wing Cell (nhiên liệu Wing Pack)"; "BeamLauncherBullet"="Beam Launcher Ammo (đạn Beam)"
 "Eemerald"="Emerald (Ngọc Lục Bảo)"; "Diamond"="Diamond (Kim Cương)"; "Ruby"="Ruby"; "Sapphire"="Sapphire"; "Money"="Vàng (Tiền)"
 "WorkSuitability_AddTicket_MonsterFarm"="Sách Ranching (nuôi Pal)"; "WorkSuitability_AddTicket_Watering"="Sách Watering (tưới nước)"; "WorkSuitability_AddTicket_Seeding"="Sách Planting (trồng cây)"; "WorkSuitability_AddTicket_Collection"="Sách Gathering (thu thập)"; "WorkSuitability_AddTicket_Deforest"="Sách Lumbering (đốn gỗ)"; "WorkSuitability_AddTicket_Mining"="Sách Mining (khai thác)"; "WorkSuitability_AddTicket_EmitFlame"="Sách Kindling (đốt lửa)"; "WorkSuitability_AddTicket_Handcraft"="Sách Handiwork (thủ công)"; "WorkSuitability_AddTicket_Cool"="Sách Cooling (làm mát)"; "WorkSuitability_AddTicket_ProductMedicine"="Sách Medicine (chế thuốc)"; "WorkSuitability_AddTicket_Transport"="Sách Transporting (vận chuyển)"; "WorkSuitability_AddTicket_GenerateElectricity"="Sách Generating Electricity (phát điện)"
 "PalSphere"="Pal Sphere"; "PalSphere_Mega"="Mega Sphere"; "PalSphere_Giga"="Giga Sphere"; "PalSphere_Master"="Master Sphere"; "PalSphere_Legend"="Legendary Sphere"; "PalSphere_Ultimate"="Ultimate Sphere"; "PalSphere_Ancient_1"="Ancient Sphere I"; "PalSphere_Ancient_2"="Ancient Sphere II"
 "PAL_Growth_Stone_S"="Đá Tăng Trưởng Pal S"; "PAL_Growth_Stone_M"="Đá Tăng Trưởng Pal M"; "PAL_Growth_Stone_L"="Đá Tăng Trưởng Pal L"; "PAL_Growth_Stone_XL"="Đá Tăng Trưởng Pal XL"
 "AncientTechnologyBook_G1"="Ancient Tech Manual (điểm KT cổ)"; "TechnologyBook_G1"="Technology Manual (điểm kỹ thuật)"; "TechnologyBook_G2"="Technology Manual II"; "TechnologyBook_G3"="Technology Manual III"
}

$script:allItems=New-Object System.Collections.ArrayList
$script:names=@{}; $script:nameOf=@{}; $script:configPath=""; $script:ready=$false

function Load-Data($root) {
    $modDir=Get-ModDir $root
    $validPath=Join-Path $modDir "Scripts\GeneratedItemIDs.lua"
    $namesPath=Join-Path $modDir "ItemIDs.txt"
    $script:configPath=Join-Path $modDir "config.jsonc"
    $script:allItems.Clear(); $script:names=@{}; $script:nameOf=@{}
    if (-not (Test-Path $validPath)) { $script:ready=$false; return $false }
    $valid=@{}
    foreach ($line in [System.IO.File]::ReadAllLines($validPath)) { if ($line -match '\["([^"]+)"\]\s*=\s*true') { $valid[$matches[1]]=$true } }
    if (Test-Path $namesPath) { foreach ($line in [System.IO.File]::ReadAllLines($namesPath)) { if ($line -match '^([A-Za-z0-9_]+)\s*=\s*(.+?)\s*$') { $script:names[$matches[1]]=$matches[2] } } }
    foreach ($id in ($valid.Keys | Sort-Object)) {
        $nm=""
        if ($script:override.ContainsKey($id)) { $nm=$script:override[$id] }
        elseif ($script:names.ContainsKey($id) -and $script:names[$id] -ne "Unknown") { $nm=$script:names[$id] }
        $script:nameOf[$id]=$nm
        $has=[bool]$nm
        $disp=if ($nm) { "$nm  [$id]" } else { $id }
        [void]$script:allItems.Add([PSCustomObject]@{ Id=$id; Name=$nm; Display=$disp; HasName=$has })
    }
    $script:ready=$true; return $true
}
function Get-Name($id) { if ($script:nameOf.ContainsKey($id) -and $script:nameOf[$id]) { return $script:nameOf[$id] } return $id }

# ===== Form =====
$form=New-Object System.Windows.Forms.Form
$form.Text="Palworld Loot Tool - by Claude"; $form.Size=New-Object System.Drawing.Size(900,690)
$form.StartPosition="CenterScreen"; $form.Font=New-Object System.Drawing.Font("Segoe UI",9)

$lblPath=New-Object System.Windows.Forms.Label; $lblPath.Text="Đường dẫn game (thư mục chứa Palworld.exe):"; $lblPath.Location='12,12'; $lblPath.AutoSize=$true
$txtPath=New-Object System.Windows.Forms.TextBox; $txtPath.Location='12,32'; $txtPath.Size='640,24'; $txtPath.Text=$script:gameRoot
$btnBrowse=New-Object System.Windows.Forms.Button; $btnBrowse.Text="..."; $btnBrowse.Location='658,31'; $btnBrowse.Size='34,26'
$btnApplyPath=New-Object System.Windows.Forms.Button; $btnApplyPath.Text="Áp dụng"; $btnApplyPath.Location='700,31'; $btnApplyPath.Size='90,26'
$lblPathStat=New-Object System.Windows.Forms.Label; $lblPathStat.Location='12,58'; $lblPathStat.Size='790,18'

$chkOn=New-Object System.Windows.Forms.CheckBox; $chkOn.Text="BẬT MOD (ON)   -   bỏ chọn = OFF (game farm bình thường)"; $chkOn.Location='12,80'; $chkOn.AutoSize=$true; $chkOn.Checked=$true
$chkOn.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold); $chkOn.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67)

$lblSearch=New-Object System.Windows.Forms.Label; $lblSearch.Text="Tìm item:"; $lblSearch.Location='12,116'; $lblSearch.AutoSize=$true
$txtSearch=New-Object System.Windows.Forms.TextBox; $txtSearch.Location='80,113'; $txtSearch.Size='300,24'
$chkNamed=New-Object System.Windows.Forms.CheckBox; $chkNamed.Text="Chỉ hiện item có tên"; $chkNamed.Location='392,115'; $chkNamed.AutoSize=$true; $chkNamed.Checked=$true

$lst=New-Object System.Windows.Forms.ListBox; $lst.Location='12,144'; $lst.Size='440,410'

$btnAdd=New-Object System.Windows.Forms.Button; $btnAdd.Text="Thêm →"; $btnAdd.Location='462,230'; $btnAdd.Size='90,34'
$btnRem=New-Object System.Windows.Forms.Button; $btnRem.Text="← Xóa"; $btnRem.Location='462,272'; $btnRem.Size='90,34'

$grid=New-Object System.Windows.Forms.DataGridView; $grid.Location='562,144'; $grid.Size='320,360'
$grid.AllowUserToAddRows=$false; $grid.RowHeadersVisible=$false; $grid.SelectionMode='FullRowSelect'; $grid.AutoSizeColumnsMode='None'
$colName=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colName.HeaderText="Tên"; $colName.ReadOnly=$true; $colName.Width=185
$colQty=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colQty.HeaderText="Số lượng"; $colQty.Width=95
$colId=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colId.HeaderText="Id"; $colId.Visible=$false
$grid.Columns.AddRange($colName,$colQty,$colId)

$lblSel=New-Object System.Windows.Forms.Label; $lblSel.Text="Đã chọn: 0/7"; $lblSel.Location='562,510'; $lblSel.AutoSize=$true
$lblSel.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)

$btnSave=New-Object System.Windows.Forms.Button; $btnSave.Text="LƯU & ÁP DỤNG"; $btnSave.Location='562,534'; $btnSave.Size='320,42'
$btnSave.BackColor=[System.Drawing.Color]::FromArgb(46,160,67); $btnSave.ForeColor='White'; $btnSave.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)

$lblStatus=New-Object System.Windows.Forms.Label; $lblStatus.Location='12,566'; $lblStatus.Size='540,70'
$lblStatus.Text="Bật ON để chọn item, hoặc bỏ chọn (OFF) rồi LƯU để trở về farm bình thường. Sau khi lưu, RESTART Palworld."; $lblStatus.ForeColor=[System.Drawing.Color]::DimGray

$form.Controls.AddRange(@($lblPath,$txtPath,$btnBrowse,$btnApplyPath,$lblPathStat,$chkOn,$lblSearch,$txtSearch,$chkNamed,$lst,$btnAdd,$btnRem,$grid,$lblSel,$btnSave,$lblStatus))

# ===== Logic =====
function Refresh-Pool {
    $q=$txtSearch.Text.Trim().ToLower(); $onlyNamed=$chkNamed.Checked
    $lst.BeginUpdate(); $lst.Items.Clear()
    foreach ($it in $script:allItems) {
        if ($onlyNamed -and -not $it.HasName) { continue }
        if ($q -eq "" -or $it.Display.ToLower().Contains($q)) { [void]$lst.Items.Add($it.Display) }
    }
    $lst.EndUpdate()
}
function Update-Count { $lblSel.Text="Đã chọn: $($grid.Rows.Count)/7"; $btnAdd.Enabled=($chkOn.Checked -and $script:ready -and $grid.Rows.Count -lt 7) }
function Set-ItemEnabled {
    $on=$chkOn.Checked -and $script:ready
    $txtSearch.Enabled=$on; $lst.Enabled=$on; $btnRem.Enabled=$on; $grid.Enabled=$on; $chkNamed.Enabled=$on
    if ($chkOn.Checked) { $chkOn.Text="BẬT MOD (ON)   -   đang cho chọn item"; $chkOn.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67) }
    else { $chkOn.Text="MOD ĐANG OFF   -   tích vào để BẬT (ON)"; $chkOn.ForeColor=[System.Drawing.Color]::Firebrick }
    Update-Count
}
function Find-ItemByDisplay($disp){ foreach($it in $script:allItems){ if($it.Display -eq $disp){return $it} }; return $null }
function Load-Current {
    $grid.Rows.Clear()
    if (-not (Test-Path $script:configPath)) { $chkOn.Checked=$true; return }
    try {
        $raw=[System.IO.File]::ReadAllText($script:configPath); $clean=($raw -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
        $obj=$clean | ConvertFrom-Json; $cnt=0
        foreach ($d in $obj.Drops) { [void]$grid.Rows.Add((Get-Name $d.ItemId),$d.MinAmount,$d.ItemId); $cnt++ }
        $chkOn.Checked=($cnt -gt 0)
    } catch { $chkOn.Checked=$true }
}
function Write-Config($dropsBody) {
    $json="{`r`n  // Tao boi Palworld Loot Tool. RESTART game de ap dung.`r`n  `"Scope`": `"AllPals`",`r`n  `"IncludeBosses`": true,`r`n  `"IncludeHumans`": false,`r`n  `"IncludeOilRig`": false,`r`n  `"SpecificPals`": [ `"SheepBall`" ],`r`n  `"Drops`": [`r`n" + $dropsBody + "`r`n  ]`r`n}`r`n"
    [System.IO.File]::WriteAllText($script:configPath,$json,(New-Object System.Text.UTF8Encoding($false)))
}
function Apply-Path {
    $root=$txtPath.Text.Trim().TrimEnd('\')
    if ($root -eq "") { $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="Đường dẫn đang TRỐNG."; [System.Windows.Forms.MessageBox]::Show("Bạn chưa nhập đường dẫn game!","Thiếu đường dẫn",0,48)|Out-Null; $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled; return }
    if (Load-Data $root) { $script:gameRoot=$root; try { [System.IO.File]::WriteAllText($settingsPath,$root,(New-Object System.Text.UTF8Encoding($false))) } catch {}; $lblPathStat.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblPathStat.Text="OK - đã nhận diện mod ($($script:allItems.Count) item). Đã lưu đường dẫn."; Refresh-Pool; Load-Current; Set-ItemEnabled }
    else { $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="SAI đường dẫn - không thấy mod ở đây."; [System.Windows.Forms.MessageBox]::Show("Đường dẫn không đúng! Không tìm thấy mod CustomizableLootDrops trong:`n$root`n`nHãy chọn đúng thư mục gốc Palworld.","Sai đường dẫn",0,48)|Out-Null; $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled }
}

$btnBrowse.Add_Click({ $fb=New-Object System.Windows.Forms.FolderBrowserDialog; $fb.Description="Chọn thư mục Palworld"; if (Test-Path $txtPath.Text){$fb.SelectedPath=$txtPath.Text}; if ($fb.ShowDialog() -eq 'OK'){ $txtPath.Text=$fb.SelectedPath; Apply-Path } })
$btnApplyPath.Add_Click({ Apply-Path })
$chkOn.Add_CheckedChanged({ Set-ItemEnabled })
$chkNamed.Add_CheckedChanged({ Refresh-Pool })
$txtSearch.Add_TextChanged({ Refresh-Pool })
$lst.Add_DoubleClick({ $btnAdd.PerformClick() })
$btnAdd.Add_Click({
    if ($null -eq $lst.SelectedItem) { return }
    if ($grid.Rows.Count -ge 7) { [System.Windows.Forms.MessageBox]::Show("Tối đa 7 item thôi!","",0,48)|Out-Null; return }
    $it=Find-ItemByDisplay $lst.SelectedItem; if ($null -eq $it) { return }
    foreach ($r in $grid.Rows) { if ($r.Cells[2].Value -eq $it.Id) { return } }
    $dispName=if($it.Name){$it.Name}else{$it.Id}
    [void]$grid.Rows.Add($dispName,9999,$it.Id); Update-Count
})
$btnRem.Add_Click({ if ($grid.SelectedRows.Count -gt 0) { $grid.Rows.Remove($grid.SelectedRows[0]); Update-Count } })
$btnSave.Add_Click({
    if (-not $script:ready) { [System.Windows.Forms.MessageBox]::Show("Chưa chọn đúng đường dẫn game (hoặc để trống)! Hãy bấm 'Áp dụng' trước.","Thiếu đường dẫn",0,48)|Out-Null; return }
    if ($chkOn.Checked) {
        $grid.EndEdit()
        if ($grid.Rows.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show("Mod đang ON nhưng chưa chọn item nào.","Chưa chọn item",0,48)|Out-Null; return }
        $drops=@()
        foreach ($r in $grid.Rows) {
            $id=[string]$r.Cells[2].Value; $qtyRaw=[string]$r.Cells[1].Value; $qty=0
            if (-not [int]::TryParse($qtyRaw,[ref]$qty) -or $qty -lt 1) { [System.Windows.Forms.MessageBox]::Show("Số lượng không hợp lệ: $($r.Cells[0].Value)","Lỗi",0,48)|Out-Null; return }
            if ($qty -gt 99999) { $qty=99999 }
            $drops+=('    { "ItemId": "'+$id+'", "Chance": 100.0, "MinAmount": '+$qty+', "MaxAmount": '+$qty+' }')
        }
        try { Write-Config ($drops -join ",`r`n"); $lblStatus.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblStatus.Text="MOD ON - đã lưu ($($grid.Rows.Count) item). RESTART Palworld."; [System.Windows.Forms.MessageBox]::Show("Mod ON - đã lưu $($grid.Rows.Count) item!`n`nRESTART Palworld để áp dụng.","Xong",0,64)|Out-Null } catch { [System.Windows.Forms.MessageBox]::Show("Lỗi: $($_.Exception.Message)","Lỗi",0,16)|Out-Null }
    } else {
        try { Write-Config ""; $lblStatus.ForeColor=[System.Drawing.Color]::Firebrick; $lblStatus.Text="MOD OFF - game farm bình thường. RESTART Palworld."; [System.Windows.Forms.MessageBox]::Show("Mod OFF - game farm BÌNH THƯỜNG.`n`nRESTART Palworld để áp dụng.","Đã tắt mod",0,64)|Out-Null } catch { [System.Windows.Forms.MessageBox]::Show("Lỗi: $($_.Exception.Message)","Lỗi",0,16)|Out-Null }
    }
})

# ===== Khởi tạo =====
if (Load-Data $script:gameRoot) { $lblPathStat.ForeColor=[System.Drawing.Color]::FromArgb(46,160,67); $lblPathStat.Text="OK - đã nhận diện mod ($($script:allItems.Count) item)."; Refresh-Pool; Load-Current }
else { $lblPathStat.ForeColor=[System.Drawing.Color]::Firebrick; $lblPathStat.Text="Chưa thấy mod ở đường dẫn mặc định. Dán đường dẫn rồi bấm 'Áp dụng'." }
Set-ItemEnabled
[void]$form.ShowDialog()
