from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Finance Tracker API is running"}


#concluir criação do ambiente ao fazer o database 
#aplicar auth ao final de tudo
#versionar 
#dockenizar