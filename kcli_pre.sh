{% if image not in ['centos8stream', 'centos9stream'] %}
echo Only centos8stream or centos9stream images are supported && exit 1
{% endif %}
