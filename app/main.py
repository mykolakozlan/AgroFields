from fastapi import FastAPI

app = FastAPI()

@app.get("/api/fields/test")
def test():
    return {"status": "ok"}