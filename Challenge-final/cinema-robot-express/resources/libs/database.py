from robot.api.deco import keyword
from pymongo import MongoClient
from bson import ObjectId
import bcrypt

client = MongoClient('mongodb://localhost:27017/')
db = client['cinema-app']

@keyword('Clean user from database')
def clean_user(user_email):
    users = db["users"]
    reservations = db["reservations"]
    u = users.find_one({"email": user_email})
    if u:
        reservations.delete_many({"user": u["_id"]})
        users.delete_many({"email": user_email})

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    reservations = db['reservations']
    u = users.find_one({"email": email})
    if u:
        reservations.delete_many({"user": u["_id"]})
    users.delete_many({'email': email})
    print(f"User {email} removed successfully")

@keyword('Insert user from database')
def insert_user(user):
    hash_pass = bcrypt.hashpw(user["password"].encode('utf-8'), bcrypt.gensalt(8)).decode('utf-8')
    doc = {
        'name': user["name"],
        'email': user["email"],
        'password': hash_pass,
        'role': user.get("role", "user")
    }
    users = db['users']
    result = users.insert_one(doc)
    print(f"User inserted with ID: {result.inserted_id}")
    return str(result.inserted_id)

@keyword('Reset session seats')
def reset_session_seats(session_id):
    sessions = db['sessions']
    result = sessions.update_one(
        {"_id": ObjectId(session_id)},
        {"$set": {"seats.$[].status": "available"}}
    )
    print(f"Reset {result.modified_count} session seats")

@keyword('Clean reservations from database')
def clean_reservations(user_email=None):
    reservations = db['reservations']
    if user_email:
        users = db['users']
        u = users.find_one({"email": user_email})
        if u:
            result = reservations.delete_many({"user": u["_id"]})
            print(f"Removed {result.deleted_count} reservations for user {user_email}")
    else:
        result = reservations.delete_many({})
        print(f"Removed all {result.deleted_count} reservations")

@keyword('Get user by email')
def get_user_by_email(email):
    users = db['users']
    user = users.find_one({"email": email})
    return user

@keyword('Update seat status')
def update_seat_status(session_id, row, number, status):
    sessions = db['sessions']
    result = sessions.update_one(
        {"_id": ObjectId(session_id), "seats.row": row, "seats.number": number},
        {"$set": {"seats.$.status": status}}
    )
    print(f"Updated seat {row}{number} status to {status}")
    return result.modified_count > 0


