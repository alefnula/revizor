from pathlib import Path

import aiofiles
from pydantic import BaseModel
from fastapi import FastAPI, HTTPException


app_exp = FastAPI(name="experiment")


class Item(BaseModel):
    key: str
    another_key: int


@app_exp.get("/get_item")
async def get_item():
    return Item(key="value", another_key=123)


@app_exp.get("/exp/{name}/{threshold}/{file_number}")
async def get_exp_texts(name: str, threshold: float, file_number: int):
    file_path = Path(f"exp/{name}/{threshold}/{file_number}.txt")

    if not file_path.exists():
        raise HTTPException(status_code=404, detail="File not found")

    # Asynchronously read the file
    async with aiofiles.open(file_path, mode="r") as f:
        content = await f.read()

    # Return the content as a response (you can also handle this differently, e.g., stream the content)
    return {"content": content}
