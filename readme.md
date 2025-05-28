# settings

## getting started

```bash
# macOS
brew tap eun2ce/tap
brew install eun2ce-settings
eun2ce-settings vscode setup

# Windows (PowerShell)
curl -LO $(curl -s https://api.github.com/repos/eun2ce/settings/releases/latest | Select-String -Pattern "browser_download_url.*windows.zip" | Select-String -Pattern "https://.*windows.zip" -AllMatches | % { $_.Matches } | % { $_.Value })
Expand-Archive -Path eun2ce-settings-windows.zip -DestinationPath .
.\eun2ce-settings.ps1 vscode setup

# manual (Unix)
curl -L https://github.com/eun2ce/settings/releases/latest/download/eun2ce-settings.tar.gz | tar xz
chmod +x bin/eun2ce-settings
./bin/eun2ce-settings vscode setup

# release
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```
