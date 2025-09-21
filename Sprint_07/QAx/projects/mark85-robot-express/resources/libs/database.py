from robot.api.deco import keyword
from pymongo import MongoClient

client = MongoClient('mongodb+srv://qa:xperience@cluster0.d8iw87s.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')

db = client['markdb']

@keyword('Remove user from database')
def remove_user(email):
    users = db['users']
    users.delete_one({'email': email})
    print(f"REMOVE USER BY {email} REMOVIDO COM SUCESSO!!.")

@keyword('Insert user from database')
def insert_user(user):
    # doc = {
    #     'name': name,
    #     'email': email,
    #     'password': password
    # }

    users = db['users']
    users.insert_one(user)
    print(f"USER {user} INSERIDO COM SUCESSO!!.")   

