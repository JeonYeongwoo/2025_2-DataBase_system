from flask import Flask, render_template, request
from database import get_db

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("welcome.html")

@app.route("/Insert")
def insert_page():
    return render_template("Insert.html")

@app.route("/Info")
def info_page():
    return render_template("Info.html")

# ---------- INSERT RESIDENT ----------
@app.route("/residentInsert", methods=["GET", "POST"])
def resident_insert():
    if request.method == "POST":
        resident_id = request.form["resident_id"]
        First_name = request.form["First_name"]
        last_name = request.form["last_name"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Resident (resident_id, First_name, last_name)
            VALUES (%s, %s, %s)
        """
        cursor.execute(sql, (resident_id, First_name, last_name))
        conn.commit()

        cursor.close()
        conn.close()

        return "Insert successful! Go to /ResidentInfo"

    return render_template("residentInsert.html")

# ---------- INSERT BUILDING ----------
@app.route("/buildingInsert", methods=["GET", "POST"])
def building_insert():
    if request.method == "POST":
        building_id = request.form["building_id"]
        construction_date = request.form["construction_date"]
        building_name = request.form["building_name"]
        address = request.form["address"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Building (building_id, construction_date, building_name, address)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (building_id, construction_date, building_name, address))
        conn.commit()

        cursor.close()
        conn.close()

        return "Building Insert successful!"

    return render_template("buildingInsert.html")


# ---------- INSERT UNIT ----------
@app.route("/unitInsert", methods=["GET", "POST"])
def unit_insert():
    if request.method == "POST":
        building_id = request.form["building_id"]
        unit_id = request.form["unit_id"]
        exclusive_area = request.form["exclusive_area"]
        common_area = request.form["common_area"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Unit (building_id, unit_id, exclusive_area, common_area)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(sql, (building_id, unit_id, exclusive_area, common_area))
        conn.commit()

        cursor.close()
        conn.close()

        return "Unit Insert successful!"

    return render_template("unitInsert.html")


# ---------- INSERT VEHICLE ----------
@app.route("/vehicleInsert", methods=["GET", "POST"])
def vehicle_insert():
    if request.method == "POST":
        vehicle_number = request.form["vehicle_number"]
        vehicle_type = request.form["vehicle_type"]
        resident_id = request.form["resident_id"]
        building_id = request.form["building_id"]
        registered_date = request.form["registered_date"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Vehicle (vehicle_number, vehicle_type, resident_id, building_id, registered_date)
            VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (vehicle_number, vehicle_type, resident_id, building_id, registered_date))
        conn.commit()

        cursor.close()
        conn.close()

        return "Vehicle Insert successful!"

    return render_template("vehicleInsert.html")


# ---------- INSERT UNIT_RESIDENT_RELATION ----------
@app.route("/unitResidentRelationInsert", methods=["GET", "POST"])
def unit_resident_relation_insert():
    if request.method == "POST":
        building_id = request.form["building_id"]
        unit_id = request.form["unit_id"]
        resident_id = request.form["resident_id"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Unit_Resident_relation (building_id, unit_id, resident_id)
            VALUES (%s, %s, %s)
        """
        cursor.execute(sql, (building_id, unit_id, resident_id))
        conn.commit()

        cursor.close()
        conn.close()

        return "Unit_Resident_relation Insert successful!"

    return render_template("unitResidentRelationInsert.html")


# ---------- INSERT RESIDENT_PHONE_NUMBER ----------
@app.route("/phoneInsert", methods=["GET", "POST"])
def phone_insert():
    if request.method == "POST":
        resident_id = request.form["resident_id"]
        phone_number = request.form["phone_number"]

        conn = get_db()
        cursor = conn.cursor()

        sql = """
            INSERT INTO Resident_PhoneNumber (resident_id, phone_number)
            VALUES (%s, %s)
        """
        cursor.execute(sql, (resident_id, phone_number))
        conn.commit()

        cursor.close()
        conn.close()

        return "Resident_PhoneNumber Insert successful!"

    return render_template("phoneInsert.html")




# ---------- LIST + SEARCH RESIDENTS ----------
@app.route("/ResidentInfo")
def list_residents():
    page = int(request.args.get("page", 1))   # 기본 페이지 1
    limit = 10                                # 10개 표시
    offset = (page - 1) * limit             # 오프셋 계산 - 이거 쓰면 페이징 가능

    q = request.args.get("q", "").strip()    # 검색어 (resident_id, 이름 등)

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    if q:  # 검색어가 있는 경우: 특정 사람만 조회
        # 숫자로만 입력한 경우 resident_id로 검색
        if q.isdigit():
            cursor.execute("""
                SELECT r.resident_id, r.First_name, r.last_name, p.phone_number
                FROM Resident r
                JOIN Resident_PhoneNumber p 
                    ON r.resident_id = p.resident_id
                WHERE r.resident_id = %s
                ORDER BY r.resident_id ASC
            """, (q,))
            residents = cursor.fetchall()

            total = len(residents)
            total_pages = 1

        else:
            like_q = f"%{q}%"
            cursor.execute("""
                SELECT r.resident_id, r.First_name, r.last_name, p.phone_number
                FROM Resident r
                JOIN Resident_PhoneNumber p 
                    ON r.resident_id = p.resident_id
                WHERE r.First_name LIKE %s OR r.last_name LIKE %s
                ORDER BY r.resident_id ASC
            """, (like_q, like_q))
            residents = cursor.fetchall()

            total = len(residents)
            total_pages = 1

    else:
        # 검색어 없으면 기존처럼 페이징 처리
        cursor.execute("""
            SELECT r.resident_id, r.First_name, r.last_name, p.phone_number
            FROM Resident r
            JOIN Resident_PhoneNumber p 
                ON r.resident_id = p.resident_id
            ORDER BY r.resident_id ASC
            LIMIT %s OFFSET %s
        """, (limit, offset))
        residents = cursor.fetchall()

        cursor.execute("SELECT COUNT(*) AS cnt FROM Resident")
        total = cursor.fetchone()["cnt"]
        total_pages = (total + limit - 1) // limit

    cursor.close()
    conn.close()

    return render_template(
        "ResidentInfo.html",
        residents=residents,
        page=page,
        total_pages=total_pages,
        q=q   # 현재 검색어 넘겨주기
    )


# ---------- LIST ALL Units + SEARCH ----------
@app.route("/UnitInfo")
def unit_info():
    page = int(request.args.get("page", 1))   # 기본 페이지 1
    limit = 10                                # 10개 표시
    offset = (page - 1) * limit             # 오프셋 계산 - 이거 쓰면 페이징 가능

    q = request.args.get("q", "").strip()    # 검색어 (building_id, unit_id, building_name, resident_name 등)

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    if q:  # 검색어가 있는 경우
        if q.isdigit():
            #  숫자면 building_id 또는 unit_id 기준 검색
            cursor.execute("""
                SELECT U.building_id, U.unit_id, U.exclusive_area, 
                       U.common_area, B.building_name
                FROM Unit U
                JOIN Building B ON U.building_id = B.building_id
                WHERE U.building_id = %s OR U.unit_id = %s
                ORDER BY U.building_id, U.unit_id
            """, (q, q))
        else:
            #  문자열이면 건물 이름 + 그 유닛에 사는 사람 이름으로 검색
            like_q = f"%{q}%"
            cursor.execute("""
                SELECT 
                    U.building_id, 
                    U.unit_id, 
                    U.exclusive_area, 
                    U.common_area, 
                    B.building_name
                FROM Unit U
                JOIN Building B ON U.building_id = B.building_id
                WHERE 
                    B.building_name LIKE %s
                    OR
                    EXISTS (
                        SELECT *
                        FROM Unit_Resident_relation R
                        JOIN Resident r2 
                            ON R.resident_id = r2.resident_id
                        WHERE R.building_id = U.building_id
                          AND R.unit_id = U.unit_id
                          AND (r2.First_name LIKE %s OR r2.last_name LIKE %s)
                    )
                ORDER BY U.building_id, U.unit_id
            """, (like_q, like_q, like_q))
        
        units = cursor.fetchall()
        total = len(units)
        total_pages = 1  # 검색 결과는 일단 한 페이지로 처리
    else:
        cursor.execute("""
            SELECT U.building_id, U.unit_id, U.exclusive_area, 
                   U.common_area, B.building_name
            FROM Unit U
            JOIN Building B ON U.building_id = B.building_id
            ORDER BY U.building_id, U.unit_id
            LIMIT %s OFFSET %s
        """, (limit, offset))
        units = cursor.fetchall()

        cursor.execute("SELECT COUNT(*) AS cnt FROM Unit")
        total = cursor.fetchone()["cnt"]
        total_pages = (total + limit - 1) // limit

    cursor.close()
    conn.close()

    return render_template(
        "UnitInfo.html",
        units=units,
        page=page,
        total_pages=total_pages,
        q=q
    )



# ---------- LIST ALL Vehicles + SEARCH ----------
@app.route("/VehicleInfo")
def list_vehicles():
    page = int(request.args.get("page", 1))   # 기본 페이지 1
    limit = 10                                # 10개 표시
    offset = (page - 1) * limit             # 오프셋 계산 - 이거 쓰면 페이징 가능

    q = request.args.get("q", "").strip()    # 검색어(차량번호, 타입, resident_id, building_id 등)

    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    if q:
        if q.isdigit():
            # 숫자면 vehicle_number, resident_id, building_id 쪽으로 검색
            cursor.execute("""
                SELECT
                    vehicle_number,
                    vehicle_type,
                    resident_id,
                    building_id,
                    registered_date
                FROM Vehicle
                WHERE vehicle_number = %s
                   OR resident_id = %s
                   OR building_id = %s
                ORDER BY vehicle_number
            """, (q, q, q))
        else:
            # 문자열이면 vehicle_type으로 LIKE 검색 (예: Sedan, SUV 등)
            like_q = f"%{q}%"
            cursor.execute("""
                SELECT
                    vehicle_number,
                    vehicle_type,
                    resident_id,
                    building_id,
                    registered_date
                FROM Vehicle
                WHERE vehicle_type LIKE %s
                ORDER BY vehicle_number
            """, (like_q,))
        
        vehicles = cursor.fetchall()
        total = len(vehicles)
        total_pages = 1  # 검색 결과는 한 페이지로
    else:
        # 페이징 로직
        cursor.execute("""
            SELECT
                vehicle_number,
                vehicle_type,
                resident_id,
                building_id,
                registered_date
            FROM Vehicle
            ORDER BY vehicle_number
            LIMIT %s OFFSET %s
        """, (limit, offset))
        vehicles = cursor.fetchall()

        cursor.execute("SELECT COUNT(*) AS cnt FROM Vehicle")
        total = cursor.fetchone()["cnt"]
        total_pages = (total + limit - 1) // limit

    cursor.close()
    conn.close()

    return render_template(
        "VehicleInfo.html",
        vehicles=vehicles,
        page=page,
        total_pages=total_pages,
        q=q
    )




if __name__ == "__main__":
    app.run(debug=True)
