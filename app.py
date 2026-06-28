import os

DB_USER = os.getenv("DB_USER", "your_oracle_username")
DB_PASSWORD = os.getenv("DB_PASSWORD", "your_oracle_password")
DB_DSN = os.getenv("DB_DSN", "localhost:1521/xe")

from flask import Flask, render_template, request, redirect, url_for, session, flash
import oracledb
from datetime import datetime

# Uncomment and update this path if Oracle Instant Client is required on your system.
# oracledb.init_oracle_client(lib_dir=r"path_to_oracle_instant_client")

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "change-this-secret-key")


# This function opens connection with Oracle database.
def get_connection():
    return oracledb.connect(
        user=DB_USER,
        password=DB_PASSWORD,
        dsn=DB_DSN
    )


# This checks if user is logged in.
def is_logged_in():
    return "username" in session


# This checks if logged-in user is admin.
def is_admin():
    return session.get("role") == "ADMIN"


# Login page.
@app.route("/", methods=["GET", "POST"])
def login():
    if is_logged_in():
        if is_admin():
            return redirect(url_for("admin_dashboard"))
        else:
            return redirect(url_for("guest_dashboard"))

    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        try:
            conn = get_connection()
            cursor = conn.cursor()

            cursor.execute(
                "SELECT user_id, role FROM APP_USER WHERE username = :1 AND password = :2",
                (username, password)
            )

            row = cursor.fetchone()

            cursor.close()
            conn.close()

            if row:
                session["username"] = username
                session["role"] = row[1]

                if row[1] == "ADMIN":
                    return redirect(url_for("admin_dashboard"))
                else:
                    return redirect(url_for("guest_dashboard"))
            else:
                flash("Invalid username or password.")

        except Exception as e:
            flash(f"Database error: {e}")

    return render_template("index.html", page="login")


# Logout clears the current session.
@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


# Admin dashboard page.
@app.route("/admin")
def admin_dashboard():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    return render_template("index.html", page="admin_dashboard")


# Guest dashboard page.
@app.route("/guest")
def guest_dashboard():
    if not is_logged_in():
        return redirect(url_for("login"))

    return render_template("index.html", page="guest_dashboard")


# View hotels. Admin and guest both can access this.
@app.route("/hotels")
def view_hotels():
    if not is_logged_in():
        return redirect(url_for("login"))

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT hotel_id, hotel_name, star_rating, city, country FROM HOTEL")
        hotels = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        hotels = []

    return render_template("index.html", page="view_hotels", hotels=hotels)


# View rooms.
# Admin sees all rooms. Guest sees only available rooms.
@app.route("/rooms")
def view_rooms():
    if not is_logged_in():
        return redirect(url_for("login"))

    try:
        conn = get_connection()
        cursor = conn.cursor()

        if is_admin():
            cursor.execute(
                "SELECT r.room_id, h.hotel_name, r.room_number, r.room_type, "
                "r.capacity, r.price_per_night, r.status "
                "FROM ROOM r JOIN HOTEL h ON r.hotel_id = h.hotel_id"
            )
        else:
            cursor.execute(
                "SELECT r.room_id, h.hotel_name, r.room_number, r.room_type, "
                "r.capacity, r.price_per_night, r.status "
                "FROM ROOM r JOIN HOTEL h ON r.hotel_id = h.hotel_id "
                "WHERE r.status = 'Available'"
            )

        rooms = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        rooms = []

    return render_template("index.html", page="view_rooms", rooms=rooms)


# View reservations using reservation_details_view.
# This is admin only.
@app.route("/reservations")
def view_reservations():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT first_name, last_name, hotel_name, room_number, reservation_id, "
            "check_in_date, check_out_date, total_amount FROM reservation_details_view"
        )

        reservations = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        reservations = []

    return render_template("index.html", page="view_reservations", reservations=reservations)


# This route is for showing the view clearly in viva.
# It uses the same Oracle view: reservation_details_view.
@app.route("/guest-reservations-view")
def guest_reservations_view():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT first_name, last_name, hotel_name, room_number, reservation_id, "
            "check_in_date, check_out_date, total_amount FROM reservation_details_view"
        )

        guest_reservations = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        guest_reservations = []

    return render_template(
        "index.html",
        page="guest_reservations_view",
        guest_reservations=guest_reservations
    )


# View guests. Admin only.
@app.route("/guests")
def view_guests():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT guest_id, first_name, last_name, email, city, country FROM GUEST")
        guests = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        guests = []

    return render_template("index.html", page="view_guests", guests=guests)


