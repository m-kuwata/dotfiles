.PHONY: linux windows

linux:
	bash linux/install.sh
	bash linux/link.sh

windows:
	powershell.exe -ExecutionPolicy Bypass -File windows/setup.ps1
