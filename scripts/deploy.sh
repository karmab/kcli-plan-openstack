blue='\033[0;36m'
clear='\033[0m'
{% if sslip %}
echo -e "${blue}************ RUNNING 00_sslip.sh ************${clear}"
/root/scripts/00_sslip.sh
{% endif %}
echo -e "${blue}************ RUNNING 01_repo.sh ************${clear}"
/root/scripts/01_repo.sh
echo -e "${blue}************ RUNNING 02_install.sh ************${clear}"
/root/scripts/02_install.sh
echo -e "${blue}************ RUNNING 03_provision.sh ************${clear}"
/root/scripts/03_provision.sh
