class Eun2ceSettings < Formula
  desc "Personal settings manager for VSCode"
  homepage "https://github.com/eun2ce/settings"
  version "1.0.0"
  
  # 실제 릴리스 URL로 교체해야 합니다
  url "https://github.com/eun2ce/settings/releases/download/v1.0.0/eun2ce-settings.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"

  depends_on "visual-studio-code" => :optional

  def install
    bin.install "bin/eun2ce-settings"
    prefix.install "vscode"
  end
end 