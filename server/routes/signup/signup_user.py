from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import get_connection
import bcrypt 

router = APIRouter()

class UserSignup(BaseModel):
    user_id: str
    user_name: str
    resident_number: str
    phone: str
    city: str
    district: str
    takes_medicine: bool
    medicine_name: str | None
    user_password: str

@router.post("/", summary="사용자 회원가입")
def signup_user(user: UserSignup):
    conn = get_connection()
    cursor = conn.cursor()

    hashed_user_pw = bcrypt.hashpw(user.user_password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

    query = """
        INSERT INTO users
        (user_id, user_name, resident_number, phone, city, district,
         takes_medicine, medicine_name, user_password)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """ 
    try:
        cursor.execute(query, (
            user.user_id,
            user.user_name,
            user.resident_number,
            user.phone,
            user.city,
            user.district,
            user.takes_medicine,
            user.medicine_name,
            hashed_user_pw
        ))
        conn.commit()
        print("✅ DB에 저장 완료")

        return {"message": "회원가입 성공"}
    except Exception as e:
        conn.rollback()
        print("❌ DB 에러:", e)

        if "Duplicate entry" in str(e) and "phone" in str(e):
            raise HTTPException(status_code=409, detail="이미 등록되어있는 전화번호입니다.")

        raise HTTPException(status_code=400, detail="DB 오류 발생")
    finally:
        cursor.close()
        conn.close()
