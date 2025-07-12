from fastapi import FastAPI
from routes.signup import user_signup
# from routes.login import user_login, pharmacy_login
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 전체 허용 (개발용)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 회원가입 API
app.include_router(user_signup.router, prefix="/signup/user",tags=["User Signup"])
# app.include_router(pharmacy_signup.router, prefix="/pharmacy/signup")

# # 로그인 API
# app.include_router(user_login.router, prefix="/login/user")
# app.include_router(pharmacy_login.router, prefix="/login/pharmacy")