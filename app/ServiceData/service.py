
from app.dataAccess.Repository import persistUser
from app.UI.dto import userDTO
from app.dataModel.model import user
from app.DtoModelMapper.mapper import DTOuser_userDB


def insert(userdto):
    usr = DTOuser_userDB(userdto)
    persistUser(usr)
    return 1
def checkUserForLogin(credent):
    pass


