class userDTO:
    def __init__(self,name=None,surname=None,birthdate=None,gender=None,username=None,email=None,password=None):
        self.firstname = name
        self.lastname = surname
        self.birthdate = birthdate
        self.gender = gender
        self.username = username
        self.email = email
        self.password = password
class credentialDTO:
    def __init__(self,userinfo=None,password=None):
        self.username = userinfo
        self.password = password