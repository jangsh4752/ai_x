def mask_password(password) :
    return "*" * len(password)

if __name__ == "__main__" :
    password = input("password")
    print(mask_password(password))