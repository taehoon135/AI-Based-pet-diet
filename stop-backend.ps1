# ChowChow Backend 중단 스크립트 (로컬 실행)
# 사용법: PowerShell에서 .\stop-backend.ps1 실행 (macOS는 pwsh ./stop-backend.ps1)

Write-Host "⏹️  Backend 중단 중 (로컬)..." -ForegroundColor Yellow

# bootRun은 Gradle이 별도 java 프로세스를 띄우므로 8080 포트를 잡고 있는 프로세스를 종료
if ($env:OS -eq 'Windows_NT') {
  $pids = (Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue).OwningProcess
} else {
  $pids = lsof -ti tcp:8080 -sTCP:LISTEN
}
$pids | Sort-Object -Unique | ForEach-Object { Stop-Process -Id $_ -Force }

Write-Host "✅ Backend 중단됨" -ForegroundColor Green

# ─────────────────────────────────────────────────────────────
# [EC2 배포용 - 현재 비활성화]
# 다시 EC2를 쓸 때: 위 로컬 블록을 주석 처리하고 아래 주석 해제 (IP가 바뀌었으면 교체)
# 참고: pkill -9 java는 서버의 모든 java 프로세스를 죽이므로,
#       다른 java 앱을 같이 띄울 거라면 "pkill -f app.jar"로 바꾸는 게 안전함
#
# ssh -i ~/.ssh/chowchow-key.pem ec2-user@35.78.87.150 "pkill -9 java"
#
# Write-Host "✅ Backend 중단됨" -ForegroundColor Green
