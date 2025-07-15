from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import get_connection
import bcrypt

router = APIRouter()

class UserLogin(BaseModel):
    user_id: str
    user_password: str

@router.post("/", summary="사용자 로그인")
def login_user(user: UserLogin):
    conn = get_connection()
    cursor = conn.cursor()

    try:
        query = "SELECT user_password FROM users WHERE user_id = %s"
        cursor.execute(query, (user.user_id,))
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=401, detail="존재하지 않는 아이디입니다.")

        hashed_pw = result.get("user_password") if isinstance(result, dict) else result[0]

        if not bcrypt.checkpw(user.user_password.encode("utf-8"), hashed_pw.encode("utf-8")):
            raise HTTPException(status_code=401, detail="비밀번호가 일치하지 않습니다.")

        return {"message": "로그인 성공"}

    except HTTPException:
        raise  # 401은 그대로 다시 던지기

    except Exception as e:
        print("❌ 로그인 에러:", e)
        raise HTTPException(status_code=500, detail="서버 오류")

    finally:
        cursor.close()
        conn.close()