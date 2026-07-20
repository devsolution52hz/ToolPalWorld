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
 "PalAwakening_Water"="Đá Thức Tỉnh hệ Nước"; "PalAwakening_Electric"="Đá Thức Tỉnh hệ Điện"; "PalAwakening_Fire"="Đá Thức Tỉnh hệ Lửa"; "PalAwakening_Grass"="Đá Thức Tỉnh hệ Cỏ"; "PalAwakening_Ground"="Đá Thức Tỉnh hệ Đất"; "PalAwakening_Ice"="Đá Thức Tỉnh hệ Băng"; "PalAwakening_Dragon"="Đá Thức Tỉnh hệ Rồng"; "PalAwakening_Dark"="Đá Thức Tỉnh hệ Bóng Tối"; "PalAwakening_Neutral"="Đá Thức Tỉnh hệ Trung Tính"
 "PalAwakening_Material_Water"="Radiant Gem hệ Nước"; "PalAwakening_Material_Electric"="Radiant Gem hệ Điện"; "PalAwakening_Material_Fire"="Radiant Gem hệ Lửa"; "PalAwakening_Material_Grass"="Radiant Gem hệ Cỏ"; "PalAwakening_Material_Ground"="Radiant Gem hệ Đất"; "PalAwakening_Material_Ice"="Radiant Gem hệ Băng"; "PalAwakening_Material_Dragon"="Radiant Gem hệ Rồng"; "PalAwakening_Material_Dark"="Radiant Gem hệ Bóng Tối"; "PalAwakening_Material_Neutral"="Radiant Gem hệ Trung Tính"
 "PalUpgradeStone"="Hồn Pal Nhỏ"; "PalUpgradeStone2"="Hồn Pal Vừa"; "PalUpgradeStone3"="Hồn Pal Lớn"; "PalUpgradeStone4"="Hồn Pal Khổng Lồ"
 "Rankup_1"="Starfruit ☆1"; "Rankup_2"="Starfruit ☆2"; "Rankup_3"="Starfruit ☆3"; "Rankup_4"="Starfruit ☆4"; "Rankup_Arbitrary"="Ripe Starfruit (nâng bất kỳ +1)"
 "Fruit_hp_01"="Life Fruit (tăng Máu)"; "Fruit_attack_01"="Attack Fruit (tăng Tấn công)"; "Fruit__defense_01"="Defense Fruit (tăng Phòng thủ)"; "AffectionFruit_01"="Affection Fruit (thân thiết)"; "AffectionFruit_02"="Affection Fruit II"
 "IronIngot"="Thỏi Sắt"; "CopperIngot"="Thỏi Đồng"; "ManganeseIngot"="Thỏi Mangan"; "StealIngot"="Thỏi Thép"; "SkyislandIngot"="Thỏi Đảo Trời"; "WorldTreeIngot"="Thỏi Cây Thế Giới"
 "IronOre"="Quặng Sắt"; "CopperOre"="Quặng Đồng"; "ManganeseOre"="Quặng Mangan"; "SkyIslandOre"="Quặng Đảo Trời"; "WorldTreeOre"="Quặng Cây Thế Giới"
 "Coal"="Than"; "Sulfur"="Lưu Huỳnh"; "Quartz"="Thạch Anh"; "CarbonFiber"="Sợi Carbon"; "Cement"="Xi Măng"; "Charcoal"="Than Củi"; "Cloth"="Vải (Cloth)"
 "Gunpowder2"="Thuốc Súng (đen)"; "Gunpowder"="Thuốc Súng (loại thấp)"
 "HandgunBullet"="Đạn Súng Lục"; "AssaultRifleBullet"="Đạn Súng Trường Tấn Công"; "RifleBullet"="Đạn Súng Trường"; "ShotgunBullet"="Đạn Shotgun"; "MagnumBullet"="Đạn Magnum"; "GatlingBullet"="Đạn Gatling"; "MachingunBullet"="Đạn Súng Máy"; "SmallBullet"="Đạn Cỡ Nhỏ"; "LargeBullet"="Đạn Cỡ Lớn"; "RoughBullet"="Đạn Thô"; "ExplosiveBullet"="Đạn Nổ"; "GrenadeBullet"="Đạn Lựu"; "MissileBullet"="Đạn Tên Lửa"; "MeteorBullet"="Đạn Thiên Thạch"; "InkBullet"="Đạn Mực"; "FlamethrowerBullet"="Đạn Súng Phun Lửa"
 "LaserBullet"="Đạn Laser"; "LaserGatlingBullet"="Đạn Gatling Laser"; "ChargeLaserRifleBullet"="Đạn Súng Laser Sạc"; "ElectricArcAssaultRifleBullet"="Đạn Hồ Quang Điện"; "EnergyLauncherBullet"="Đạn Phóng Năng Lượng"; "EnergyShotgunBullet"="Đạn Shotgun Năng Lượng"; "OverheatRifleBullet"="Đạn Súng Quá Nhiệt (Plasma)"; "PalDopingShotBullet"="Đạn Doping Pal"; "SkyAssaultRifleBullet"="Đạn Súng Trường Đảo Trời"; "SkyShotgunBullet"="Đạn Shotgun Đảo Trời"; "SkySubmachineGunBullet"="Đạn Tiểu Liên Đảo Trời"; "SkyGrenadeLauncherBullet"="Đạn Phóng Lựu Đảo Trời"; "SkyHeavyBullet"="Đạn Nặng Đảo Trời"; "SkyLightBullet"="Đạn Nhẹ Đảo Trời"; "WidePenetrateShotgunBullet"="Đạn Shotgun Xuyên Rộng"
 "Arrow"="Mũi Tên"; "Arrow_Fire"="Mũi Tên Lửa"; "Arrow_Poison"="Mũi Tên Độc"; "ReinforcedArrow"="Mũi Tên Gia Cố"; "SFArrow"="Mũi Tên SF"; "SkyBowArrow"="Mũi Tên Cung Đảo Trời"
 "FragGrenade"="Lựu Đạn (thường)"; "FragGrenade_Fire"="Lựu Đạn Lửa"; "FragGrenade_Ice"="Lựu Đạn Băng"; "FragGrenade_Elec"="Lựu Đạn Sốc Điện (Shock)"; "FragGrenade_Water"="Lựu Đạn Nước"; "FragGrenade_Leaf"="Lựu Đạn Cỏ"; "FragGrenade_Ground"="Lựu Đạn Đất"; "FragGrenade_Dragon"="Lựu Đạn Rồng"; "FragGrenade_Dark"="Lựu Đạn Bóng Tối"; "FragGrenade_Super"="Lựu Đạn Siêu Cấp"; "PalHealingGrenade"="Lựu Đạn Hồi Máu Pal"
 "WhaleWhistle"="Echoing Flute (triệu hồi Ocean King)"; "WhaleWhistleFragment_01"="Echobone: Marine"; "WhaleWhistleFragment_02"="Echobone: Silent"; "WhaleWhistleFragment_03"="Echobone: Seafoam"; "WhaleWhistleFragment_04"="Echobone: Tidewind"
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
$script:names=@{}; $script:nameOf=@{}; $script:configPath=""; $script:ready=$false; $script:toggleOn=$true

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
        $script:nameOf[$id]=$nm; $has=[bool]$nm
        $disp=if ($nm) { "$nm  [$id]" } else { $id }
        [void]$script:allItems.Add([PSCustomObject]@{ Id=$id; Name=$nm; Display=$disp; HasName=$has; Cat=(Get-Category $id) })
    }
    $script:ready=$true; return $true
}
function Get-Name($id) { if ($script:nameOf.ContainsKey($id) -and $script:nameOf[$id]) { return $script:nameOf[$id] } return $id }
function Get-Category($id) {
    if ($id -match '^WhaleWhistle|Echobone|^KeySphere|^Blueprint_.*Boss|Relic_Boss|^SummonItem') { return "Đặc biệt / Key Items" }
    if ($id -match 'Bullet$' -or $id -match 'Arrow') { return "Đạn & Cung tên" }
    if ($id -match 'Ingot$') { return "Thỏi kim loại" }
    if ($id -match 'Ore$' -or $id -match '^(Coal|Sulfur|Quartz|Sand|NightStone|Chromium|Charcoal|StainlessSteel|CrudeOil|Cement|CarbonFiber)$') { return "Quặng & Khoáng" }
    if ($id -match '^PalAwakening_Material') { return "Nguyên liệu Pal" }
    if ($id -match '^PalAwakening') { return "Đá Thức Tỉnh" }
    if ($id -match '^PalUpgradeStone|^PAL_Growth_Stone|^Fruit_|^Rankup_|^AffectionFruit|^Elixir_|^Lotus_') { return "Nâng cấp Pal" }
    if ($id -match '^PalSphere|^KeySphere') { return "Cầu Pal" }
    if ($id -match '^WorkSuitability') { return "Sách kỹ năng" }
    if ($id -match '^(Diamond|Ruby|Sapphire|Eemerald)$') { return "Đá quý" }
    if ($id -match 'Armor|Helmet|Shield|Glider|Accessory|Pendant') { return "Giáp & Trang bị" }
    if ($id -match 'Rifle|Handgun|Shotgun|Launcher|Sword|_Bow|Gatling|Spear|Crossbow|Pickaxe|_Axe|Hammer|Flamethrower|Musket|Knuckle|Grapple|Grenade' -and $id -notmatch 'Bullet|Blueprint') { return "Vũ khí" }
    if ($id -match 'Organ$|Fragment|^UniqueMaterial|^PalDarkParts|^Venom$|^Bone$|^Leather$|^AnimalSkin$|^Wool$|^Wood|^WorldTreeRelic|^AncientParts|^PalCrystal|^MeteorDrop$|^Cloth|^Bio_|^Thermal_Core$|^AIcore$|^Computer$|^ElectronicCircuit$|^WorldTreeHolyWater$|^Horn$|^PalItem_') { return "Nguyên liệu Pal" }
    return "Khác"
}
function New-RoundRect($x,$y,$w,$h,$r) {
    $p=New-Object System.Drawing.Drawing2D.GraphicsPath; $d=$r*2
    $p.AddArc($x,$y,$d,$d,180,90); $p.AddArc($x+$w-$d,$y,$d,$d,270,90); $p.AddArc($x+$w-$d,$y+$h-$d,$d,$d,0,90); $p.AddArc($x,$y+$h-$d,$d,$d,90,90); $p.CloseFigure(); return $p
}

