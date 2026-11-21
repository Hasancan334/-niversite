# Projeyi GitHub'daki main dalıyla güvenle eşitler.
# Kullanım (proje klasöründe):  powershell -ExecutionPolicy Bypass -File guncelle.ps1
# Yerelde kaydedilmemiş değişiklik varsa HİÇBİR ŞEYİ değiştirmez, ne olduğunu gösterir.

Write-Host "GitHub'dan son durum alınıyor..." -ForegroundColor Cyan
git fetch origin main
if ($LASTEXITCODE -ne 0) { Write-Host "HATA: GitHub'a bağlanılamadı." -ForegroundColor Red; exit 1 }

# Yarım kalmış birleştirme (merge) varsa önce onu bitir
if (Test-Path .git/MERGE_HEAD) {
    Write-Host "Yarım kalmış bir birleştirme var, tamamlanıyor..." -ForegroundColor Cyan
    git commit --no-edit
    if ($LASTEXITCODE -ne 0) { Write-Host "HATA: Birleştirmede çakışma var, 'git status' çıktısını Claude'a gönder." -ForegroundColor Red; exit 1 }
}

git checkout main 2>$null

$degisen = git status --porcelain --untracked-files=no
if ($degisen) {
    Write-Host ""
    Write-Host "DURDU: Bu dosyalarda kaydedilmemiş değişikliğin var:" -ForegroundColor Yellow
    git status --short --untracked-files=no
    Write-Host ""
    git diff
    Write-Host ""
    Write-Host "Güncelleme bu yüzden yapılamıyor. Seçenekler:" -ForegroundColor Yellow
    Write-Host "  1) Değişiklik önemliyse (ör. şifre DEĞİL, sürüm numarası gibi) Claude'a yukarıdaki çıktıyı gönder, depoya ekletelim."
    Write-Host "  2) Değişiklik gereksizse sil:   git checkout -- <dosya_adı>"
    Write-Host "Sonra bu betiği tekrar çalıştır."
    exit 1
}

# Önce hızlı ileri sar; yerelde gönderilmemiş commit varsa birleştir ve GitHub'a gönder
git merge --ff-only origin/main 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Yerelde GitHub'a gönderilmemiş commit var, birleştiriliyor..." -ForegroundColor Cyan
    git merge --no-edit origin/main
    if ($LASTEXITCODE -ne 0) { Write-Host "HATA: Çakışma var, 'git status' çıktısını Claude'a gönder." -ForegroundColor Red; exit 1 }
    git push origin main
    if ($LASTEXITCODE -ne 0) { Write-Host "HATA: GitHub'a gönderilemedi." -ForegroundColor Red; exit 1 }
}
git fetch origin main

$yerel = git rev-parse --short HEAD
$uzak  = git rev-parse --short origin/main
if ($yerel -ne $uzak) { Write-Host "HATA: Yerel ($yerel) ile GitHub ($uzak) farklı." -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "TAMAM: Kod güncel ->" -ForegroundColor Green
git log --oneline -1
Write-Host ""
Write-Host "Önbellek temizleniyor (logo/resim değişiklikleri için gerekli)..." -ForegroundColor Cyan
flutter clean
flutter pub get
Write-Host ""
Write-Host "Hazır. Şimdi çalıştır:  flutter run --flavor <flavor>" -ForegroundColor Green
