from fastapi import FastAPI
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles


from revizor.config import Config
from revizor.static import serve_static_file
from revizor.experiment import app_exp


config = Config()
app = FastAPI()


# Static files
app.get(
    "/{path:path}",
    response_class=FileResponse,
    include_in_schema=False,
)(serve_static_file)
app.mount(
    "/",
    StaticFiles(directory=config.app_dir),
    name="static",
)


# Experiment
app.mount("/exp", app_exp)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080)
