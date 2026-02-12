# ----------------------------------------
# Измените пути здесь на ваши
# ----------------------------------------
PACKER := "C:\Dz\work\iemashkov\packer\packer.exe"   
VBOXMANAGE := "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"  # Adjust if needed

# Packer plugin configuration
PACKER_CONFIG_DIR := "$(CURDIR)/.config/packer"
PACKER_PLUGIN_DIR := "$(PACKER_CONFIG_DIR)/plugins"

.PHONY: all init box help

# ----------------------------------------
# Default target
# ----------------------------------------
all: init box

# ----------------------------------------
# Initialize Packer (downloads required plugins)
# ----------------------------------------
init: ## Initialize Packer and download required plugins
  @mkdir -p $(PACKER_PLUGIN_DIR)
  @export PACKER_PLUGIN_PATH=$(PACKER_PLUGIN_DIR); \
  "$(PACKER)" init -upgrade vagrant-rocky.pkr.hcl

# ----------------------------------------
# Build the box
# ----------------------------------------
box: init ## Build box for Rocky Linux using VirtualBox
  @$(VBOXMANAGE) setproperty language C
  @$(VBOXMANAGE) setproperty machinefolder "pwd/vm"
  @export TMPDIR="pwd"; \
  export PACKER_CONFIG_DIR=$(PACKER_CONFIG_DIR); \
  export PACKER_PLUGIN_PATH=$(PACKER_PLUGIN_DIR); \
  "$(PACKER)" build -only=virtualbox-iso.virtualbox vagrant-rocky.pkr.hcl
  @$(VBOXMANAGE) setproperty machinefolder default

# ----------------------------------------
# Help
# ----------------------------------------
help:
  @echo 'Usage:'
  @echo '  make <target>'
  @echo
  @echo 'Targets:'
  @grep -E '^[a-zA-Z_0-9.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
    | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
  @echo