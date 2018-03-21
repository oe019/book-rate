from app.UI.dto import userDTO
from app.UI.dto import credentialDTO
from app.dataModel.model import user
from app.dataModel.model import credential
from app.dataModel.model import Genders

def DTOuser_userDB(userdto) -> user:
    #TODO typecheck
    usr = user()
    usr.name = userdto.firstname
    usr.surname = userdto.lastname
    usr.bithdate = userdto.birthdate
    usr.genderid = Genders.__dict__[userdto.gender].value
    usr.username = userdto.username
    usr.email = userdto.email
    usr.pasword = userdto.password
    return usr

def DTOcredential_credentialDB(cred)->credential:
    cr = credential()
    cr.username = cred.username
    cr.password = cred.password




