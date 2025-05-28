# VSCode 설정 경로
$SETTINGS_PREFIX = "C:\Program Files\eun2ce-settings"
$VSCODE_CONFIG_DIR = "$env:APPDATA\Code\User"

function Setup-VSCode {
    Write-Host "Setting up VSCode configuration..."
    
    # VSCode 설정 디렉토리 생성
    New-Item -ItemType Directory -Force -Path $VSCODE_CONFIG_DIR | Out-Null

    # 설정 파일 복사
    Copy-Item "$SETTINGS_PREFIX\vscode\settings.json" "$VSCODE_CONFIG_DIR\settings.json" -Force
    Copy-Item "$SETTINGS_PREFIX\vscode\keybindings.json" "$VSCODE_CONFIG_DIR\keybindings.json" -Force

    # 확장 프로그램 설치
    Get-Content "$SETTINGS_PREFIX\vscode\extensions.txt" | ForEach-Object {
        $extension = $_.Trim()
        if ($extension -and !$extension.StartsWith("#")) {
            code --install-extension $extension
        }
    }

    Write-Host "VSCode setup completed!"
}

function Show-Help {
    Write-Host "Usage: eun2ce-settings <command> [options]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  vscode setup    Setup VSCode configuration"
    Write-Host "  help           Show this help message"
}

# 메인 로직
switch ($args[0]) {
    "vscode" {
        switch ($args[1]) {
            "setup" { Setup-VSCode }
            default {
                Write-Host "Error: Unknown vscode subcommand"
                Show-Help
                exit 1
            }
        }
    }
    "help" { Show-Help }
    "--help" { Show-Help }
    "-h" { Show-Help }
    default {
        Write-Host "Error: Unknown command"
        Show-Help
        exit 1
    }
} 