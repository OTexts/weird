# That's weird

### Anomaly and outlier detection using R

## Building the book

R package dependencies are managed with [uvr](https://github.com/nbafrank/uvr), a fast package manager for R. Install it, then set up the project environment:

```bash
uvr sync
```

This reads `uvr.toml`/`uvr.lock` and installs the required packages into a project-local environment at `.uvr/`.

Once the environment is set up, build the book with `make`:

```bash
make build     # Render all chapters to HTML (default target)
make preview   # Build, then launch a live preview in the browser
make clean     # Remove build artifacts
```
