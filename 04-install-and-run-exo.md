fn install exo
```bash
cd
sudo apt update && sudo apt install -y python3.12 python3.12-venv git
git clone https://github.com/exo-explore/exo.git
cd exo
python3.12 -m venv venv
source venv/bin/activate
pip install -e .
```

fn run exo
```bash
cd
cd exo
source venv/bin/activate
exo
```