# ===== Mau =====
$cBg    = [System.Drawing.Color]::FromArgb(245,246,248)
$cGreen = [System.Drawing.Color]::FromArgb(46,204,113)
$cBlue  = [System.Drawing.Color]::FromArgb(52,152,219)
$cGray  = [System.Drawing.Color]::FromArgb(149,165,166)
$cDark  = [System.Drawing.Color]::FromArgb(44,62,80)
$cRed   = [System.Drawing.Color]::FromArgb(192,57,43)

function Style-Btn($b,$bg,$fg){ $b.FlatStyle='Flat'; $b.FlatAppearance.BorderSize=0; $b.BackColor=$bg; $b.ForeColor=$fg; $b.Cursor='Hand'; $b.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold) }

# ===== Form =====
$form=New-Object System.Windows.Forms.Form
$form.Text="Palworld Loot Tool"; $form.Size=New-Object System.Drawing.Size(920,720)
$form.StartPosition="CenterScreen"; $form.Font=New-Object System.Drawing.Font("Segoe UI",9); $form.BackColor=$cBg

# Header
$header=New-Object System.Windows.Forms.Panel; $header.Location='0,0'; $header.Size='920,54'; $header.BackColor=$cDark
$lblTitle=New-Object System.Windows.Forms.Label; $lblTitle.Text="🎮  PALWORLD LOOT TOOL"; $lblTitle.ForeColor='White'; $lblTitle.Location='18,12'; $lblTitle.AutoSize=$true
$lblTitle.Font=New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$header.Controls.Add($lblTitle)

