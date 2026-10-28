# ChowChow Backend 시작 스크립트 (로컬 실행)
# 사용법: PowerShell에서 .\start-backend.ps1 실행 (macOS는 brew install powershell 후 pwsh ./start-backend.ps1)
# 사전 준비: pet-diet/.env, pet-diet/src/main/resources/application.yml (둘 다 gitignore 대상이라 직접 만들어야 함)

Write-Host "🚀 Backend 시작 중 (로컬)..." -ForegroundColor Green

Push-Location "$PSScriptRoot/pet-diet"
# DotenvPostProcessor가 작업 디렉터리의 .env를 읽으므로 pet-diet에서 실행해야 함
$gradlew = if ($env:OS -eq 'Windows_NT') { '.\gradlew.bat' } else { './gradlew' }
Start-Process $gradlew -ArgumentList 'bootRun' `
  -RedirectStandardOutput app.log -RedirectStandardError app-error.log | Out-Null
Pop-Location

Start-Sleep -Seconds 5

Write-Host "✅ Backend 시작 요청됨 (localhost:8080) - 첫 빌드는 1~2분 걸릴 수 있음" -ForegroundColor Green
Write-Host "📄 로그: pet-diet/app.log" -ForegroundColor Cyan
Write-Host "📍 접속 테스트: http://localhost:8080/api/auth/login" -ForegroundColor Cyan

# ─────────────────────────────────────────────────────────────
# [EC2 배포용 - 현재 비활성화]
# 다시 EC2를 쓸 때:
#   1. 위 로컬 실행 블록을 주석 처리하고 아래 블록의 주석을 해제
#   2. 인스턴스 퍼블릭 IP가 바뀌었으면 35.78.87.150을 새 IP로 교체
#      (Elastic IP를 붙이면 재시작해도 IP가 유지됨)
#   3. ~/.ssh/chowchow-key.pem 키 파일 준비
#   4. 서버의 /home/ec2-user에 최신 app.jar(./gradlew bootJar 결과물)와 .env 업로드
#   5. 프론트 api_client.dart / pet_raising_3d_page.dart의 서버 주소도 EC2로 되돌리기
#
# ssh -i ~/.ssh/chowchow-key.pem ec2-user@35.78.87.150 `
#   "cd /home/ec2-user && source .env && nohup java -jar app.jar > app.log 2>&1 &"
#
# Start-Sleep -Seconds 5
#
# Write-Host "✅ Backend 시작됨 (35.78.87.150:8080)" -ForegroundColor Green
# Write-Host "📍 접속 테스트: http://35.78.87.150:8080/api/auth/login" -ForegroundColor Cyan
