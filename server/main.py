from fastapi import FastAPI
from routes.signup.signup_user import router as signup_user
from routes.signup.check_user_id import router as check_user_id_router
from routes.login.login_user import router as login_user
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 사용자
app.include_router(signup_user, prefix="/signup/user", tags=["User"])
app.include_router(login_user, prefix="/login/user", tags=["User"])
app.include_router(check_user_id_router, prefix="/signup/check_user_id", tags=["User"])

