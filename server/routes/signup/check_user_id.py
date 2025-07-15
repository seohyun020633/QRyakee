from fastapi import APIRouter, HTTPException, Query
from db import get_connection

router = APIRouter()

@router.get("/", summary="사용자 ID 중복 체크")
def check_user_id(user_id: str = Query(..., min_length=4)):
    conn = get_connection()
    cursor = conn.cursor()
    
    print("🔍 커서 타입:", type(cursor))
    try:
        cursor.execute("SELECT COUNT(*) AS count FROM users WHERE user_id = %s", (user_id,))
        row = cursor.fetchone()
        count = row['count']   
        return {"exists": count > 0}
    except Exception as e:
        print("❌ DB 오류:", repr(e))
        raise HTTPException(status_code=500, detail="DB 오류 발생")
    finally:
        cursor.close()
        conn.close()
