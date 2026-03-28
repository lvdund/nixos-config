
- **Install Python & set default version**  
  ```bash
  uv python install 3.11.9
  uv python pin 3.11.9 --global
  ```

- **Install global CLI tools (like `pip install --user`)**  
  ```bash
  uv pip install --python $(uv python dir) black ruff
  ```
  > Binaries are placed in `~/.local/bin` (ensure it’s in your `PATH`).

- **Install from requirements file**  
  ```bash
  uv pip install -r requirements.txt
  ```

- **Create & use a project environment**  
  ```bash
  uv venv          # creates .venv
  uv run python    # runs in .venv (no activation needed)
  uv pip install -r requirements.txt  # installs into .venv
  ```
