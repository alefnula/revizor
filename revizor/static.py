from pathlib import Path
from fastapi import Depends, HTTPException

from revizor.config import Config


config = Config()


def get_app_path(path: str = ""):
    return config.app_dir / path


async def serve_static_file(
    requested_file_path: Path = Depends(get_app_path),
):
    if requested_file_path.is_file():
        return requested_file_path
    if requested_file_path == config.app_dir:
        return config.app_dir / "index.html"
    raise HTTPException(status_code=404, detail="Not Found")
