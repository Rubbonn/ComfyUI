#!/usr/bin/env sh

if [ "$#" -eq 3 ] && { [ "$3" = "--help" ] || [ "$3" = "-h" ]; }; then
	exec python3 main.py --help
	exit 0
fi

if [ -f 'bin/activate' ]; then
	. bin/activate
else
	python3 -m venv . \
	&& . bin/activate \
	&& pip install --upgrade pip \
	&& pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 \
	&& pip install -r requirements.txt
fi

exec python3 main.py "$@"