# Path
$lblPath=New-Object System.Windows.Forms.Label; $lblPath.Text="Đường dẫn game (thư mục chứa Palworld.exe):"; $lblPath.Location='18,68'; $lblPath.AutoSize=$true; $lblPath.ForeColor=$cDark
$txtPath=New-Object System.Windows.Forms.TextBox; $txtPath.Location='18,88'; $txtPath.Size='650,26'; $txtPath.Text=$script:gameRoot; $txtPath.BorderStyle='FixedSingle'
$btnBrowse=New-Object System.Windows.Forms.Button; $btnBrowse.Text="..."; $btnBrowse.Location='674,87'; $btnBrowse.Size='36,28'; Style-Btn $btnBrowse $cGray 'White'
$btnApplyPath=New-Object System.Windows.Forms.Button; $btnApplyPath.Text="Áp dụng"; $btnApplyPath.Location='716,87'; $btnApplyPath.Size='90,28'; Style-Btn $btnApplyPath $cBlue 'White'
$lblPathStat=New-Object System.Windows.Forms.Label; $lblPathStat.Location='18,118'; $lblPathStat.Size='860,18'

# Toggle
$toggle=New-Object System.Windows.Forms.Panel; $toggle.Location='18,146'; $toggle.Size='96,36'; $toggle.Cursor='Hand'; $toggle.BackColor=$cBg
$toggle.Add_Paint({
    param($s,$e)
    $g=$e.Graphics; $g.SmoothingMode='AntiAlias'
    $w=$s.Width; $h=$s.Height
    $bgc = if ($script:toggleOn) { [System.Drawing.Color]::FromArgb(46,204,113) } else { [System.Drawing.Color]::FromArgb(189,195,199) }
    $path=New-RoundRect 0 0 ($w-1) ($h-1) ([int]($h/2))
    $br=New-Object System.Drawing.SolidBrush $bgc; $g.FillPath($br,$path); $br.Dispose()
    $d=$h-8; $kx = if ($script:toggleOn) { $w-$d-4 } else { 4 }
    $wb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White); $g.FillEllipse($wb,$kx,4,$d,$d); $wb.Dispose()
    $txt = if ($script:toggleOn) { "ON" } else { "OFF" }
    $fnt=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
    $sf=New-Object System.Drawing.StringFormat; $sf.Alignment='Center'; $sf.LineAlignment='Center'
    $tb=New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    if ($script:toggleOn) { $rect=New-Object System.Drawing.RectangleF 4,0,($w-$d-8),$h } else { $rect=New-Object System.Drawing.RectangleF ($d+4),0,($w-$d-8),$h }
    $g.DrawString($txt,$fnt,$tb,$rect,$sf); $tb.Dispose()
})
$lblToggleState=New-Object System.Windows.Forms.Label; $lblToggleState.Location='126,155'; $lblToggleState.AutoSize=$true; $lblToggleState.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)

