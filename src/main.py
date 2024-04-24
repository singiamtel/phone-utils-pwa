from fastapi import FastAPI, File, Request, Response, UploadFile
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from starlette.responses import HTMLResponse
from rembg import remove
import io
from PIL import Image

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")


@app.get("/", response_class=HTMLResponse)
def read_root(request: Request):
    return templates.TemplateResponse(name="index.html", context={"request": request})

@app.get("/subroute", response_class=HTMLResponse)
def read_subroute(request: Request):
    return templates.TemplateResponse(name="subroute.html", context={"request": request})

@app.get("/remove")
def remove_background_template(request: Request):
    return templates.TemplateResponse("remove.html", {"request": request})

@app.post("/remove", responses={200: {"content": {"image/png": {}}}})
async def remove_background(file: UploadFile = File(...)) -> Response:
    print(file)
    image_data = await file.read()
    image = Image.open(io.BytesIO(image_data))
    # image.save('image.png')
    print('converting image')
    converted = remove(image)
    print('converted')
    # converted.save('converted.png')
    converted_bytes = io.BytesIO()
    converted.save(converted_bytes, format='PNG')
    converted_bytes.seek(0)

    return Response(content=converted_bytes.getvalue(), media_type="image/png")
    # return {"file": file.filename}
