from enum import Enum
class Genders(Enum):
    male = 1
    female = 2
    other = 3


class user:
    def __init__(self,name=None,surname=None,bithdate=None,gender= 'other',username=None,email=None,password=None):
        if (gender is None):
            gender = 'other'
        self.name = name;
        self.surname = surname;
        self.bithdate = bithdate,
        self.genderid = Genders.__dict__[gender].value
        self.username = username
        self.email = email
        self.pasword = password

class credential:
    def __init__(self,username=None,pasword=None,email=None):
        self.username = username
        self.password=pasword
        self.email = email