# Item area
$lblSearch=New-Object System.Windows.Forms.Label; $lblSearch.Text="Tìm item:"; $lblSearch.Location='18,200'; $lblSearch.AutoSize=$true; $lblSearch.ForeColor=$cDark
$txtSearch=New-Object System.Windows.Forms.TextBox; $txtSearch.Location='86,197'; $txtSearch.Size='300,26'; $txtSearch.BorderStyle='FixedSingle'
$chkNamed=New-Object System.Windows.Forms.CheckBox; $chkNamed.Text="Chỉ hiện item có tên"; $chkNamed.Location='400,199'; $chkNamed.AutoSize=$true; $chkNamed.Checked=$true; $chkNamed.ForeColor=$cDark
$lblCat=New-Object System.Windows.Forms.Label; $lblCat.Text="Danh mục:"; $lblCat.Location='560,200'; $lblCat.AutoSize=$true; $lblCat.ForeColor=$cDark
$cboCat=New-Object System.Windows.Forms.ComboBox; $cboCat.Location='632,197'; $cboCat.Size='256,26'; $cboCat.DropDownStyle='DropDownList'
[void]$cboCat.Items.AddRange(@("Tất cả","Quặng & Khoáng","Thỏi kim loại","Đạn & Cung tên","Vũ khí","Giáp & Trang bị","Nguyên liệu Pal","Đá Thức Tỉnh","Nâng cấp Pal","Cầu Pal","Sách kỹ năng","Đá quý","Đặc biệt / Key Items","Khác"))
$cboCat.SelectedIndex=0