# View services. Admin and guest both can access this.
@app.route("/services")
def view_services():
    if not is_logged_in():
        return redirect(url_for("login"))

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT service_id, service_name, description, price FROM SERVICE")
        services = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        services = []

    return render_template("index.html", page="view_services", services=services)


# View payments. Admin only.
@app.route("/payments")
def view_payments():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT payment_id, reservation_id, amount, method, payment_date, payment_status FROM PAYMENT"
        )

        payments = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        payments = []

    return render_template("index.html", page="view_payments", payments=payments)

@app.route("/service-usage-view")
def service_usage_view():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute(
            "SELECT reservation_id, service_name, quantity, subtotal FROM service_usage_view"
        )

        service_usage = cursor.fetchall()

        cursor.close()
        conn.close()

    except Exception as e:
        flash(f"Error: {e}")
        service_usage = []

    return render_template(
        "index.html",
        page="service_usage_view",
        service_usage=service_usage
    )

# Add guest. Admin only.
# This calls the add_guest procedure in Oracle.
@app.route("/add-guest", methods=["GET", "POST"])
def add_guest():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    if request.method == "POST":
        try:
            guest_id = int(request.form["guest_id"])
            first_name = request.form["first_name"]
            last_name = request.form["last_name"]
            email = request.form["email"]
            street = request.form["street"]
            city = request.form["city"]
            country = request.form["country"]

            conn = get_connection()
            cursor = conn.cursor()

            cursor.callproc(
                "add_guest",
                [guest_id, first_name, last_name, email, street, city, country]
            )

            conn.commit()

            cursor.close()
            conn.close()

            flash("Guest added successfully!")
            return redirect(url_for("view_guests"))

        except Exception as e:
            flash(f"Error adding guest: {e}")

    return render_template("index.html", page="add_guest")


# Add reservation. Admin only.
# This calls add_reservation procedure in Oracle.
# The procedure checks room availability before inserting.
# After insert, Oracle trigger will change room status to Occupied.
@app.route("/add-reservation", methods=["GET", "POST"])
def add_reservation():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    if request.method == "POST":
        try:
            reservation_id = int(request.form["reservation_id"])
            guest_id = int(request.form["guest_id"])
            room_id = int(request.form["room_id"])

            check_in_date = datetime.strptime(request.form["check_in_date"], "%Y-%m-%d")
            check_out_date = datetime.strptime(request.form["check_out_date"], "%Y-%m-%d")

            status = request.form["status"]
            total_amount = float(request.form["total_amount"])

            conn = get_connection()
            cursor = conn.cursor()

            cursor.callproc(
                "add_reservation",
                [
                    reservation_id,
                    guest_id,
                    room_id,
                    check_in_date,
                    check_out_date,
                    status,
                    total_amount
                ]
            )

            conn.commit()

            cursor.close()
            conn.close()

            flash("Reservation added successfully! Room status updated by trigger.")
            return redirect(url_for("view_reservations"))

        except Exception as e:
            flash(f"Error adding reservation: {e}")

    return render_template("index.html", page="add_reservation")


# Update room status. Admin only.
# This calls update_room_status procedure in Oracle.
@app.route("/update-room", methods=["GET", "POST"])
def update_room():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    if request.method == "POST":
        try:
            hotel_id = int(request.form["hotel_id"])
            room_number = int(request.form["room_number"])
            status = request.form["status"]

            conn = get_connection()
            cursor = conn.cursor()

            cursor.callproc("update_room_status", [hotel_id, room_number, status])

            conn.commit()

            cursor.close()
            conn.close()

            flash("Room status updated successfully!")
            return redirect(url_for("view_rooms"))

        except Exception as e:
            flash(f"Error updating room: {e}")

    return render_template("index.html", page="update_room")


# Delete reservation. Admin only.
# This calls delete_reservation procedure in Oracle.
# After deletion, Oracle trigger will change room status to Available.
@app.route("/delete-reservation", methods=["GET", "POST"])
def delete_reservation():
    if not is_logged_in() or not is_admin():
        return render_template("index.html", page="access_denied")

    if request.method == "POST":
        try:
            reservation_id = int(request.form["reservation_id"])

            conn = get_connection()
            cursor = conn.cursor()

            cursor.callproc("delete_reservation", [reservation_id])

            conn.commit()

            cursor.close()
            conn.close()

            flash("Reservation deleted. Room is now Available by trigger.")
            return redirect(url_for("view_reservations"))

        except Exception as e:
            flash(f"Error deleting reservation: {e}")

    return render_template("index.html", page="delete_reservation")


# This starts the Flask website.
if __name__ == "__main__":
    app.run(debug=True)