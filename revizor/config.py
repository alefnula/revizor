from pathlib import Path
from dataclasses import dataclass, field


@dataclass
class Config:
    project_dir: Path = field(init=False)
    app_dir: Path = field(init=False)

    def __post_init__(self):
        self.project_dir = Path(__file__).parents[1]
        self.app_dir = self.project_dir / "app" / "build" / "web"
