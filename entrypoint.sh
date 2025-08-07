#!/usr/bin/env sh

if [ "$#" -eq 3 ] && { [ "$3" = "--help" ] || [ "$3" = "-h" ]; }; then
	exec python3 main.py --help
	exit 0
fi

if [ -f '.venv/bin/activate' ]; then
	. .venv/bin/activate
else
	python3 -m venv .venv \
	&& . .venv/bin/activate
fi

# Installa dipendenze di sistema
pip install --upgrade pip setuptools wheel \
	&& pip install --upgrade torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129 \
	&& pip install -r requirements.txt || exit 1

# Installa Sageattention
if  ! pip show sageattention; then
	git clone https://github.com/thu-ml/SageAttention.git /tmp/SageAttention \
		&& pip install --no-build-isolation /tmp/SageAttention
fi

# Controlla se i ComfyUI Manager è già presente e aggiorna o clona se necessario
if [ -d 'custom_nodes/ComfyUI-Manager' ]; then
	(cd custom_nodes/ComfyUI-Manager && git pull)
else
	(cd custom_nodes && git clone https://github.com/Comfy-Org/ComfyUI-Manager.git)
fi

# Controlla se i wrapper Kijai sono già presenti e aggiorna o clona se necessario
if [ -d 'custom_nodes/ComfyUI-WanVideoWrapper' ]; then
	(cd custom_nodes/ComfyUI-WanVideoWrapper && git pull)
else
	(cd custom_nodes && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git)
fi

# Installa requirements.txt per ogni sottocartella di custom_nodes
for d in custom_nodes/*/ ; do
    if [ -f "$d/requirements.txt" ]; then
        pip install -r "$d/requirements.txt" || exit 1
    fi
done

exec python3 main.py "$@"