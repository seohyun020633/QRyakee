from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from db import get_connection

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

@router.post("/")
def signup_user(user: UserSignup):
    conn = get_connection()
    cursor = conn.cursor()
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
            user.user_password
        ))
        conn.commit()
        print("✅ DB에 저장 완료")

        return {"message": "회원가입 성공"}
    except Exception as e:
        conn.rollback()
        print("❌ DB 에러:", e)
        raise HTTPException(status_code=400, detail="DB 오류 발생")
    finally:
        cursor.close()
        conn.close()