$lst=New-Object System.Windows.Forms.ListBox; $lst.Location='18,230'; $lst.Size='450,412'; $lst.BorderStyle='FixedSingle'; $lst.Font=New-Object System.Drawing.Font("Segoe UI",9)

$btnAdd=New-Object System.Windows.Forms.Button; $btnAdd.Text="Thêm →"; $btnAdd.Location='480,320'; $btnAdd.Size='96,36'; Style-Btn $btnAdd $cBlue 'White'
$btnRem=New-Object System.Windows.Forms.Button; $btnRem.Text="← Xóa"; $btnRem.Location='480,364'; $btnRem.Size='96,36'; Style-Btn $btnRem $cGray 'White'

$grid=New-Object System.Windows.Forms.DataGridView; $grid.Location='588,230'; $grid.Size='300,380'
$grid.AllowUserToAddRows=$false; $grid.RowHeadersVisible=$false; $grid.SelectionMode='FullRowSelect'; $grid.AutoSizeColumnsMode='None'
$grid.BorderStyle='FixedSingle'; $grid.BackgroundColor='White'; $grid.EnableHeadersVisualStyles=$false
$grid.ColumnHeadersDefaultCellStyle.BackColor=$cDark; $grid.ColumnHeadersDefaultCellStyle.ForeColor='White'; $grid.ColumnHeadersDefaultCellStyle.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)
$colName=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colName.HeaderText="Tên"; $colName.ReadOnly=$true; $colName.Width=185
$colQty=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colQty.HeaderText="Số lượng"; $colQty.Width=90
$colId=New-Object System.Windows.Forms.DataGridViewTextBoxColumn; $colId.HeaderText="Id"; $colId.Visible=$false
$grid.Columns.AddRange($colName,$colQty,$colId)

$lblSel=New-Object System.Windows.Forms.Label; $lblSel.Text="Đã chọn: 0/7"; $lblSel.Location='588,616'; $lblSel.AutoSize=$true; $lblSel.ForeColor=$cDark
$lblSel.Font=New-Object System.Drawing.Font("Segoe UI",9,[System.Drawing.FontStyle]::Bold)

$btnSave=New-Object System.Windows.Forms.Button; $btnSave.Text="💾  LƯU & ÁP DỤNG"; $btnSave.Location='18,652'; $btnSave.Size='870,44'; Style-Btn $btnSave $cGreen 'White'
$btnSave.Font=New-Object System.Drawing.Font("Segoe UI",11,[System.Drawing.FontStyle]::Bold)

$lblStatus=New-Object System.Windows.Forms.Label; $lblStatus.Location='18,632'; $lblStatus.Size='550,18'
$lblStatus.Text="Sau khi lưu, RESTART Palworld (thoát hẳn + mở lại) để áp dụng."; $lblStatus.ForeColor=[System.Drawing.Color]::DimGray

$form.Controls.AddRange(@($header,$lblPath,$txtPath,$btnBrowse,$btnApplyPath,$lblPathStat,$toggle,$lblToggleState,$lblSearch,$txtSearch,$chkNamed,$lblCat,$cboCat,$lst,$btnAdd,$btnRem,$grid,$lblSel,$lblStatus,$btnSave))

