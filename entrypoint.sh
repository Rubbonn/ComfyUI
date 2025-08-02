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

# Install system dependencies
pip install --upgrade pip \
	&& pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 \
	&& pip install -r requirements.txt

# Installa requirements.txt per ogni sottocartella di custom_nodes
for d in custom_nodes/*/ ; do
    if [ -f "$d/requirements.txt" ]; then
        pip install -r "$d/requirements.txt"
    fi
done

exec python3 main.py "$@"