# ===== Logic =====
function Refresh-Pool {
    $q=$txtSearch.Text.Trim().ToLower(); $onlyNamed=$chkNamed.Checked; $cat=[string]$cboCat.SelectedItem
    $lst.BeginUpdate(); $lst.Items.Clear()
    foreach ($it in $script:allItems) {
        if ($onlyNamed -and -not $it.HasName) { continue }
        if ($cat -and $cat -ne "Tất cả" -and $it.Cat -ne $cat) { continue }
        if ($q -eq "" -or $it.Display.ToLower().Contains($q)) { [void]$lst.Items.Add($it.Display) }
    }
    $lst.EndUpdate()
}
function Update-Count { $lblSel.Text="Đã chọn: $($grid.Rows.Count)/7"; $btnAdd.Enabled=($script:toggleOn -and $script:ready -and $grid.Rows.Count -lt 7) }
function Set-ItemEnabled {
    $on=$script:toggleOn -and $script:ready
    $txtSearch.Enabled=$on; $lst.Enabled=$on; $btnRem.Enabled=$on; $grid.Enabled=$on; $chkNamed.Enabled=$on
    if ($script:toggleOn) { $lblToggleState.Text="Đang BẬT — chọn item để farm"; $lblToggleState.ForeColor=$cGreen }
    else { $lblToggleState.Text="Đang TẮT — game farm bình thường"; $lblToggleState.ForeColor=$cGray }
    Update-Count
}
function Set-Toggle($on) { $script:toggleOn=$on; $toggle.Invalidate(); Set-ItemEnabled }
function Find-ItemByDisplay($disp){ foreach($it in $script:allItems){ if($it.Display -eq $disp){return $it} }; return $null }
function Load-Current {
    $grid.Rows.Clear()
    if (-not (Test-Path $script:configPath)) { Set-Toggle $true; return }
    try {
        $raw=[System.IO.File]::ReadAllText($script:configPath); $clean=($raw -split "`n" | Where-Object { $_ -notmatch '^\s*//' }) -join "`n"
        $obj=$clean | ConvertFrom-Json; $cnt=0
        foreach ($d in $obj.Drops) { [void]$grid.Rows.Add((Get-Name $d.ItemId),$d.MinAmount,$d.ItemId); $cnt++ }
        Set-Toggle ($cnt -gt 0)
    } catch { Set-Toggle $true }
}
function Write-Config($dropsBody) {
    $json="{`r`n  // Tao boi Palworld Loot Tool. RESTART game de ap dung.`r`n  `"Scope`": `"AllPals`",`r`n  `"IncludeBosses`": true,`r`n  `"IncludeHumans`": false,`r`n  `"IncludeOilRig`": false,`r`n  `"SpecificPals`": [ `"SheepBall`" ],`r`n  `"Drops`": [`r`n" + $dropsBody + "`r`n  ]`r`n}`r`n"
    [System.IO.File]::WriteAllText($script:configPath,$json,(New-Object System.Text.UTF8Encoding($false)))
}
function Apply-Path {
    $root=$txtPath.Text.Trim().TrimEnd('\')
    if ($root -eq "") { $lblPathStat.ForeColor=$cRed; $lblPathStat.Text="Đường dẫn đang TRỐNG."; [System.Windows.Forms.MessageBox]::Show("Bạn chưa nhập đường dẫn game!","Thiếu đường dẫn",0,48)|Out-Null; $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled; return }
    if (Load-Data $root) { $script:gameRoot=$root; try { [System.IO.File]::WriteAllText($settingsPath,$root,(New-Object System.Text.UTF8Encoding($false))) } catch {}; $lblPathStat.ForeColor=$cGreen; $lblPathStat.Text="✓  Đã nhận diện mod ($($script:allItems.Count) item). Đã lưu đường dẫn."; Refresh-Pool; Load-Current }
    else { $lblPathStat.ForeColor=$cRed; $lblPathStat.Text="✗  Sai đường dẫn — không thấy mod ở đây."; [System.Windows.Forms.MessageBox]::Show("Đường dẫn không đúng! Không tìm thấy mod CustomizableLootDrops trong:`n$root`n`nHãy chọn đúng thư mục gốc Palworld.","Sai đường dẫn",0,48)|Out-Null; $script:ready=$false; $lst.Items.Clear(); $grid.Rows.Clear(); Set-ItemEnabled }
}

$toggle.Add_Click({ if ($script:ready) { Set-Toggle (-not $script:toggleOn) } })
$lblToggleState.Add_Click({ if ($script:ready) { Set-Toggle (-not $script:toggleOn) } })
$btnBrowse.Add_Click({ $fb=New-Object System.Windows.Forms.FolderBrowserDialog; $fb.Description="Chọn thư mục Palworld"; if (Test-Path $txtPath.Text){$fb.SelectedPath=$txtPath.Text}; if ($fb.ShowDialog() -eq 'OK'){ $txtPath.Text=$fb.SelectedPath; Apply-Path } })
$btnApplyPath.Add_Click({ Apply-Path })
$chkNamed.Add_CheckedChanged({ Refresh-Pool })
$cboCat.Add_SelectedIndexChanged({ Refresh-Pool })
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
$grid.Add_CellEndEdit({
    param($s,$e)
    if ($e.ColumnIndex -ne 1) { return }
    $row=$grid.Rows[$e.RowIndex]; $id=[string]$row.Cells[2].Value; $raw=[string]$row.Cells[1].Value; $q=0
    if (-not [int]::TryParse($raw,[ref]$q) -or $q -lt 1) { $row.Cells[1].Value=1; return }
    $max = if ($id -eq "Money") { 10000000 } else { 9999 }
    if ($q -gt $max) { $q=$max }
    $row.Cells[1].Value=$q
})
$btnSave.Add_Click({
    if (-not $script:ready) { [System.Windows.Forms.MessageBox]::Show("Chưa chọn đúng đường dẫn game (hoặc để trống)! Hãy bấm 'Áp dụng' trước.","Thiếu đường dẫn",0,48)|Out-Null; return }
    if ($script:toggleOn) {
        $grid.EndEdit()
        if ($grid.Rows.Count -eq 0) { [System.Windows.Forms.MessageBox]::Show("Mod đang BẬT nhưng chưa chọn item nào.","Chưa chọn item",0,48)|Out-Null; return }
        $drops=@(); $hasBig=$false
        foreach ($r in $grid.Rows) {
            $id=[string]$r.Cells[2].Value; $qtyRaw=[string]$r.Cells[1].Value; $qty=0
            if (-not [int]::TryParse($qtyRaw,[ref]$qty) -or $qty -lt 1) { [System.Windows.Forms.MessageBox]::Show("Số lượng không hợp lệ: $($r.Cells[0].Value)","Lỗi",0,48)|Out-Null; return }
            $max = if ($id -eq "Money") { 10000000 } else { 9999 }
            if ($qty -gt $max) { $qty=$max; $r.Cells[1].Value=$qty }
            if ($qty -ge 1000) { $hasBig=$true }
            $drops+=('    { "ItemId": "'+$id+'", "Chance": 100.0, "MinAmount": '+$qty+', "MaxAmount": '+$qty+' }')
        }
        if ($hasBig) {
            $res=[System.Windows.Forms.MessageBox]::Show("⚠️ Việc chỉnh vật phẩm với số lượng lớn (từ 1000 trở lên) có thể gây MẤT CÂN BẰNG và ảnh hưởng đến trải nghiệm game.`n`nGiới hạn: vật phẩm thường tối đa 9999, riêng Vàng tối đa 10 triệu.`n`nBạn có chắc muốn tiếp tục lưu?","Cảnh báo cân bằng",4,48)
            if ($res -ne 'Yes') { return }
        }
        try { Write-Config ($drops -join ",`r`n"); $lblStatus.ForeColor=$cGreen; $lblStatus.Text="✓ MOD BẬT — đã lưu $($grid.Rows.Count) item. RESTART Palworld."; [System.Windows.Forms.MessageBox]::Show("Mod BẬT — đã lưu $($grid.Rows.Count) item!`n`nRESTART Palworld để áp dụng.","Xong",0,64)|Out-Null } catch { [System.Windows.Forms.MessageBox]::Show("Lỗi: $($_.Exception.Message)","Lỗi",0,16)|Out-Null }
    } else {
        try { Write-Config ""; $lblStatus.ForeColor=$cRed; $lblStatus.Text="MOD TẮT — game farm bình thường. RESTART Palworld."; [System.Windows.Forms.MessageBox]::Show("Mod TẮT — game farm BÌNH THƯỜNG.`n`nRESTART Palworld để áp dụng.","Đã tắt mod",0,64)|Out-Null } catch { [System.Windows.Forms.MessageBox]::Show("Lỗi: $($_.Exception.Message)","Lỗi",0,16)|Out-Null }
    }
})

# ===== Khởi tạo =====
if (Load-Data $script:gameRoot) { $lblPathStat.ForeColor=$cGreen; $lblPathStat.Text="✓  Đã nhận diện mod ($($script:allItems.Count) item)."; Refresh-Pool; Load-Current }
else { $lblPathStat.ForeColor=$cRed; $lblPathStat.Text="✗  Chưa thấy mod ở đường dẫn mặc định. Dán đường dẫn rồi bấm 'Áp dụng'."; Set-ItemEnabled }
[void]$form.ShowDialog()
